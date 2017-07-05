package cn.arvix.ontheway.ducuments.service;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.entity.search.PageRequest;
import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.base.common.utils.MessageUtils;
import cn.arvix.base.common.utils.SpringUtils;
import cn.arvix.ontheway.attachment.service.AgileAttachmentService;
import cn.arvix.ontheway.ducuments.dto.QiniuImgEditDTO;
import cn.arvix.ontheway.ducuments.entity.Document;
import cn.arvix.ontheway.ducuments.entity.DocumentDir;
import cn.arvix.ontheway.ducuments.entity.DocumentDirType;
import cn.arvix.ontheway.sys.auth.service.AuthService;
import cn.arvix.ontheway.sys.config.service.ConfigService;
import cn.arvix.ontheway.sys.user.entity.User;
import cn.arvix.ontheway.sys.utils.RegExpValidatorUtils;
import cn.arvix.qiniu.utils.QiniuDocumentUrlUtil;
import cn.arvix.qiniu.utils.QiniuDownloadUtil;
import cn.arvix.qiniu.utils.QiniuResourceManagerUtil;
import cn.arvix.qiniu.utils.QiniuUploadUtil;
import com.google.common.collect.Maps;
import com.qiniu.common.QiniuException;
import com.qiniu.storage.model.FetchRet;
import com.qiniu.util.Auth;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.*;

