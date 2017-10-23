package cn.arvix.ontheway.business.service;

import cn.arvix.base.common.entity.PageResult;
import cn.arvix.base.common.entity.SystemModule;
import cn.arvix.base.common.utils.Checks;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.TimeMaker;
import cn.arvix.ontheway.business.dto.ARSearchDTO;
import cn.arvix.ontheway.business.dto.SolrSearchDTO;
import cn.arvix.ontheway.business.entity.Business;
import cn.arvix.ontheway.ducuments.service.DocumentService;
import cn.arvix.ontheway.sys.config.service.ConfigService;
import cn.arvix.solr.SolrServiceImpl;
import com.google.common.collect.Lists;
import org.apache.solr.client.solrj.SolrClient;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrDocument;
import org.apache.solr.common.SolrDocumentList;
import org.apache.solr.common.SolrInputDocument;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.Iterator;
import java.util.List;

/**
 * @author Created by yangyang on 2017/8/28.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class BusinessSolrService extends SolrServiceImpl {

    @Autowired
    public BusinessSolrService(@Qualifier("defaultSolrClient") SolrClient solrClient) {
        super(solrClient);
    }

    private BusinessTypeService businessTypeService;

    @Autowired
    public void setBusinessTypeService(BusinessTypeService businessTypeService) {
        this.businessTypeService = businessTypeService;
    }

    private DocumentService documentService;

    @Autowired
    public void setDocumentService(DocumentService documentService) {
        this.documentService = documentService;
    }

    private ConfigService configService;

    @Autowired
    public void setConfigService(ConfigService configService) {
        this.configService = configService;
    }

    /**
     * 获取一个需要保存的全文检索对象
     *
     * @param m 商家数据
     * @return solr document data
     */
    public SolrInputDocument getSolrInputDocument(Business m) {
        SolrInputDocument document = new SolrInputDocument();
        document.addField("id", m.getId());
        document.addField("name", m.getName());
        document.addField("address", m.getAddress());
        document.addField("longitude", m.getLongitude());
        document.addField("latitude", m.getLatitude());
        document.addField("poi_location_p", m.getLatitude() + "," + m.getLongitude());
        document.addField("contact_info", m.getContactInfo());
        //获取一张首页图片信息
        document.addField("photo_url", documentService.findThemePhotoByParentId(m.getId(), SystemModule.business));
        document.addField("type_ids", m.getTypeIds());
        document.addField("type_names", businessTypeService.findTypeByTypeIds(m.getTypeIds()));
        document.addField("color_code", m.getColorCode());
        document.addField("weight", m.getWeight());
        document.addField("if_show", m.getIfShow());
        document.addField("date_created", TimeMaker.toTimeMillis(m.getDateCreated()));
        document.addField("last_updated", TimeMaker.toTimeMillis(m.getLastUpdated()));
        return document;
    }


    /**
     * 分页获取商家数据
     * 重solr全文检索数据库中获取
     *
     * @return 全文检索Page 出现异常会返回null
     */
    public Page<ARSearchDTO> searchAR(SolrSearchDTO solrSearchDTO) {
        try {
            QueryResponse rsp = getSolrClient().query(solrSearchDTO.getQuery());
            SolrDocumentList docs = rsp.getResults();
            Iterator<SolrDocument> iterator = docs.iterator();
            List<ARSearchDTO> content = Lists.newArrayList();
            String urlFix = configService.getConfigString(CommonContact.QINIU_BUCKET_URL);
            while (iterator.hasNext()) {
                SolrDocument doc = iterator.next();
                ARSearchDTO dto = ARSearchDTO.getInstance();
                dto.setBusinessId(Checks.toLong(Checks.stringValueOf(doc.getFieldValue("id"))));
                dto.setName(Checks.stringValueOf(doc.getFieldValue("name")));
                dto.setAddress(Checks.stringValueOf(doc.getFieldValue("address")));
                dto.setLatitude(Checks.toDouble(Checks.stringValueOf(doc.getFieldValue("latitude"))));
                dto.setLongitude(Checks.toDouble(Checks.stringValueOf(doc.getFieldValue("longitude"))));
                dto.setContactInfo(Checks.stringValueOf(doc.getFieldValue("contact_info")));
                if (doc.getFieldValue("photo_url") != null) {
                    dto.setPhotoUrl(urlFix + doc.getFieldValue("photo_url").toString());
                }
                dto.setColorCode(Checks.stringValueOf(doc.getFieldValue("color_code")));
                dto.setDistance(Checks.toDouble(Checks.stringValueOf(doc.getFieldValue("_dist_"))));
                content.add(dto);
            }
            Page<ARSearchDTO> page = new PageResult<>(content, new PageRequest(solrSearchDTO.getNumber(), solrSearchDTO.getSize()), docs.getNumFound());
            ((PageResult) page).setCurrentTime(solrSearchDTO.getCurrentTime());
            return page;
        } catch (SolrServerException | IOException e) {
            e.printStackTrace();
        }
        return null;
    }


    /**
     * 添加一个business信息到solr全文检索中，并返回添加结果
     *
     * @param m business 对象
     * @return 添加结果
     */
    public boolean add(Business m) {
        return solrOption(SolrOptionType.add, m);
    }

    @SuppressWarnings("unchecked")
    private boolean solrOption(SolrOptionType optionType, Object obj) {
        if (obj != null) {
            try {
                if (SolrOptionType.delete.equals(optionType)) {
                    if (obj instanceof List) {
                        super.delete((List<String>) obj);
                    } else {
                        super.delete(obj.toString());
                    }
                } else {
                    super.add(getSolrInputDocument((Business) obj));//添加和更新使用相同方法，solr会自动根据id判断文档，如果文档不存在则添加，反之则更新
                }
            } catch (IOException | SolrServerException e) {
                e.printStackTrace();
                return false;
            }
            return true;
        }
        return false;
    }

    private enum SolrOptionType {
        add, delete
    }

}
