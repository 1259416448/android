package cn.arvix.ontheway.attachment.service;

import cn.arvix.ontheway.attachment.entity.AgileAttachment;
import cn.arvix.ontheway.attachment.repository.AgileAttachmentRepository;
import cn.arvix.ontheway.ducuments.entity.Document;
import cn.arvix.ontheway.ducuments.service.DocumentService;
import cn.arvix.ontheway.sys.config.service.ConfigService;
import cn.arvix.ontheway.sys.utils.RegExpValidatorUtils;
import cn.arvix.base.common.entity.SystemModule;
import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.qiniu.utils.QiniuDocumentUrlUtil;
import cn.arvix.qiniu.utils.QiniuDownloadUtil;
import cn.arvix.qiniu.utils.QiniuUploadUtil;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.qiniu.util.Auth;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * @author Created by yangyang on 2017/4/6.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class AgileAttachmentService extends BaseServiceImpl<AgileAttachment, Long> {

    private DocumentService documentService;

    @Autowired
    public void setDocumentService(DocumentService documentService) {
        this.documentService = documentService;
    }

    private final ConfigService configService;

    private final QiniuDownloadUtil qiniuDownloadUtil;

    private final QiniuUploadUtil qiniuUploadUtil;

    @Autowired
    public AgileAttachmentService(ConfigService configService,
                                  QiniuDownloadUtil qiniuDownloadUtil,
                                  QiniuUploadUtil qiniuUploadUtil) {
        this.configService = configService;
        this.qiniuDownloadUtil = qiniuDownloadUtil;
        this.qiniuUploadUtil = qiniuUploadUtil;
    }

    private AgileAttachmentRepository getAgileAttachmentRepository() {
        return (AgileAttachmentRepository) baseRepository;
    }

    /**
     * 添加多个附件
     *
     * @param instanceId  实例ID
     * @param agileModule 附件类型
     * @param fileIds     文件IDs
     */
    @Transactional(rollbackFor = Exception.class)
    public void save(Long instanceId, SystemModule agileModule, Long[] fileIds) {
        if (fileIds != null && fileIds.length > 0) {
            for (Long fileId : fileIds) {
                save(instanceId, agileModule, fileId);
            }
        }
    }

    /**
     * 添加单个附件
     *
     * @param instanceId  实例ID
     * @param agileModule 附件类型
     * @param fileId      文件ID
     */
    @Transactional(rollbackFor = Exception.class)
    public void save(Long instanceId, SystemModule agileModule, Long fileId) {
        AgileAttachment agileAttachment = new AgileAttachment();
        agileAttachment.setAgileModule(agileModule);
        agileAttachment.setInstanceId(instanceId);
        //这里会检查文件是否存在
        Document document = documentService.findOne(fileId);
        agileAttachment.setDocument(document);
        super.save(agileAttachment);
    }

    /**
     * 获取附件内容
     *
     * @param agileModule 附件类型
     * @param instanceId  实例ID
     */
    public List<Map<String, Object>> getAttachments(SystemModule agileModule, Long instanceId) {
        Map<String, Object> params = Maps.newHashMap();
        params.put("agileModule_eq", agileModule);
        params.put("instanceId_eq", instanceId);
        List<AgileAttachment> agileAttachments = super.findAllWithSort(Searchable.newSearchable(params));
        String urlFix = configService.getConfigString(CommonContact.QINIU_BUCKET_URL);
        Auth auth = qiniuUploadUtil.getAuth();
        //根据文件类型返回附件数据，图片直接返回地址，文件后缀如果是 jpg|gif|bmp|png|jpeg
        if (agileAttachments != null && agileAttachments.size() > 0) {
            List<Map<String, Object>> jsonList = Lists.newArrayList();
            agileAttachments.forEach(x -> {
                Map<String, Object> jsonMap = Maps.newHashMap();
                jsonMap.put("attachmentId", x.getId()); //附件ID
                jsonMap.put("documentId", x.getDocument().getId()); //文件ID
                jsonMap.put("documentName", x.getDocument().getName());//文件名称
                jsonMap.put("documentType", x.getDocument().getFileType());
                jsonMap.put("documentSize", x.getDocument().getFileSize());
                //如果是图片 直接返回图片下载地址
                if (RegExpValidatorUtils.match(CommonContact.DOCUMENT_IMG_PATTERN,
                        x.getDocument().getFileUrl())) {
                    jsonMap.put("imgUrlOne",
                            qiniuDownloadUtil.getDownloadToken(auth, QiniuDocumentUrlUtil.getImgUrl(urlFix,
                                    x.getDocument().getFileUrl(), "imageView2/0/w/250"), null));
                    jsonMap.put("imgUrlTwo",
                            qiniuDownloadUtil.getDownloadToken(auth, QiniuDocumentUrlUtil.getImgUrl(urlFix,
                                    x.getDocument().getFileUrl(), "imageView2/0/w/520"), null));
                    jsonMap.put("imgUrlThree",
                            qiniuDownloadUtil.getDownloadToken(auth, QiniuDocumentUrlUtil.getImgUrl(urlFix,
                                    x.getDocument().getFileUrl(), null), null));
                } else {
                    jsonMap.put("documentUrl", qiniuDownloadUtil.getDownloadToken(auth, urlFix + x.getDocument().getFileUrl(), null));
                }
                jsonList.add(jsonMap);
            });
            return jsonList;
        }
        return null;
    }

    /**
     * 检查某个文档是否使用过
     * v
     *
     * @param documentId 文档ID
     * @return 使用情况
     */
    public boolean checkDocument(Long documentId) {
        Map<String, Object> params = Maps.newHashMap();
        params.put("document.id_eq", documentId);
        return super.count(Searchable.newSearchable(params)) > 0;
    }

    /**
     * 删除所有附件信息
     *
     * @param agileModule 模块
     * @param instanceId  实例ID
     */
    public void deleteByModuleAndInstanceId(SystemModule agileModule, Long instanceId) {
        getAgileAttachmentRepository().deleteByAgileModuleAndInstanceId(agileModule, instanceId);
    }


}