/**
 * @author Created by yangyang on 2017/3/31.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class DocumentService extends BaseServiceImpl<Document, Long> {

    private final DocumentDirService documentDirService;

    private final QiniuResourceManagerUtil qiniuResourceManagerUtil;

    private final QiniuDownloadUtil qiniuDownloadUtil;

    private final ConfigService configService;

    protected final Logger log = LoggerFactory.getLogger(DocumentService.class);

    @Autowired
    public DocumentService(DocumentDirService documentDirService,
                           QiniuResourceManagerUtil qiniuResourceManagerUtil,
                           QiniuDownloadUtil qiniuDownloadUtil,
                           ConfigService configService) {
        this.documentDirService = documentDirService;
        this.qiniuResourceManagerUtil = qiniuResourceManagerUtil;
        this.qiniuDownloadUtil = qiniuDownloadUtil;
        this.configService = configService;
    }

    private QiniuUploadUtil qiniuUploadUtil;

    @Autowired
    public void setQiniuUploadUtil(QiniuUploadUtil qiniuUploadUtil) {
        this.qiniuUploadUtil = qiniuUploadUtil;
    }

    private AuthService authService;

    @Autowired
    public void setAuthService(AuthService authService) {
        this.authService = authService;
    }

    /**
     * 保存前端上传的文件
     * 文件中如果父节点ID = -1，表示当前文件保存在附件文件夹中，为空直接保存在根节点下，
     * 其他都保存在对应文件夹下
     *
     * @param m 文件对象
     * @return 保存结果
     */
    public JSONResult save_(Document m) {
        User user = webContextUtils.getCheckCurrentUser();
        //保存在附件中
        if (Objects.equals(m.getParentId(), -1L)) {
            //获取当前公司的附件文件夹
            DocumentDir documentDir = documentDirService.getCompanyAttachment(user);
            if (documentDir == null) return JsonUtil.getFailure(MessageUtils.message("document.save.error"), "document.save.error");
            m.setParentId(documentDir.getId());
        } else {
            if (m.getParentId() != null) {
                documentDirService.findOne(m.getParentId());
            }
        }
        m.setId(null);
        m.setCompanyId(null);
        m.setDownloadNo(0);
        m.setFileUrl(m.getNewName());
        m.setUser(user);
        return super.save_(m);
    }

    /**
     * 更新文件信息，这里目前只允许更新文件名称和文件详细描述
     *
     * @param m 实体
     * @return 更新后的文件数据
     */
    public JSONResult updateDocument(Document m, String property) {
        Document document = super.findOne(m.getId());
        if ("content".equals(property)) {
            document.setContent(m.getContent());
        } else if ("name".equals(property)) {
            document.setName(m.getName());
        }
        return super.update_(document);
    }

    /**
     * 删除文件
     *
     * @param id 主键
     * @return 删除结果
     */
    @Transactional(rollbackFor = Exception.class)
    public JSONResult delete_(Long id) {
        //检查删除数据是否用户公司信息，判断当前用户公司信息与删除数据信息是否一致
        Document document = findOne(id);
        //检查一下当前文件是否在附件服务中使用过，等附件系统完善后使用
        AgileAttachmentService agileAttachmentService = SpringUtils.getBean(AgileAttachmentService.class);
        if (agileAttachmentService.checkDocument(document.getId()))
            return JsonUtil.getFailure(MessageUtils.message("document.delete.error1"), "document.delete.error1");
        User user = webContextUtils.getCheckCurrentUser();
        //如果用户拥有可以删除其他公司数据权限 也可以删除，这里等权限系统完善后加入
        if (document.getCompanyId() != null && document.getCompanyId().equals(user.getCompanyId())) {
            //先删除七牛端，成功后再移除本地
            try {
                qiniuResourceManagerUtil.deleteFile(document.getFileUrl());
            } catch (QiniuException e) {
                log.error("七牛文件删除错误,msg:{}", e.response.error);
                if (webContextUtils.ifDev()) {
                    e.printStackTrace();
                }
            }
            super.delete(document);
            return JsonUtil.getSuccess(MessageUtils.message(CommonContact.DELETE_SUCCESS), CommonContact.DELETE_SUCCESS);
        }
        return JsonUtil.getFailure(MessageUtils.message(CommonContact.NO_PERMISSION), CommonContact.NO_PERMISSION);
    }


    /**
     * 文件移动
     * moveId = -1 时，文件移动到根目录下
     *
     * @param id     文件ID
     * @param moveId 移动的文件夹
     * @return 移动结果
     */
    public JSONResult move(Long id, Long moveId) {
        Document document = findOne(id);
        if (moveId == -1) {
            document.setParentId(null);
        } else {
            //检查一下文件夹是否存在
            documentDirService.findOne(moveId);
            document.setParentId(moveId);
        }
        super.update(document);
        return JsonUtil.getSuccess(MessageUtils.message("document.move.success"), "document.move.success");
    }

    /**
     * 获取当前用户能查看的所有文件以及文件夹
     * 文件可以使用分页请求和请求所有
     * 文件夹直接获取所有，文件夹默认排序在文件前
     * 分页请求时，number>0后，不会再加载文件夹
     * 默认按创建时间排序
     *
     * @param number    当前页 ，如果 number = -1 不分页查询
     * @param size      每页大小
     * @param direction 排序方式
     * @param order     排序字段
     * @param pId       当前页父节点
     * @return 用户的文件以及文件夹，
     */
    public JSONResult user(Integer number, Integer size, Sort.Direction direction, String order, Long pId) {
        Sort sort;
        if (StringUtils.isEmpty(order)) {
            sort = new Sort(Sort.Direction.ASC, "dateCreated");
        } else {
            sort = new Sort(direction, order);
        }
        User user = webContextUtils.getCheckCurrentUser();
        if (user.getCompanyId() == null) {//如果账号没有saas公司信息，目前设置为不允许这样的用户请求数据，以后可以通过权限控制
            return JsonUtil.getFailure(MessageUtils.message(CommonContact.NO_PERMISSION), CommonContact.NO_PERMISSION);
        }
        //小于 加载文件夹
        Map<String, Object> jsonMap = Maps.newHashMap();
        if (number < 1) {
            jsonMap.put("documentDirs", documentDirService.findAllByUser(user, pId, sort));
        }
        //加载文件 number == -1 全部加载 否则分页加载
        Searchable searchable = Searchable.newSearchable(null, number == -1 ? null : new PageRequest(number, size), sort);
        Map<String, Object> params = Maps.newHashMap();
        params.put("companyId_eq", user.getCompanyId());
        DocumentDir documentDir = null;
        if (pId != null) {
            params.put("parentId_eq", pId);
            documentDir = documentDirService.findOne(pId);
        } else {
            params.put("parentId_isNull", null);
        }
        //获取当前文件夹id,判断文件夹类型,如果是附件文件夹，只允许查看自己的图片
        //跟目录文件默认共有
        if (documentDir != null) {
            Boolean ifAdmin = SecurityUtils.getSubject().isPermitted("Document:admin");
            if (DocumentDirType.attachment.equals(documentDir.getDocumentDirType()) && !ifAdmin) {
                params.put("user.id_eq", user.getId());
            }
        }
        searchable.addSearchParams(params);
        if (number == -1) {
            List<Map<String, Object>> documentMapList = JsonUtil.getBaseEntityMapList(super.findAllWithSort(searchable));
            if (documentMapList != null) {
                this.bulidDocument(documentMapList, user, documentDir);
            }
            jsonMap.put("documents", documentMapList);
        } else {
            Page<Document> page = super.findAll(searchable.setEnableToMap(true));
            if (page.getContent() != null) {
                this.bulidDocument(page.getContent(), user, documentDir);
            }
            jsonMap.put("documents", page);
        }
        //设置一下排序方式
        jsonMap.put("sort", sort);
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.FETCH_SUCCESS), CommonContact.FETCH_SUCCESS, jsonMap);
    }

    private void bulidDocument(List<?> documentMapList, User user, DocumentDir documentDir) { //构建图片缩略图访问地址
        Auth auth = qiniuUploadUtil.getAuth();
        String urlFix = configService.getConfigString(CommonContact.QINIU_BUCKET_URL) + "/";
        //增加目录权限后，这里需要获取一下当前用户对当前数据的访问权限 文库管理员可以管理所有文件，查看所有文件
        Boolean ifAdmin = SecurityUtils.getSubject().isPermitted("Document:admin");
        Integer authOpType = -1;
        if (!ifAdmin) { //没有管理员权限,获取当前用户对当前文件夹的操作权限
            authOpType = authService.getOpTypeByOpId(documentDir.getId(), 1, user);
        }
        Integer finalAuthOpType = authOpType;
        //附件文件夹
        Boolean ifAttachment = DocumentDirType.attachment.equals(documentDir.getDocumentDirType());

        documentMapList.forEach(x -> {
            @SuppressWarnings("unchecked") Map<String, Object> map = (Map<String, Object>) x;

            //documentDir 公共文件夹所有人拥有文件上传、编辑权限，文件删除权限只有管理员或者上传者拥有

            //是否可编辑
            Boolean ifEdit = Boolean.FALSE;
            //是否可删除
            Boolean ifDelete = Boolean.FALSE;

            //公共所有人可编辑 2 表示可编辑权限 1 表示只读权限
            if (ifAdmin
                    || ifAttachment
                    || finalAuthOpType == 2
                    || DocumentDirType.common.equals(documentDir.getDocumentDirType())) {
                ifEdit = Boolean.TRUE;
            }
            //公共所有人或者管理员可删除
            if (ifAdmin
                    || ifAttachment
                    || finalAuthOpType == 2
                    || (DocumentDirType.common.equals(documentDir.getDocumentDirType())
                    && user.getId().equals(map.get("uid")))) {
                ifDelete = Boolean.TRUE;
            }
            map.put("ifEdit", ifEdit);
            map.put("ifDelete", ifDelete);
            if (RegExpValidatorUtils.match(CommonContact.DOCUMENT_IMG_PATTERN,
                    map.get("fileUrl").toString())) {
                map.put("imgUrl", qiniuDownloadUtil.getDownloadToken(auth,
                        QiniuDocumentUrlUtil.getImgUrl(urlFix, map.get("fileUrl").toString(), "imageView2/1/w/200/h/240"), null));
                map.put("imgUrlYuan", qiniuDownloadUtil.getDownloadToken(auth,
                        QiniuDocumentUrlUtil.getImgUrl(urlFix, map.get("fileUrl").toString(),
                                "imageView2/2/w/" + map.get("w") + "/h/" + map.get("h") + "/interlace/1"), null));
//                Integer w = Checks.toInteger(String.valueOf(map.get("w")));
//                Integer h = Checks.toInteger(String.valueOf(map.get("h")));
//                if (w > 1200) {
//                    h = 1200 * h / w;
//                    map.put("w", 1200);
//                    map.put("h", h);
//                }
            }
        });
    }

    /**
     * 通过文件ID获取文件下载路径
     *
     * @param id  文件ID
     * @param fix 文件修饰
     * @return 文件下载路径
     */
    public JSONResult documentUrlById(Long id, String fix) {
        Document document = super.findOne(id);
        //验证一下当前文件是否是当前公司的
        if (!Objects.equals(document.getCompanyId(), webContextUtils.getCompanyId()))
            return JsonUtil.getFailure(MessageUtils.message(CommonContact.NO_PERMISSION), CommonContact.NO_PERMISSION);
        //目前这里不提供公司自定义七牛云存储，以后加上
        //final String urlFix = configService.getConfigString(CommonContact.QINIU_BUCKET_URL, webContextUtils.getCompanyId());
        String url = configService.getConfigString(CommonContact.QINIU_BUCKET_URL) + "/" + document.getFileUrl();
        if (!StringUtils.isEmpty(fix)) {
            if (url.contains("?")) {
                url = url + "|" + fix;
            } else {
                url = url + "?" + fix;
            }
        }
        Map<String, Object> map = Maps.newConcurrentMap();
        map.put("url", qiniuDownloadUtil.getDownloadToken(url));
        map.put("id", id);
        return JsonUtil.getSuccess(CommonContact.FETCH_SUCCESS, CommonContact.FETCH_SUCCESS, map);
    }

    /**
     * 通过文件ID获取文件下载路径
     *
     * @param ids 文件ID
     * @param fix 文件修饰
     * @return 文件下载路径
     */
    public JSONResult documentUrlByIds(List<Long> ids, String fix) {
        Map<String, Object> params = Maps.newHashMap();
        params.put("companyId_eq", webContextUtils.getCompanyId());
        params.put("id_in", ids);
        List<Document> documents = super.findAllWithNoPageNoSort(Searchable.newSearchable(params));
        //目前这里不提供公司自定义七牛云存储，以后加上
        //final String urlFix = configService.getConfigString(CommonContact.QINIU_BUCKET_URL, webContextUtils.getCompanyId());
        final String urlFix = configService.getConfigString(CommonContact.QINIU_BUCKET_URL) + "/";
        if (documents != null && documents.size() > 0) {
            List<Map<String, Object>> list = new ArrayList<>(documents.size());
            documents.forEach(x -> {
                Map<String, Object> jsonMap = Maps.newHashMap();
                jsonMap.put("id", x.getId());
                if (!StringUtils.isEmpty(fix)) {
                    if (x.getFileUrl().contains("?")) {
                        jsonMap.put("url", urlFix + x.getFileUrl() + "|" + fix);
                    } else {
                        jsonMap.put("url", urlFix + x.getFileUrl() + "?" + fix);
                    }
                } else {
                    jsonMap.put("url", urlFix + x.getFileUrl());
                }
                list.add(jsonMap);
            });
            return JsonUtil.getSuccess(CommonContact.FETCH_SUCCESS, CommonContact.FETCH_SUCCESS,
                    qiniuDownloadUtil.getDownloadToken(list));
        }
        return JsonUtil.getFailure(CommonContact.NOT_FUND, CommonContact.NOT_FUND_CODE);
    }

    /**
     * 获取文件详情
     * 如果文件是图片类型，这里增加返回图片缩略图 限制宽 800px
     *
     * @param id 数据ID
     * @return 详细信息
     */
    public JSONResult findOneDocument(Long id) {
        User user = webContextUtils.getCheckCurrentUser();
        Document document = super.findOne(id);
        Map<String, Object> jsonMap = document.toMap();
        //图片
        if (RegExpValidatorUtils.match(CommonContact.DOCUMENT_IMG_PATTERN,
                jsonMap.get("fileUrl").toString())) {
            Auth auth = qiniuUploadUtil.getAuth();
            String urlFix = configService.getConfigString(CommonContact.QINIU_BUCKET_URL) + "/";
            jsonMap.put("ifImg", true);
            jsonMap.put("imgUrlTwo", qiniuDownloadUtil.getDownloadToken(auth, QiniuDocumentUrlUtil.getImgUrl(urlFix, jsonMap.get("fileUrl").toString(),
                    "imageView2/2/w/800/interlace/1"), null));
            jsonMap.put("imgUrlYuan", qiniuDownloadUtil.getDownloadToken(auth,
                    QiniuDocumentUrlUtil.getImgUrl(urlFix, jsonMap.get("fileUrl").toString(),
                            "imageView2/2/w/" + jsonMap.get("w") + "/h/" + jsonMap.get("h") + "/interlace/1"), null));
        }
        jsonMap.put("ifCreater", Objects.equals(document.getUser().getId(), user.getId()));
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.FETCH_SUCCESS), CommonContact.FETCH_SUCCESS, jsonMap);
    }

    /**
     * 七牛图片旋转保存
     *
     * @param dto 请求数据
     * @return 操作结果
     */
    @Transactional(rollbackFor = Exception.class)
    public JSONResult qiniuRotate(QiniuImgEditDTO dto) {
        Document document = super.findOne(dto.getId());
        String urlFix = configService.getConfigString(CommonContact.QINIU_BUCKET_URL) + "/";
        String[] vals = document.getNewName().split("\\.");
        String newName = UUID.randomUUID() + "_" + System.currentTimeMillis() + "." + vals[vals.length - 1];
        //七牛端重新抓取图片并命名
        try {
            FetchRet fetchRet = qiniuResourceManagerUtil
                    .getResource(qiniuDownloadUtil.getDownloadToken(urlFix + dto.getNewFileUrl(), 7200), newName);
            if (dto.getDeleteYuan()) { //删除原图会返回新数据
                //删除七牛端原图
                qiniuResourceManagerUtil.deleteFile(document.getNewName());
                document.setFileSize(new BigDecimal(fetchRet.fsize / 1000.00).setScale(2, BigDecimal.ROUND_HALF_UP).floatValue());
                document.setFileUrl(fetchRet.key);
                document.setNewName(newName);
                //判断旋转角度，设置w h
                if (dto.getRotate() / 90 % 2 != 0) {
                    Integer w = document.getW();
                    document.setW(document.getH());
                    document.setH(w);
                }
                super.update(document);
                return JsonUtil.getSuccess(MessageUtils.message(CommonContact.OPTION_SUCCESS), CommonContact.OPTION_SUCCESS, getDocumentImageSimple(document, urlFix, false));
            } else {
                Document newDocument = document.clone();
                newDocument.setFileSize(new BigDecimal(fetchRet.fsize / 1000.00).setScale(2, BigDecimal.ROUND_HALF_UP).floatValue());
                newDocument.setFileUrl(fetchRet.key);
                newDocument.setNewName(newName);
                newDocument.setName(newName);
                newDocument.setDownloadNo(0);
                if (dto.getRotate() / 90 % 2 != 0) {
                    Integer w = newDocument.getW();
                    newDocument.setW(newDocument.getH());
                    newDocument.setH(w);
                }
                super.save(newDocument);
                return JsonUtil.getSuccess(MessageUtils.message(CommonContact.OPTION_SUCCESS), CommonContact.OPTION_SUCCESS, getDocumentImageSimple(newDocument, urlFix, true));
            }
        } catch (QiniuException e) {
            e.printStackTrace();
        }
        return JsonUtil.getFailure("图片旋转操作失败，请重试！", CommonContact.OPTION_ERROR);
    }

    private Map<String, Object> getDocumentImageSimple(Document document, String urlFix, Boolean ifNew) {
        Map<String, Object> jsonMap = document.toMap();
        Auth auth = qiniuUploadUtil.getAuth();
        jsonMap.put("ifImg", true);
        if (ifNew) {
            jsonMap.put("comments", null);
            jsonMap.put("ifEdit", true);
            jsonMap.put("ifDelete", true);
        }
        jsonMap.put("imgUrl", qiniuDownloadUtil.getDownloadToken(auth,
                QiniuDocumentUrlUtil.getImgUrl(urlFix, jsonMap.get("fileUrl").toString(), "imageView2/1/w/200/h/240"), null));
        jsonMap.put("imgUrlTwo", qiniuDownloadUtil.getDownloadToken(auth, QiniuDocumentUrlUtil.getImgUrl(urlFix, jsonMap.get("fileUrl").toString(),
                "imageView2/2/w/800/interlace/1"), null));
        jsonMap.put("imgUrlYuan", qiniuDownloadUtil.getDownloadToken(auth,
                QiniuDocumentUrlUtil.getImgUrl(urlFix, jsonMap.get("fileUrl").toString(),
                        "imageView2/2/w/" + jsonMap.get("w") + "/h/" + jsonMap.get("h") + "/interlace/1"), null));
        return jsonMap;
    }

    /**
     * 图片裁剪
     *
     * @param dto 裁剪数据
     * @return 操作结果
     */
    public JSONResult qiniuCut(QiniuImgEditDTO dto) {
        Document document = super.findOne(dto.getId());
        String urlFix = configService.getConfigString(CommonContact.QINIU_BUCKET_URL) + "/";
        String[] vals = document.getNewName().split("\\.");
        String newName = UUID.randomUUID() + "_" + System.currentTimeMillis() + "." + vals[vals.length - 1];
        try {
            FetchRet fetchRet = qiniuResourceManagerUtil
                    .getResource(qiniuDownloadUtil.getDownloadToken(urlFix + dto.getNewFileUrl(), 7200), newName);
            if (dto.getDeleteYuan()) { //删除原图会返回新数据
                //删除七牛端原图
                qiniuResourceManagerUtil.deleteFile(document.getNewName());
                document.setFileSize(new BigDecimal(fetchRet.fsize / 1000.00).setScale(2, BigDecimal.ROUND_HALF_UP).floatValue());
                document.setFileUrl(fetchRet.key);
                document.setNewName(newName);
                document.setW(dto.getWidth());
                document.setH(dto.getHeight());
                super.update(document);
                return JsonUtil.getSuccess(MessageUtils.message(CommonContact.OPTION_SUCCESS), CommonContact.OPTION_SUCCESS, getDocumentImageSimple(document, urlFix, false));
            } else {
                Document newDocument = document.clone();
                newDocument.setFileSize(new BigDecimal(fetchRet.fsize / 1000.00).setScale(2, BigDecimal.ROUND_HALF_UP).floatValue());
                newDocument.setFileUrl(fetchRet.key);
                newDocument.setNewName(newName);
                newDocument.setName(newName);
                newDocument.setDownloadNo(0);
                newDocument.setW(dto.getWidth());
                newDocument.setH(dto.getHeight());
                super.save(newDocument);
                return JsonUtil.getSuccess(MessageUtils.message(CommonContact.OPTION_SUCCESS), CommonContact.OPTION_SUCCESS, getDocumentImageSimple(newDocument, urlFix, true));
            }
        } catch (QiniuException e) {
            e.printStackTrace();
        }
        return JsonUtil.getFailure("图片裁剪操作失败，请重试！", CommonContact.OPTION_ERROR);
    }

}
