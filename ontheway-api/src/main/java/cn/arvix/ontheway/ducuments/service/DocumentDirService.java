package cn.arvix.ontheway.ducuments.service;

import cn.arvix.ontheway.ducuments.entity.DocumentDir;
import cn.arvix.ontheway.ducuments.entity.DocumentDirType;
import cn.arvix.ontheway.ducuments.repository.DocumentDirRepository;
import cn.arvix.ontheway.ducuments.repository.DocumentRepository;
import cn.arvix.ontheway.sys.auth.service.AuthService;
import cn.arvix.ontheway.sys.user.entity.User;
import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.base.common.utils.Checks;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.base.common.utils.MessageUtils;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

/**
 * @author Created by yangyang on 2017/3/31.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class DocumentDirService extends BaseServiceImpl<DocumentDir, Long> {

    private final DocumentRepository documentRepository;

    @Autowired
    public DocumentDirService(DocumentRepository documentRepository) {
        this.documentRepository = documentRepository;
    }

    public DocumentDirRepository getDocumentDirRepository() {
        return (DocumentDirRepository) baseRepository;
    }

    private AuthService authService;

    @Autowired
    public void setAuthService(AuthService authService) {
        this.authService = authService;
    }

    /**
     * saas初始化生成 公共文件夹和附件文件夹
     */
    @Transactional(rollbackFor = Exception.class)
    public void saasInit() {

        DocumentDir commonDocumentDir = new DocumentDir();
        commonDocumentDir.setDocumentDirType(DocumentDirType.common);
        commonDocumentDir.setName("公共文件夹");
        commonDocumentDir.setShow(true);
        commonDocumentDir.setSize(0.0f);
        commonDocumentDir.setFileNo(0);
        commonDocumentDir.setIfDelete(Boolean.FALSE);

        DocumentDir attachmentDocumentDir = new DocumentDir();
        attachmentDocumentDir.setDocumentDirType(DocumentDirType.attachment);
        attachmentDocumentDir.setName("附件文件夹");
        attachmentDocumentDir.setShow(true);
        attachmentDocumentDir.setSize(0.0f);
        attachmentDocumentDir.setFileNo(0);
        attachmentDocumentDir.setIfDelete(Boolean.FALSE);
        //附件文件夹不允许创建下级
        attachmentDocumentDir.setIfCreate(Boolean.FALSE);
        super.save(commonDocumentDir);
        super.save(attachmentDocumentDir);

    }

    /**
     * 创建用户文件夹
     *
     * @param m 实体
     * @return 创建结果
     */
    public JSONResult save_(DocumentDir m) {
        if (m.getParentId() != null) {
            //判断是否存在
            DocumentDir parent = super.findOne(m.getParentId());
            m.setParentIds(parent.makeSelfAsNewParentIds());
            m.setDocumentDirType(parent.getDocumentDirType());
            //判断当前文件夹是否允许创建下级
            if (!parent.getIfCreate())
                return JsonUtil.getFailure(MessageUtils.message("documentDir.create.error"), "documentDir.create.error");
        } else {
            m.setDocumentDirType(DocumentDirType.user);
        }
        m.setId(null);
        //允许添加下级
        m.setIfCreate(Boolean.TRUE);
        m.setShow(true);
        m.setSize(0.0f);
        m.setFileNo(0);
        //用户创建
        m.setIfDelete(Boolean.TRUE);
        return super.save_(m);
    }

    /**
     * 获取一个儿子ID的所有父亲信息  返回父亲信息 {"name":"","id":""}
     *
     * @param childId 查询对象
     * @return 查询结果
     */
    public JSONResult getParentInfoByChildId(Long childId) {
        DocumentDir documentDir = super.findOne(childId);
        List<Map<String, Object>> jsonList = Lists.newArrayList();
        if (!StringUtils.isEmpty(documentDir.getParentIds())) {
            List<Long> longList = Lists.newArrayList();
            String[] str = documentDir.getParentIds().split(documentDir.getSeparator());
            for (String aStr : str) {
                Long id = Checks.toLong(aStr);
                if (id != null) {
                    longList.add(id);
                }
            }
            List<Object[]> list = getDocumentDirRepository().findInId(longList);
            if (list != null) {
                list.forEach(x -> {
                    Map<String, Object> jsonMap = Maps.newHashMap();
                    jsonMap.put("name", x[0]);
                    jsonMap.put("id", x[1]);
                    jsonList.add(jsonMap);
                });
            }
        }
        Map<String, Object> jsonMap = Maps.newHashMap();
        jsonMap.put("name", documentDir.getName());
        jsonMap.put("id", documentDir.getId());
        User user = webContextUtils.getCheckCurrentUser();
        //增加文件夹操作权限，判断是否可以上传
        Boolean ifAdmin = SecurityUtils.getSubject().isPermitted("Document:admin");
        Integer authOpType = -1;
        if (!ifAdmin) { //没有管理员权限,获取当前用户对当前文件夹的操作权限
            authOpType = authService.getOpTypeByOpId(documentDir.getId(), 1, user);
        }
        jsonList.add(jsonMap);
        if (ifAdmin || authOpType == 2
                || !DocumentDirType.user.equals(documentDir.getDocumentDirType())) {
            jsonMap.put("ifUpload", true);
        }
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.OPTION_SUCCESS),
                CommonContact.OPTION_SUCCESS, jsonList);
    }

    /**
     * 用户更新文件夹，这里只能更新名称
     *
     * @return 更新结果
     */
    public JSONResult update_(DocumentDir m) {
        DocumentDir dbM = super.findOne(m.getId());
        dbM.setName(m.getName());
        return super.update_(dbM);
    }

    /**
     * 文件夹移动
     *
     * @return 移动结果
     */
    public JSONResult move(Long id, Long moveId) {
        if (Objects.equals(id, moveId))
            return JsonUtil.getFailure(MessageUtils.message("documentDir.move.error"), "documentDir.move.error");
        DocumentDir documentDir = super.findOne(id);
        //不能移动公共文件夹和附件文件夹
        if (documentDir.getParentId() == null
                && (documentDir.getDocumentDirType().equals(DocumentDirType.common)
                || documentDir.getDocumentDirType().equals(DocumentDirType.attachment))
                ) {
            return JsonUtil.getFailure(MessageUtils.message("documentDir.move.error_1"), "documentDir.move.error_1");
        }
        //这里表示直接移动到根目录下，移动到根目录下的文件夹类型默认为 user
        if (moveId == -1) {
            documentDir.setDocumentDirType(DocumentDirType.user);
            documentDir.setParentId(null);
            documentDir.setParentIds(null);
        } else {
            DocumentDir parent = super.findOne(moveId);
            //判断是否可以移动 不能移动到当前文件夹的子节点下
            if (!StringUtils.isEmpty(parent.getParentIds())
                    && parent.getParentIds().contains(parent.getSeparator() + id + parent.getSeparator())) {
                return JsonUtil.getFailure(MessageUtils.message("documentDir.move.error"), "documentDir.move.error");
            }
            if (!parent.getIfCreate())
                return JsonUtil.getFailure(MessageUtils.message("documentDir.move.error_0"), "documentDir.move.error_0");
            documentDir.setParentIds(parent.makeSelfAsNewParentIds());
            documentDir.setDocumentDirType(parent.getDocumentDirType());
            documentDir.setParentId(parent.getId());
        }
        super.update(documentDir);
        return JsonUtil.getSuccess(MessageUtils.message("documentDir.move.success"), "documentDir.move.success");
    }

    /**
     * 删除一个文件夹
     * 不能删除 IfDelete = false 的文件夹
     * 不能删除有子文件的文件夹
     * 不能删除有文件的文件夹
     *
     * @param id 主键
     * @return 删除结果
     */
    public JSONResult delete_(Long id) {
        DocumentDir documentDir = super.findOne(id);
        if (!documentDir.getIfDelete())
            return JsonUtil.getSuccess(MessageUtils.message("documentDir.delete.error"), "documentDir.delete.error");
        if (documentDir.isHasChildren())
            return JsonUtil.getSuccess(MessageUtils.message("documentDir.delete.error_1"), "documentDir.delete.error_1");
        if (documentRepository.countByParentId(id) > 0)
            return JsonUtil.getSuccess(MessageUtils.message("documentDir.delete.error_0"), "documentDir.delete.error_0");
        return super.delete_(id);
    }

    /**
     * 获取当前用户能查看的所有文件夹
     * 这里需要分权获取,分权信息查询语句在 DocumentDirSearchCallback 中
     *
     * @param user 用户
     * @param pId  当前父节点
     * @return 当前能查看的文件夹
     */
    public List<Map<String, Object>> findAllByUser(User user, Long pId, Sort sort) {
        Map<String, Object> params = Maps.newHashMap();
        //增加文件夹分权获取 , 文件夹管理员能直接获取所有文件夹
        if (!SecurityUtils.getSubject().isPermitted("Document:admin")) {
            params.put("auth", user);
            params.put("opModule", 1);
        }
        if (pId != null) { //父节点
            params.put("parentId_eq", pId);
        } else {
            params.put("parentId_isNull", null);
        }
        Searchable searchable = Searchable.newSearchable(params, null, sort);
        //抓取获取到的文件夹的所有操作权限
        List<DocumentDir> list = super.findAllWithSort(searchable);
        if (params.get("auth") == null) {
            return JsonUtil.getBaseEntityMapList(list);
        } else {
            if (list == null || list.size() == 0) return null;
            Set<Long> longSet = Sets.newHashSet();
            list.forEach(x -> longSet.add(x.getId()));
            Map<Long, Integer> authOpTypeMap = authService.getOpTypeByOpIds(longSet, 1, user);
            List<Map<String, Object>> resList = JsonUtil.getBaseEntityMapList(list);
            //resList
            resList.forEach(x -> {
                // opType 1 只读 2 读写
                x.put("authOpType", authOpTypeMap.get(Checks.toLong(String.valueOf(x.get("id")))));
            });
            return resList;
        }
    }

    /**
     * 获取某个用户的附件文件夹
     *
     * @param user 用户信息
     */
    public DocumentDir getCompanyAttachment(User user) {
        return getDocumentDirRepository().findByDocumentDirTypeAndCompanyId(DocumentDirType.attachment);
    }

}
