package cn.arvix.ontheway.business.service;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.entity.PageResult;
import cn.arvix.base.common.entity.SystemModule;
import cn.arvix.base.common.entity.search.PageRequest;
import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.CommonErrorCode;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.base.common.utils.TimeMaker;
import cn.arvix.ontheway.business.dto.*;
import cn.arvix.ontheway.business.entity.Business;
import cn.arvix.ontheway.business.entity.BusinessExpand;
import cn.arvix.ontheway.business.entity.BusinessStatistics;
import cn.arvix.ontheway.business.entity.CollectionRecords;
import cn.arvix.ontheway.business.repository.BusinessRepository;
import cn.arvix.ontheway.ducuments.entity.Document;
import cn.arvix.ontheway.ducuments.service.DocumentService;
import cn.arvix.ontheway.footprint.service.FootprintService;
import cn.arvix.ontheway.sys.config.service.ConfigService;
import cn.arvix.ontheway.sys.user.entity.User;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import java.util.Date;
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

    private ConfigService configService;

    @Autowired
    public void setConfigService(ConfigService configService) {
        this.configService = configService;
    }

    private CollectionRecordsService collectionRecordsService;

    @Autowired
    public void setCollectionRecordsService(CollectionRecordsService collectionRecordsService) {
        this.collectionRecordsService = collectionRecordsService;
    }

    private FootprintService footprintService;

    @Autowired
    public void setFootprintService(FootprintService footprintService) {
        this.footprintService = footprintService;
    }

    private BusinessAutoFetchService businessAutoFetchService;

    @Autowired
    public void setBusinessAutoFetchService(BusinessAutoFetchService businessAutoFetchService) {
        this.businessAutoFetchService = businessAutoFetchService;
    }

    private BusinessCheckInService businessCheckInService;

    @Autowired
    public void setBusinessCheckInService(BusinessCheckInService businessCheckInService) {
        this.businessCheckInService = businessCheckInService;
    }

    private BusinessRepository getBusinessRepository() {
        return (BusinessRepository) baseRepository;
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
        businessStatistics.setBusinessId(business.getId());
        businessTypeContactService.createContact(business.getId(), business.getTypeIds());
        return JsonUtil.getSuccess(CommonContact.OPTION_SUCCESS, CommonContact.OPTION_SUCCESS, business.getId());
    }

    /**
     * 认领商家接口，需要填写正确的认领信息
     *
     * @param dto 认领信息
     * @return 认领结果
     */
    public JSONResult claim(CreateAndClaimDTO dto) {

        Assert.notNull(dto.getBusiness(), "商家信息不能为空");
        Assert.notNull(dto.getBusiness().getBusinessExpand(), "认领信息不能为空");
        Assert.notNull(dto.getCertificatePhoto(), "手持身份证照片不能为空");
        Assert.notNull(dto.getBusinessLicensePhoto(), "营业执照照片不能为空");
        Business business = super.findOne(dto.getBusiness().getId());

        //验证是否可以提交认领信息，一家商家只能同时一个人提交认领信息
        if (business.getBusinessExpand() != null) {
            return JsonUtil.getFailure("当前商家已被认领或已提交过认领资料", CommonErrorCode.BUSINESS_CLAIM_FAILED);
        }

        User user = webContextUtils.getCheckCurrentUser();
        BusinessExpand businessExpand = dto.getBusiness().getBusinessExpand();
        //设置认领人
        businessExpand.setUser(user);
        //设置为提交状态
        businessExpand.setStatus(BusinessExpand.ClaimStatus.submit);
        businessExpand.setCertificatePhoto(dto.getCertificatePhoto().getFileUrl());
        businessExpand.setBusinessLicensePhoto(dto.getBusinessLicensePhoto().getFileUrl());
        businessExpandService.save(businessExpand);
        business.setBusinessExpand(businessExpand); //设置认领信息

        //保存document，设置 身份证正面照片 和 营业执照照片
        dto.getCertificatePhoto().setSystemModule(SystemModule.businessExpand);
        dto.getBusinessLicensePhoto().setSystemModule(SystemModule.businessExpand);
        dto.getCertificatePhoto().setParentId(businessExpand.getId());
        dto.getBusinessLicensePhoto().setParentId(businessExpand.getId());
        documentService.save_(dto.getCertificatePhoto());
        documentService.save_(dto.getBusinessLicensePhoto());

        super.update(business);

        return JsonUtil.getSuccess("认领申请提交成功", CommonContact.OPTION_SUCCESS, business.getId());

    }

    /**
     * 审核认领商家
     *
     * @param businessId 商家ID
     * @return 操作结果
     */
    public JSONResult approveClaim(Long businessId, BusinessExpand.ClaimStatus claimStatus) {
        Business business = super.findOne(businessId);
        if (business.getBusinessExpand() != null && claimStatus != null) {
            business.getBusinessExpand().setStatus(claimStatus);
            businessExpandService.update(business.getBusinessExpand());
            //更新solr
            businessSolrService.add(business);
        }
        return JsonUtil.getSuccess(CommonContact.OPTION_SUCCESS, CommonContact.OPTION_SUCCESS, businessId);
    }

    /**
     * 获取当前用户正在审核的认领申请数量
     *
     * @return 认领数量;
     */
    public JSONResult checkUserSubmitClaim() {
        User user = webContextUtils.getCheckCurrentUser();
        return JsonUtil.getSuccess(CommonContact.FETCH_SUCCESS,
                CommonContact.FETCH_SUCCESS,
                businessExpandService.countByUserIdAndStatus(user.getId(),
                        BusinessExpand.ClaimStatus.submit));
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
        businessStatistics.setBusinessId(business.getId());
        businessTypeContactService.createContact(business.getId(), business.getTypeIds());

        //加入solr全文检索中
        businessSolrService.add(business);
        getBusinessRepository().flush();
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
        } else if (SearchType.list.equals(type)) {
            //这里直接调用AR数据获取，距离默认前端传入1000km即可
            return this.searchAR(number, size, latitude, longitude, distance, currentTime, q, typeIds);
        }
        return null;
    }

    /**
     * 获取商家详情信息 商家信息，商家图片信息，优惠信息，默认10条评论（足迹信息）
     * 用户已登录zhuangtai -> 用户收藏信息、签到信息、10条评论是否点赞信息
     *
     * @param id 商家ID
     * @return 商家详情
     */
    public JSONResult view(Long id) {

        Business business = super.findOneWithNoCheck(id);
        if (business == null || !business.getIfShow() || business.getIfDelete()) {
            return JsonUtil.getFailure("商家信息不存在或已被删除", CommonErrorCode.BUSINESS_IS_NOT_FUND, id);
        }

        BusinessDetailDTO detailDTO = BusinessDetailDTO.getInstance();
        //基本信息
        detailDTO.setBusinessId(business.getId());
        detailDTO.setName(business.getName());
        detailDTO.setAddress(business.getAddress());
        detailDTO.setLatitude(business.getLatitude());
        detailDTO.setLongitude(business.getLongitude());
        detailDTO.setContactInfo(business.getContactInfo());
        detailDTO.setColorCode(business.getColorCode());
        detailDTO.setWeight(business.getWeight());
        detailDTO.setTypeIds(business.getTypeIds());

        //统计信息
        detailDTO.setCollectionNum(business.getStatistics().getCollectionNum());
        detailDTO.setCommentNum(business.getStatistics().getCommentNum());
        detailDTO.setBusinessPhotoNum(business.getStatistics().getBusinessPhotoNum());
        detailDTO.setUserPhotoNum(business.getStatistics().getUserPhotoNum());

        //抓取商家图片 最多3张 超过的通过相册的形式获取数据
        String urlFix = configService.getConfigString(CommonContact.QINIU_BUCKET_URL);
        //这里，如果商家的图片信息已经等于 = 0
        if (business.getStatistics().getBusinessPhotoNum() > 0) {
            List<Document> documents = documentService.findByParentIdAndSize(business.getId(), SystemModule.business, 3);
            if (documents != null && documents.size() > 0) {
                List<String> photoUrls = Lists.newArrayListWithCapacity(documents.size());
                documents.forEach(x -> photoUrls.add(urlFix + x.getFileUrl()));
                detailDTO.setPhotoUrls(photoUrls);
            }
        }
        //默认需要获取3张照片，如果获取到的商家照片不满3张，剩余的获取用户照片
        if (detailDTO.getPhotoUrls() == null || detailDTO.getPhotoUrls().size() < 3) {
            int fetchNo = detailDTO.getPhotoUrls() == null ? 3 : (3 - detailDTO.getPhotoUrls().size());
            List<String> photoUrls = footprintService.findPhotoUrlByBusinessId(business.getId(), fetchNo);
            if (photoUrls != null && photoUrls.size() > 0) {
                if (detailDTO.getPhotoUrls() == null) detailDTO.setPhotoUrls(Lists.newArrayList());
                photoUrls.forEach(x -> detailDTO.getPhotoUrls().add(urlFix + x));
            }
        }

        //抓取商家优惠信息  优惠功能暂未添加


        //抓取商家优惠洗洗

        User user = webContextUtils.getCurrentUser();
        //获取收藏情况
        if (user != null) {
            detailDTO.setIfLike(collectionRecordsService.countByUserIdAndBusinessId(user.getId(), business.getId()) > 0);
            //获取签到情况
            detailDTO.setIfCheckIn(businessCheckInService.checkInStatus(user.getId(), business.getId()));
        } else {
            detailDTO.setIfLike(Boolean.FALSE);
            detailDTO.setIfCheckIn(Boolean.FALSE);
        }

        Long currentTime = System.currentTimeMillis();
        //获取商家足迹信息
        //noinspection unchecked
        detailDTO.setFootprints(footprintService.searchByBusinessId(0, 10,
                currentTime, business.getId()).getContent());
        detailDTO.setCurrentTime(currentTime);
        return JsonUtil.getSuccess(CommonContact.FETCH_SUCCESS, CommonContact.FETCH_SUCCESS, detailDTO);
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
                .getInstance(q, number, size, null, latitude, longitude, distance, currentTime, typeIds));
        if (page == null) {
            return JsonUtil.getFailure("solr search failed", CommonErrorCode.AR_SEARCH_SOLR_ERROR);
        }
        //判断当前检索是否获取到内容，如果请求 为 0 页而且未获取到内容，将执行自动抓取功能
        if (page.getContent().size() == 0 && number == 0) {
            businessAutoFetchService.addJob(latitude, longitude, typeIds);
        }
        return JsonUtil.getSuccess(CommonContact.OPTION_SUCCESS, CommonContact.OPTION_SUCCESS, page);
    }

    /**
     * 获取某个Business 下的 更多足迹数据 分页获取
     *
     * @param id          businessId
     * @param number      当前页
     * @param size        每页大小
     * @param currentTime 请求时间
     * @return 更多footprint数据
     */
    public JSONResult searchFootprint(Long id, Integer number, Integer size, Long currentTime) {

        //验证商家是否存在和商家状态
        Business business = super.findOneWithNoCheck(id);
        if (business == null || !business.getIfShow() || business.getIfDelete()) {
            return JsonUtil.getFailure("商家信息不存在或已被删除", CommonErrorCode.BUSINESS_IS_NOT_FUND, id);
        }
        Page page = footprintService.searchByBusinessId(number, size, currentTime, id);
        return JsonUtil.getSuccess(CommonContact.FETCH_SUCCESS, CommonContact.FETCH_SUCCESS, page);
    }

    /**
     * 添加、取消收藏
     *
     * @param id 商家ID
     * @return 操作结果
     */
    @Transactional(rollbackFor = Exception.class)
    public JSONResult like(Long id) {
        //验证商家是否存在和商家状态
        Business business = super.findOneWithNoCheck(id);
        if (business == null || !business.getIfShow() || business.getIfDelete()) {
            return JsonUtil.getFailure("商家信息不存在或已被删除", CommonErrorCode.BUSINESS_IS_NOT_FUND, id);
        }
        User user = webContextUtils.getCheckCurrentUser();
        //判断用户是否收藏
        if (collectionRecordsService.countByUserIdAndBusinessId(user.getId(), id) > 0) {
            //已收藏
            collectionRecordsService.deleteByUserIdAndBusinessId(user.getId(), id);
            businessStatisticsService.updateCollectionNum(id, -1);
        } else {
            //未收藏
            collectionRecordsService.createByUserIdAndBusinessId(user.getId(), id);
            businessStatisticsService.updateCollectionNum(id, 1);
        }
        return JsonUtil.getSuccess(CommonContact.OPTION_SUCCESS, CommonContact.OPTION_SUCCESS, id);
    }

    /**
     * 获取用户收藏列表，分页获取
     *
     * @param number 当前页
     * @param size   每页大小 默认15
     * @return 用户收藏数据列表
     */
    public JSONResult userLike(int number, int size) {
        if (number < 0) number = 0;
        if (size < 0 || size > 30) size = 15;
        User user = webContextUtils.getCheckCurrentUser();
        Map<String, Object> params = Maps.newHashMap();
        params.put("userId_eq", user.getId());
        Searchable searchable = Searchable.newSearchable(params, new PageRequest(number, size),
                new Sort(Sort.Direction.DESC, "dateCreated"));
        Page<CollectionRecords> page = collectionRecordsService.findAllWithNoCount(searchable);
        if (page.getContent().size() > 0) {
            Set<Long> businessIdSet = Sets.newHashSet();
            page.getContent().forEach(x -> businessIdSet.add(x.getBusinessId()));
            //获取通过商家ID数据
            List<Business> businessList = getBusinessRepository().findInId(businessIdSet);
            Map<Long, Business> businessMap = Maps.newHashMap();
            businessList.forEach(x -> businessMap.put(x.getId(), x));
            //构建dto
            List<UserCollectionSearchDTO> content = Lists.newArrayListWithCapacity(page.getContent().size());
            page.getContent().forEach(x -> {
                UserCollectionSearchDTO dto = UserCollectionSearchDTO.getInstance();
                Business business = businessMap.get(x.getBusinessId());
                dto.setBusinessId(business.getId());
                dto.setName(business.getName());
                dto.setAddress(business.getAddress());
                dto.setLatitude(business.getLatitude());
                dto.setLongitude(business.getLongitude());
                dto.setDateCreated(TimeMaker.toTimeMillis(x.getDateCreated()));
                dto.setDateCreatedStr(TimeMaker.toFormatStr(x.getDateCreated(), "yyyy.MM.dd"));
                dto.setCollectionId(x.getId());
                content.add(dto);
            });
            page = new PageResult<>(content, searchable.getPage(), 0);
        }
        return JsonUtil.getSuccess(CommonContact.FETCH_SUCCESS, CommonContact.FETCH_SUCCESS, page);
    }

    /**
     * 获取某个相加的用户相册
     *
     * @param businessId  商家ID
     * @param number      当前页
     * @param size        每页大小
     * @param currentTime 请求时间 防止获取重复数据
     * @return 商家相册分页数据
     */
    public JSONResult userPhotos(Long businessId, int number, int size, Long currentTime) {
        if (number < 0) number = 0;
        if (size < 0 || size > 50) size = 16;
        Map<String, Object> params = Maps.newHashMap();
        params.put("ifDelete", false);
        params.put("ifBusinessComment", true);
        params.put("businessId", businessId);
        params.put("systemModule_eq", SystemModule.footprint);
        if (currentTime == null) {
            currentTime = System.currentTimeMillis();
        }
        params.put("dateCreated_lte", new Date(currentTime));
        params.put(CommonContact.BUSINESS_USER_PHOTOS, Boolean.TRUE);
        Searchable searchable = Searchable.newSearchable(params, new PageRequest(number, size),
                new Sort(Sort.Direction.DESC, "dateCreated"));
        Page<Document> page = documentService.findAllWithNoCount(searchable);

        //获取用户信息
        if (page.getContent().size() > 0) {
            List<BusinessPhotoDTO> content = Lists.newArrayListWithCapacity(page.getContent().size());

            String urlFix = configService.getConfigString(CommonContact.QINIU_BUCKET_URL);

            page.getContent().forEach(x -> {
                BusinessPhotoDTO dto = BusinessPhotoDTO.getInstance();
                dto.setDateCreated(TimeMaker.toTimeMillis(x.getDateCreated()));
                dto.setDateCreatedStr(TimeMaker.toFormatStr(x.getDateCreated(), "yyyy.MM.dd"));
                dto.setPhotoId(x.getId());
                dto.setPhotoUrl(urlFix + x.getFileUrl());
                dto.setUserId(x.getUser().getId());
                dto.setUserNickname(x.getUser().getName());
                content.add(dto);
            });
            page = new PageResult<>(content, searchable.getPage(), 0);
            ((PageResult) page).setCurrentTime(currentTime);
        }
        return JsonUtil.getSuccess(CommonContact.FETCH_SUCCESS, CommonContact.FETCH_SUCCESS, page);
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

    /**
     * 搜索认证商家列表
     *
     * @param number      当前页
     * @param size        每页大小
     * @param latitude    经纬度
     * @param longitude   经纬度
     * @param currentTime 查询时间
     * @param q           查询key
     * @return 查询到的列表
     */
    public JSONResult searchClaim(Integer number, Integer size,
                                  Double latitude, Double longitude,
                                  Long currentTime, String q) {
        Assert.notNull(q, "q is not null");
        if (size == null) size = 30;
        if (number == null) number = 0;
        if (currentTime == null) currentTime = System.currentTimeMillis();

        Page<ARSearchDTO> page = businessSolrService.searchAR(SolrSearchDTO
                .getInstance(q, number, size, SolrSearchDTO.ClaimStatus.none, latitude, longitude, null, currentTime, null));
        if (page == null) {
            return JsonUtil.getFailure("solr search failed", CommonErrorCode.AR_SEARCH_SOLR_ERROR);
        }

        return JsonUtil.getSuccess(CommonContact.FETCH_SUCCESS, CommonContact.FETCH_SUCCESS, page);

    }

    /**
     * 获取用户的认领商家，只会获取到以审核通过的
     *
     * @param number      当前页
     * @param size        每页大小
     * @param currentTime 请求时间
     * @return 认领商家信息
     */
    public JSONResult userClaim(int number, int size, Long currentTime) {
        if (currentTime == null) currentTime = System.currentTimeMillis();
        if (number < 0) number = 0;
        if (size > 30) size = 15;
        Map<String, Object> params = Maps.newHashMap();
        User user = webContextUtils.getCheckCurrentUser();
        params.put("claim", Boolean.TRUE);
        params.put("userId", user.getId());
        params.put("dateCreated", new Date(currentTime));
        params.put("claimStatus", BusinessExpand.ClaimStatus.approved);
        Searchable searchable = Searchable.newSearchable(params, new PageRequest(number, size));
        Page page = super.findAll(searchable);

        //加载优惠信息

        //加载封面图片信息

        return JsonUtil.getSuccess(CommonContact.FETCH_SUCCESS, CommonContact.FETCH_SUCCESS, page);
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
