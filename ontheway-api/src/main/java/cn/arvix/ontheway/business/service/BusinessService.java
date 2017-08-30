package cn.arvix.ontheway.business.service;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.entity.SystemModule;
import cn.arvix.base.common.entity.search.PageRequest;
import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.CommonErrorCode;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.ontheway.business.dto.ARSearchDTO;
import cn.arvix.ontheway.business.dto.CreateAndClaimDTO;
import cn.arvix.ontheway.business.dto.SolrSearchDTO;
import cn.arvix.ontheway.business.entity.Business;
import cn.arvix.ontheway.business.entity.BusinessExpand;
import cn.arvix.ontheway.business.entity.BusinessStatistics;
import cn.arvix.ontheway.ducuments.service.DocumentService;
import cn.arvix.ontheway.sys.user.entity.User;
import com.google.common.collect.Maps;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @author Created by yangyang on 2017/8/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class BusinessService extends BaseServiceImpl<Business, Long> {

    private DocumentService documentService;

    @Autowired
    public void setDocumentService(DocumentService documentService) {
        this.documentService = documentService;
    }

    private BusinessExpandService businessExpandService;

    @Autowired
    public void setBusinessExpandService(BusinessExpandService businessExpandService) {
        this.businessExpandService = businessExpandService;
    }

    private BusinessStatisticsService businessStatisticsService;

    @Autowired
    public void setBusinessStatisticsService(BusinessStatisticsService businessStatisticsService) {
        this.businessStatisticsService = businessStatisticsService;
    }

    private BusinessTypeService businessTypeService;

    @Autowired
    public void setBusinessTypeService(BusinessTypeService businessTypeService) {
        this.businessTypeService = businessTypeService;
    }

    private BusinessTypeContactService businessTypeContactService;

    @Autowired
    public void setBusinessTypeContactService(BusinessTypeContactService businessTypeContactService) {
        this.businessTypeContactService = businessTypeContactService;
    }

    private BusinessSolrService businessSolrService;

    @Autowired
    public void setBusinessSolrService(BusinessSolrService businessSolrService) {
        this.businessSolrService = businessSolrService;
    }

    /**
     * App客户端用户添加商家时调用
     * 添加商家并认领
     * 添加商家后会自动发起认领
     *
     * @return 操作结果 操作成功后，会返回商家的ID
     */
    @Transactional(rollbackFor = Exception.class)
    public JSONResult createAndClaim(CreateAndClaimDTO dto) {
        Assert.notNull(dto.getBusiness(), "商家信息不能为空");
        Assert.notNull(dto.getBusiness().getBusinessExpand(), "认领信息不能为空");
        Assert.notNull(dto.getCertificatePhoto(), "手持身份证照片不能为空");
        Assert.notNull(dto.getBusinessLicensePhoto(), "营业执照照片不能为空");
        Business business = dto.getBusiness();
        Assert.notEmpty(business.getTypeIds(), "商家类型不能为空");
        //商家必须拥有类型,添加类型与商家对应，添加时会检查类型是否存在
        for (Long typeId : business.getTypeIds()) {
            //类型只要有一个不存在，不允许执行下面的方法
            Assert.isTrue(businessTypeService.exists(typeId), "商家类型有误");
        }
        User user = webContextUtils.getCheckCurrentUser();
        BusinessExpand businessExpand = business.getBusinessExpand();
        //设置认领人
        businessExpand.setUser(user);
        //设置为提交状态
        businessExpand.setStatus(BusinessExpand.ClaimStatus.submit);
        businessExpand.setCertificatePhoto(dto.getCertificatePhoto().getFileUrl());
        businessExpand.setBusinessLicensePhoto(dto.getBusinessLicensePhoto().getFileUrl());
        businessExpandService.save(businessExpand);
        //保存document，设置 身份证正面照片 和 营业执照照片
        dto.getCertificatePhoto().setSystemModule(SystemModule.businessExpand);
        dto.getBusinessLicensePhoto().setSystemModule(SystemModule.businessExpand);
        dto.getCertificatePhoto().setParentId(businessExpand.getId());
        dto.getBusinessLicensePhoto().setParentId(businessExpand.getId());
        documentService.save_(dto.getCertificatePhoto());
        documentService.save_(dto.getBusinessLicensePhoto());
        //创建商家统计信息
        BusinessStatistics businessStatistics = BusinessStatistics.getInstance();
        businessStatisticsService.save(businessStatistics);
        business.setStatistics(businessStatistics);
        //设置颜色代码,颜色代码会保存在 typeIds 的一级类型中
        business.setColorCode(businessTypeService.getColorCodeByTypeIds(business.getTypeIds()));
        super.save(business);
        businessTypeContactService.createContact(business.getId(), business.getTypeIds());
        return JsonUtil.getSuccess(CommonContact.OPTION_SUCCESS, CommonContact.OPTION_SUCCESS, business.getId());
    }

    /**
     * 保存抓取的数据到数据库中
     *
     * @param business 商家信息
     * @return 保存结果
     */
    @Transactional
    public synchronized JSONResult createFetchData(Business business) {

        //抓取的数据需要判断一下重复   通过名称 和 地址 完全相同代表重复，直接过滤掉
        Map<String, Object> params = Maps.newHashMap();
        params.put("poiUid_eq", business.getPoiUid());

        List<Business> list = super.findAllWithNoPageNoSort(Searchable.newSearchable(params));

        if (list.size() > 0) {
            return JsonUtil.getFailure("poi数据重复", CommonContact.OPTION_ERROR);
        }

        Assert.notEmpty(business.getTypeIds(), "商家类型不能为空");
        //商家必须拥有类型,添加类型与商家对应，添加时会检查类型是否存在
        for (Long typeId : business.getTypeIds()) {
            //类型只要有一个不存在，不允许执行下面的方法
            Assert.isTrue(businessTypeService.exists(typeId), "商家类型有误");
        }
        //创建商家统计信息
        BusinessStatistics businessStatistics = BusinessStatistics.getInstance();
        businessStatisticsService.save(businessStatistics);
        business.setStatistics(businessStatistics);
        //设置颜色代码,颜色代码会保存在 typeIds 的一级类型中
        business.setColorCode(businessTypeService.getColorCodeByTypeIds(business.getTypeIds()));
        business.setIfShow(Boolean.TRUE);
        super.save(business);
        businessTypeContactService.createContact(business.getId(), business.getTypeIds());

        //加入solr全文检索中
        businessSolrService.add(business);
        return JsonUtil.getSuccess(CommonContact.OPTION_SUCCESS, CommonContact.OPTION_SUCCESS, business.getId());
    }

    /**
     * 获取检索数据列表，分页获取数据
     *
     * @param type        检索类型 ar list map
     * @param currentTime 初次检索时间
     * @param number      当前页
     * @param size        每页数量
     * @param latitude    当前定位的纬度
     * @param longitude   当前位置的经度
     * @param distance    距离
     * @param q           检索条件
     * @param typeIds     过滤条件
     * @return 查询结果
     */
    public JSONResult search(BusinessService.SearchType type, Integer number, Integer size,
                             Double latitude, Double longitude, Double distance, Long currentTime,
                             String q, Set<Long> typeIds) {
        if (SearchType.ar.equals(type)) {
            return this.searchAR(number, size, latitude, longitude, distance, currentTime, q, typeIds);
        }
        return null;
    }

    /**
     * 获取AR展示分页数据
     *
     * @return 查询结果
     */
    private JSONResult searchAR(Integer number, Integer size,
                                Double latitude, Double longitude, Double distance, Long currentTime,
                                String q, Set<Long> typeIds) {
        Assert.notNull(latitude, "latitude is not null");
        Assert.notNull(longitude, "longitude is not null");
        if (distance == null) distance = 1.0;
        if (size == null) size = 30;
        if (number == null) number = 0;
        if (currentTime == null) currentTime = System.currentTimeMillis();
        Page<ARSearchDTO> page = businessSolrService.searchAR(SolrSearchDTO
                .getInstance(q, number, size, latitude, longitude, distance, currentTime, typeIds));
        if(page == null){
            return JsonUtil.getFailure("solr search failed", CommonErrorCode.AR_SEARCH_SOLR_ERROR);
        }
        return JsonUtil.getSuccess(CommonContact.OPTION_SUCCESS,CommonContact.OPTION_SUCCESS,page);
    }


    /**
     * 导入全部数据到solr 全文检索中
     *
     * @return 导入结果
     */
    public JSONResult importDataToSolr() {
        importDataToSolr(0, 30);
        return JsonUtil.getSuccess(CommonContact.OPTION_SUCCESS, CommonContact.OPTION_SUCCESS);
    }

    private void importDataToSolr(int size, int number) {
        Map<String, Object> params = Maps.newHashMap();
        params.put("ifShow_eq", true);
        Searchable searchable = Searchable.newSearchable(params, new PageRequest(size, number));
        List<Business> businessList = super.findAllWithNoCount(searchable).getContent();
        for (Business business : businessList) {
            businessSolrService.add(business);
        }
        //数据加入solr中
        if (businessList.size() < number) { //结束查询
            return;
        }
        importDataToSolr(++size, number);
    }

    //检索的几种类型
    public enum SearchType {
        ar, list, map
    }
}
