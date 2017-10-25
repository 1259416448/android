package cn.arvix.ontheway.footprint.service;

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
import cn.arvix.ontheway.business.entity.Business;
import cn.arvix.ontheway.business.service.BusinessService;
import cn.arvix.ontheway.business.service.BusinessStatisticsService;
import cn.arvix.ontheway.ducuments.entity.Document;
import cn.arvix.ontheway.ducuments.service.DocumentService;
import cn.arvix.ontheway.footprint.dto.CommentDetailDTO;
import cn.arvix.ontheway.footprint.dto.FootprintCreateDTO;
import cn.arvix.ontheway.footprint.dto.FootprintDetailDTO;
import cn.arvix.ontheway.footprint.dto.FootprintSearchListDTO;
import cn.arvix.ontheway.footprint.entity.Footprint;
import cn.arvix.ontheway.footprint.entity.Statistics;
import cn.arvix.ontheway.footprint.repository.FootprintRepository;
import cn.arvix.ontheway.sys.config.service.ConfigService;
import cn.arvix.ontheway.sys.user.entity.User;
import cn.arvix.ontheway.sys.user.service.UserService;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import org.quartz.JobExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import java.util.*;

/**
 * @author Created by yangyang on 2017/7/26.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class FootprintService extends BaseServiceImpl<Footprint, Long> {

    private FootprintRepository getFootprintRepository() {
        return (FootprintRepository) baseRepository;
    }

    private DocumentService documentService;

    @Autowired
    public void setDocumentService(DocumentService documentService) {
        this.documentService = documentService;
    }

    private StatisticsService statisticsService;

    @Autowired
    public void setStatisticsService(StatisticsService statisticsService) {
        this.statisticsService = statisticsService;
    }

    private UserService userService;

    @Autowired
    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    private ConfigService configService;

    @Autowired
    public void setConfigService(ConfigService configService) {
        this.configService = configService;
    }

    private LikeRecordsService likeRecordsService;

    @Autowired
    public void setLikeRecordsService(LikeRecordsService likeRecordsService) {
        this.likeRecordsService = likeRecordsService;
    }

    private CommentService commentService;

    @Autowired
    public void setCommentService(CommentService commentService) {
        this.commentService = commentService;
    }

    private BusinessService businessService;

    @Autowired
    public void setBusinessService(BusinessService businessService) {
        this.businessService = businessService;
    }

    private BusinessStatisticsService businessStatisticsService;

    @Autowired
    public void setBusinessStatisticsService(BusinessStatisticsService businessStatisticsService) {
        this.businessStatisticsService = businessStatisticsService;
    }

    /**
     * 创建一条足迹信息
     *
     * @param dto 足迹信息
     * @return 操作结果
     */
    @Transactional(rollbackFor = Exception.class)
    public JSONResult save(FootprintCreateDTO dto) {
        Assert.notNull(dto.getFootprint(), "footprint is not null");
        Footprint m = dto.getFootprint();
        //如果business > 0 需要检查商家是否存在
        if (m.getBusiness() != null && m.getBusiness() > 0) {
            Business business = businessService.findOneWithNoCheck(m.getBusiness());
            if (business == null || !business.getIfShow() || business.getIfDelete()) {
                return JsonUtil.getFailure("商家信息不存在或已被删除", CommonErrorCode.BUSINESS_IS_NOT_FUND, m.getBusiness());
            }
            m.setIfBusinessComment(Boolean.TRUE);
        }
        //设置当前登陆用户
        m.setUser(webContextUtils.getCheckCurrentUser());
        if (m.getBusiness() != null) {
            m.setIfBusinessComment(Boolean.TRUE);
        }
        //创建统计信息
        Statistics statistics = new Statistics();
        statistics.setSystemModule(SystemModule.footprint);
        statisticsService.save(statistics);
        m.setStatistics(statistics);
        super.save(m);
        statistics.setInstanceId(m.getId());
        //保存document信息
        if (dto.getDocuments() != null) {
            dto.getDocuments().forEach(x -> {
                x.setParentId(m.getId());
                x.setSystemModule(SystemModule.footprint);
                documentService.save_(x);
                //这里暂未增加视频处理
                if (m.getPhoto() == null) {
                    m.setPhoto(x);
                }
            });
        }
        //返回简单信息
        FootprintDetailDTO detailDTO = new FootprintDetailDTO();
        detailDTO.setDateCreated(TimeMaker.toTimeMillis(m.getDateCreated()));
        detailDTO.setFootprintId(m.getId());
        detailDTO.setFootprintAddress(m.getAddress());
        detailDTO.setFootprintContent(m.getContent());
        detailDTO.setDateCreatedStr(TimeMaker.dateCreatedStr(detailDTO.getDateCreated()));
        if (dto.getDocuments() != null) {
            List<String> footprintPhotoArray = Lists.newArrayListWithCapacity(dto.getDocuments().size());
            String fixUrl = configService.getConfigString(CommonContact.QINIU_BUCKET_URL);
            dto.getDocuments().forEach(x -> footprintPhotoArray.add(fixUrl + x.getFileUrl()));
            //照片数据
            detailDTO.setFootprintPhotoArray(footprintPhotoArray);
        }
        detailDTO.setDay(TimeMaker.getDayStr(detailDTO.getDateCreated()));
        //商家统计数据+1
        if (m.getIfBusinessComment()) {
            businessStatisticsService.updateCommentNum(m.getBusiness(), 1);
        }
        return JsonUtil.getSuccess(CommonContact.SAVE_SUCCESS, CommonContact.SAVE_SUCCESS, detailDTO);
    }


    /**
     * 获取足迹检索数据，根据type类型进行加载
     *
     * @param type      请求业务类型 AR List Map
     * @param number    当前页
     * @param size      每页大小 最大每页50个
     * @param latitude  纬度 不能为空
     * @param longitude 经度 不能为空
     * @param distance  加载的数据范围 100m 500m 1000m
     * @param time      某个时间内的数据
     * @return 检索结果
     */
    public JSONResult search(FootprintService.SearchType type, Integer number, Integer size,
                             Double latitude, Double longitude, FootprintService.SearchDistance searchDistance,
                             FootprintService.SearchTime time, Double distance, Long currentTime) {
        String urlFix = configService.getConfigString(CommonContact.QINIU_BUCKET_URL);
        if (number == null) number = 0;
        Map<String, Object> params = Maps.newHashMap();
        params.put("searchType", type);
        params.put("latitude", latitude);
        params.put("longitude", longitude);
        params.put("ifDelete_eq", Boolean.FALSE);
        if (currentTime == null) {
            currentTime = System.currentTimeMillis();
        }
        params.put("dateCreated_lte", new Date(currentTime));
        if (SearchType.list.equals(type)) {
            Page page = listSearch(number, size, currentTime, params, urlFix);
            return JsonUtil.getSuccess(CommonContact.FETCH_SUCCESS, CommonContact.FETCH_SUCCESS, page);
        } else if (SearchType.map.equals(type)) { //地图抓取数据，每次默认获取30条数据，默认按时间先后排序
            if (SearchDistance.one.equals(searchDistance)) {
                distance = 0.1;
            } else if (SearchDistance.two.equals(searchDistance)) {
                distance = 0.5;
            } else if (SearchDistance.three.equals(searchDistance)) {
                distance = 1.0;
            }
            Page page = mapSearch(number, size, distance, currentTime, time, params, urlFix);
            return JsonUtil.getSuccess(CommonContact.FETCH_SUCCESS, CommonContact.FETCH_SUCCESS, page);
        } else if (SearchType.ar.equals(type)) { //默认按时间先后顺序排序
            Page page = arSearch(number, size, searchDistance, time, currentTime, params, urlFix);
            return JsonUtil.getSuccess(CommonContact.FETCH_SUCCESS, CommonContact.FETCH_SUCCESS, page);
        }
        return JsonUtil.getSuccess(CommonContact.FETCH_SUCCESS, CommonContact.FETCH_SUCCESS);
    }

    /**
     * 加载list列表可以展示的数据
     */
    private Page listSearch(Integer number, Integer size, Long currentTime,
                            Map<String, Object> params, String urlFix) {
        if (size == null) size = 15;
        Searchable searchable = Searchable.newSearchable(params, new PageRequest(number, size));
        //设置默认搜索范围 1km
        searchable.addSearchParam("distance", 1.0);
        //new Sort(Sort.Direction.ASC,"distance")
        //.and(new Sort(Sort.Direction.DESC,"dateCreated")));
        Page<Footprint> page = super.findAllWithNoCount(searchable);
        if (page.getContent() != null && page.getContent().size() > 0) {
            List<FootprintSearchListDTO> content = Lists.newArrayList();
            page.getContent().forEach(x -> {
                FootprintSearchListDTO dto = new FootprintSearchListDTO();
                dto.setUserId(x.getUser().getId());
                x.setUser(userService.findOne(x.getUser().getId()));
                dto.setUserHeadImg(urlFix + x.getUser().getHeadImg() + "?" + CommonContact.USER_HEAD_IMG_FIX);
                dto.setUserNickname(x.getUser().getName());
                dto.setFootprintContent(x.getContent());
                dto.setFootprintAddress(x.getAddress());
                dto.setDateCreated(TimeMaker.toTimeMillis(x.getDateCreated()));
                dto.setDateCreatedStr(TimeMaker.dateCreatedStr(dto.getDateCreated()));
                dto.setFootprintPhoto(x.getFootprintPhoto() == null ? null : urlFix + x.getFootprintPhoto());
                dto.setFootprintId(x.getId());
                dto.setFootprintType(x.getType());
                dto.setDistance(x.getDistance());
                content.add(dto);
            });
            page = new PageResult<>(
                    content,
                    searchable.getPage(),
                    page.getTotalElements()
            );
            ((PageResult) page).setCurrentTime(currentTime);
        }
        return page;
    }


    /**
     * 加载map中可以展示的数据
     */
    private Page mapSearch(Integer number, Integer size,
                           Double distance, Long currentTime, FootprintService.SearchTime time,
                           Map<String, Object> params, String urlFix) {
        if (size == null) size = 30;
        if (distance == null) distance = 1.5;
        if (distance > 10.0) distance = 10.0;
        params.put("distance", distance);//检索半径
        Long minTime = null;
        if (SearchTime.oneDay.equals(time)) {
            minTime = currentTime - TimeMaker.ONE_DAY;
        } else if (SearchTime.sevenDay.equals(time)) {
            minTime = currentTime - 7 * TimeMaker.ONE_DAY;
        } else if (SearchTime.oneMonth.equals(time)) {
            minTime = currentTime - TimeMaker.ONE_MONTH;
        }
        if (minTime != null) {
            params.put("dateCreated_gte", new Date(minTime));
        }
        Searchable searchable = Searchable.newSearchable(params, new PageRequest(number, size),
                new Sort(Sort.Direction.DESC, "dateCreated"));
        Page<Footprint> page = super.findAll(searchable);
        if (page.getContent() != null && page.getContent().size() > 0) {

            //图片数据
            List<Long> parentIds = Lists.newArrayListWithCapacity(page.getContent().size());
            page.getContent().forEach(x -> parentIds.add(x.getId()));
            //获取所有footprint的照片数据
            Map<String, Object> params1 = Maps.newHashMap();
            params1.put("parentId_in", parentIds);
            params1.put("systemModule_eq", SystemModule.footprint);
            List<Document> documents = documentService.findAllWithNoPageNoSort(Searchable.newSearchable(params1));
            Map<Long, List<String>> photoListMap = Maps.newHashMap();
            if (documents != null && documents.size() > 0) {
                for (Document document : documents) {
                    List<String> list = photoListMap.computeIfAbsent(document.getParentId(), k -> Lists.newArrayList());
                    list.add(urlFix + document.getFileUrl());
                }
            }

            List<FootprintSearchListDTO> content = Lists.newArrayList();

            page.getContent().forEach(x -> {
                FootprintSearchListDTO dto = new FootprintSearchListDTO();
                dto.setUserId(x.getUser().getId());
                x.setUser(userService.findOne(x.getUser().getId()));
                dto.setUserHeadImg(urlFix + x.getUser().getHeadImg() + "?" + CommonContact.USER_HEAD_IMG_FIX);
                dto.setUserNickname(x.getUser().getName());
                dto.setFootprintId(x.getId());
                dto.setFootprintContent(x.getContent());
                dto.setFootprintAddress(x.getAddress());
                dto.setDateCreated(TimeMaker.toTimeMillis(x.getDateCreated()));
                dto.setDateCreatedStr(TimeMaker.dateCreatedStr(dto.getDateCreated()));
                dto.setLatitude(x.getLatitude());
                dto.setLongitude(x.getLongitude());
                dto.setFootprintPhotoArray(photoListMap.get(x.getId()));
                content.add(dto);
            });
            page = new PageResult<>(
                    content,
                    searchable.getPage(),
                    page.getTotalElements()
            );
            ((PageResult) page).setCurrentTime(currentTime);
        }
        return page;
    }


    /**
     * 加载ar足迹模块需要展示的数据
     */
    private Page arSearch(Integer number, Integer size,
                          FootprintService.SearchDistance searchDistance,
                          FootprintService.SearchTime time, Long currentTime,
                          Map<String, Object> params, String urlFix) {
        if (size == null) size = 30;
        if (size > 50) size = 50;
        if (SearchDistance.one.equals(searchDistance)) {
            params.put("distance", 0.1);
        } else if (SearchDistance.two.equals(searchDistance)) {
            params.put("distance", 0.5);
        } else {
            params.put("distance", 1.0);
        }
        Long minTime = null;
        if (SearchTime.oneDay.equals(time)) {
            minTime = currentTime - TimeMaker.ONE_DAY;
        } else if (SearchTime.sevenDay.equals(time)) {
            minTime = currentTime - 7 * TimeMaker.ONE_DAY;
        } else if (SearchTime.oneMonth.equals(time)) {
            minTime = currentTime - TimeMaker.ONE_MONTH;
        }
        if (minTime != null) {
            params.put("dateCreated_gte", new Date(minTime));
        }
        Searchable searchable = Searchable.newSearchable(params, new PageRequest(number, size),
                new Sort(Sort.Direction.DESC, "dateCreated"));

        Page<Footprint> page = super.findAll(searchable);
        if (page.getContent() != null && page.getContent().size() > 0) {
            List<FootprintSearchListDTO> content = Lists.newArrayList();
            page.getContent().forEach(x -> {
                FootprintSearchListDTO dto = new FootprintSearchListDTO();
                dto.setUserId(x.getUser().getId());
                x.setUser(userService.findOne(x.getUser().getId()));
                dto.setUserHeadImg(urlFix + x.getUser().getHeadImg() + "?" + CommonContact.USER_HEAD_IMG_FIX);
                dto.setUserNickname(x.getUser().getName());
                dto.setFootprintContent(x.getContent());
                dto.setFootprintAddress(x.getAddress());
                dto.setDateCreated(TimeMaker.toTimeMillis(x.getDateCreated()));
                dto.setDateCreatedStr(TimeMaker.dateCreatedStr(dto.getDateCreated()));
                dto.setFootprintPhoto(x.getFootprintPhoto() == null ? null : urlFix + x.getFootprintPhoto());
                dto.setFootprintId(x.getId());
                dto.setFootprintType(x.getType());
                dto.setDistance(x.getDistance());
                dto.setLongitude(x.getLongitude());
                dto.setLatitude(x.getLatitude());
                content.add(dto);
            });
            page = new PageResult<>(
                    content,
                    searchable.getPage(),
                    page.getTotalElements()
            );
            ((PageResult) page).setCurrentTime(currentTime);
        }
        return page;
    }

    /**
     * 通过足迹ID获取
     * 返回足迹信息，包括足迹统计信息以及前10条评论信息
     * 返回当前用户的点赞情况
     *
     * @param id 足迹ID
     * @return 足迹详情信息
     */
    public JSONResult view(Long id) {
        Footprint footprint = super.findOne(id);
        if (footprint.getIfDelete()) return JsonUtil.getFailure("footprint already delete", CommonErrorCode.FOOTPRINT_ALREADY_DELETE);
        FootprintDetailDTO dto = new FootprintDetailDTO();
        String urlFix = configService.getConfigString(CommonContact.QINIU_BUCKET_URL);
        dto.setUserHeadImg(urlFix + footprint.getUser().getHeadImg() + "?" + CommonContact.USER_HEAD_IMG_FIX);
        dto.setUserNickname(footprint.getUser().getName());
        dto.setUserId(footprint.getUser().getId());
        dto.setFootprintContent(footprint.getContent());
        dto.setFootprintAddress(footprint.getAddress());
        dto.setDateCreated(TimeMaker.toTimeMillis(footprint.getDateCreated()));
        dto.setDateCreatedStr(TimeMaker.dateCreatedStr(dto.getDateCreated()));
        dto.setFootprintId(footprint.getId());
        dto.setFootprintType(footprint.getType());
        dto.setFootprintCommentNum(footprint.getStatistics().getCommentNum());
        dto.setFootprintLikeNum(footprint.getStatistics().getLikeNum());
        dto.setBusiness(footprint.getBusiness());
        //封面图片
        dto.setFootprintPhoto(footprint.getFootprintPhoto() == null ? null : urlFix + footprint.getFootprintPhoto());
        if (footprint.getFootprintPhoto() != null) {
            //加载所有图片信息
            List<Document> documents = documentService.findByParentId(id, SystemModule.footprint);
            //图片列表信息
            if (documents != null) {
                List<String> footprintPhotoArray = Lists.newArrayListWithCapacity(documents.size());
                documents.forEach(x -> footprintPhotoArray.add(urlFix + x.getFileUrl()));
                dto.setFootprintPhotoArray(footprintPhotoArray);
            }
        }
        //默认加载10条评论信息
        @SuppressWarnings("unchecked")
        Page<CommentDetailDTO> page = commentService.search(0, 10, footprint.getId(), System.currentTimeMillis(), Boolean.TRUE);
        dto.setCurrentTime(((PageResult) page).getCurrentTime());
        dto.setComments(page.getContent());

        //如果当前用户已经登录，需要返回一个是否点赞的数据
        User user = webContextUtils.getCurrentUser();
        if (user != null) {
            if (likeRecordsService.countByUserIdAndFootprintId(user.getId(), footprint.getId()) > 0) {
                dto.setIfLike(Boolean.TRUE);
            } else {
                dto.setIfLike(Boolean.FALSE);
            }
        }
        return JsonUtil.getSuccess(CommonContact.FETCH_SUCCESS, CommonContact.FETCH_SUCCESS, dto);
    }

    /**
     * 删除足迹，用户删除足迹，管理员删除不掉此接口
     * 当前接口只是修改了足迹的状态信息，真正的删除是异步任务完成的
     *
     * @param id 主键
     * @return 删除结果
     */
    public JSONResult delete_(Long id) {
        User user = webContextUtils.getCheckCurrentUser();
        Footprint footprint = super.findOne(id);
        if (footprint.getIfDelete()) return JsonUtil.getSuccess(CommonContact.DELETE_SUCCESS, CommonContact.DELETE_SUCCESS, id);
        //判断一下是否可以删除
        if (!Objects.equals(user.getId(), footprint.getUser().getId())) {
            return JsonUtil.getFailure(CommonContact.NO_PERMISSION, CommonErrorCode.FOOTPRINT_DELETE_NO_PERMISSION);
        }
        //设置当前足迹标示为已删除，异步删除
        //异步删除统计信息、点赞记录、图片等关联信息
        footprint.setIfDelete(Boolean.TRUE);
        super.update(footprint);
        //商家统计数据 - 1
        if (footprint.getIfBusinessComment()) {
            businessStatisticsService.updateCommentNum(footprint.getBusiness(), -1);
        }
        return JsonUtil.getSuccess(CommonContact.DELETE_SUCCESS, CommonContact.DELETE_SUCCESS, id);
    }

    /**
     * 正真删除足迹信息，定时任务调用此方法进行删除操作
     * 每次执行 删除10条数据
     */
    @Transactional(rollbackFor = Exception.class)
    public void delete(JobExecutionContext context) {
        //获取已删除的数据
        Map<String, Object> params = Maps.newHashMap();
        params.put("ifDelete_eq", Boolean.TRUE);
        //设置删除后的数据只能保存一天，一天后定时任务会自动清空
        params.put("lastUpdated_lt", new Date(System.currentTimeMillis() - TimeMaker.ONE_DAY));
        List<Footprint> footprints = super.findAllWithNoCount(Searchable.newSearchable(params, new PageRequest(0, 10))).getContent();
        if (footprints != null && footprints.size() > 0) {
            List<Long> footprintIds = Lists.newArrayListWithCapacity(footprints.size());
            footprints.forEach(x -> footprintIds.add(x.getId()));
            //1、删除评论
            commentService.deleteByFootprintIds(footprintIds);
            //2、删除足迹
            Long[] ids = new Long[footprintIds.size()];
            super.delete(footprintIds.toArray(ids));
            //3、删除点赞记录
            likeRecordsService.deleteByFootprintIds(footprintIds);
            //4、删除document
            documentService.deleteByParentIds(footprintIds, SystemModule.footprint);
            //5、删除统计数据
            statisticsService.deleteByInstanceIds(footprintIds, SystemModule.footprint);
        }
    }

    /**
     * 足迹点赞，第一次请求为点赞，再次请求为取消点赞
     * 1、查询点赞记录表
     * 2、如果存在，取消点赞
     * 3、不存在、添加点在
     *
     * @param id 足迹ID
     * @return 操作结果
     */
    @Transactional(rollbackFor = Exception.class)
    public JSONResult like(Long id) {
        Footprint footprint = super.findOne(id);
        if (footprint.getIfDelete()) return JsonUtil.getFailure("footprint already delete", CommonErrorCode.FOOTPRINT_ALREADY_DELETE);
        User user = webContextUtils.getCheckCurrentUser();
        int value = 1;
        if (likeRecordsService.countByUserIdAndFootprintId(user.getId(), id) == 0) {
            //增加点赞
            likeRecordsService.createByUserIdAndFootprintId(user.getId(), id, footprint.getUser().getId());
        } else {
            //删除点赞
            likeRecordsService.deleteByUserIdAndFootprintId(user.getId(), id);
            //点赞统计-1
            value = -1;
        }
        statisticsService.updateByInstanceId(id, value, SystemModule.footprint);
        return JsonUtil.getSuccess(CommonContact.OPTION_SUCCESS, CommonContact.OPTION_SUCCESS);
    }

    /**
     * 通过用户ID获取当前用户下的足迹信息
     * 按dateCreated desc 排序
     *
     * @param number 当前页
     * @param size   每页大小
     * @param userId 用户ID
     * @return 查询结果
     */
    public JSONResult searchByUserId(Integer number, Integer size, Long userId, Long currentTime) {
        if (currentTime == null) {
            currentTime = System.currentTimeMillis();
        }
        Map<String, Object> params = Maps.newHashMap();
        params.put("dateCreated_lte", new Date(currentTime));
        params.put("user.id_eq", userId);
        params.put("ifDelete_eq", Boolean.FALSE);
        if (size == null || size > 30) size = 15;
        if (number == null) number = 0;
        Searchable searchable = Searchable.newSearchable(params, new PageRequest(number, size),
                new Sort(Sort.Direction.DESC, "dateCreated"));
        Page<Footprint> page = super.findAllWithNoCount(searchable);
        if (page.getContent() != null && page.getContent().size() > 0) {
            //构建dto，数据需要分组展示
            page = new PageResult<>(userFootprintList(page.getContent()), searchable.getPage(), page.getTotalElements());
        }
        ((PageResult) page).setCurrentTime(currentTime);
        return JsonUtil.getSuccess(CommonContact.FETCH_SUCCESS, CommonContact.FETCH_SUCCESS, page);
    }

    /**
     * 通过footprints数组 构建需要的数据
     *
     * @param footprints footprint list 数据
     * @return 构建结果
     */
    @SuppressWarnings("unchecked")
    private List<Map<String, Object>> userFootprintList(List<Footprint> footprints) {
        List<Long> parentIds = Lists.newArrayListWithCapacity(footprints.size());
        footprints.forEach(x -> parentIds.add(x.getId()));
        //获取所有footprint的照片数据
        Map<Long, List<String>> photoListMap = documentService.findFileUrlByParentIds(parentIds, SystemModule.footprint);
        List<Map<String, Object>> list = Lists.newArrayList();
        String currentTimeStr = TimeMaker.toDateStr(new Date(System.currentTimeMillis()));
        footprints.forEach(x -> {
            Map<String, Object> monthMap = null;
            String month = "0";
            String day = "今天";
            if (!currentTimeStr.equals(TimeMaker.toDateStr(x.getDateCreated()))) {
                month = TimeMaker.getMonth(x.getDateCreated()).toString();
                day = TimeMaker.getDayStr(x.getDateCreated()) + "日";
            }
            for (Map<String, Object> c : list) {
                if (month.equals(c.get("month"))) {
                    monthMap = c;
                    break;
                }
            }
            if (monthMap == null) {
                monthMap = Maps.newHashMap();
                monthMap.put("month", month);
                monthMap.put("monthData", Lists.newArrayList());
                list.add(monthMap);
            }
            List<FootprintDetailDTO> dayList = (List<FootprintDetailDTO>) monthMap.get("monthData");

            FootprintDetailDTO detailDTO = new FootprintDetailDTO();
            detailDTO.setDateCreated(TimeMaker.toTimeMillis(x.getDateCreated()));
            detailDTO.setFootprintId(x.getId());
            detailDTO.setFootprintAddress(x.getAddress());
            detailDTO.setFootprintContent(x.getContent());
            //照片数据
            detailDTO.setFootprintPhotoArray(photoListMap.get(x.getId()));
            detailDTO.setDay(day);
            dayList.add(detailDTO);
        });
        return list;
    }

    /**
     * 获取商家的足迹点评数据，分页获取，这里不进行count计数操作
     *
     * @param number      当前页
     * @param size        每页大小
     * @param currentTime 请求时间
     * @param businessId  商家ID
     * @return 获取足迹信息
     */
    public Page searchByBusinessId(Integer number, Integer size, Long currentTime, Long businessId) {
        if (currentTime == null) {
            currentTime = System.currentTimeMillis();
        }
        Map<String, Object> params = Maps.newHashMap();
        params.put("business_eq", businessId);
        params.put("dateCreated_lte", new Date(currentTime));
        params.put("ifDelete_eq", Boolean.FALSE);
        Searchable searchable = Searchable.newSearchable(params,
                new PageRequest(number, size),
                new Sort(Sort.Direction.DESC, "dateCreated"));
        Page<Footprint> page = super.findAllWithNoCount(searchable);
        //构建详情数据
        if (page.getContent().size() > 0) {
            Set<Long> footprintIdSet = Sets.newHashSetWithExpectedSize(page.getContent().size());
            page.getContent().forEach(x -> footprintIdSet.add(x.getId()));
            //获取统计数据
            Map<Long, Statistics> statisticsMap = statisticsService.findByFootprintIds(footprintIdSet);
            //获取足迹照片数据
            Map<Long, List<String>> photoListMap = documentService.findFileUrlByParentIds(footprintIdSet, SystemModule.footprint);

            User user = webContextUtils.getCurrentUser();

            String urlFix = configService.getConfigString(CommonContact.QINIU_BUCKET_URL);

            Map<Long, Boolean> likeResMap = null;
            //如果当前用户登陆，获取当前用户的点赞记录
            if (user != null) {
                likeResMap = likeRecordsService.findLikeByFootprintIdsAndUserId(footprintIdSet, user.getId());
            }

            List<FootprintDetailDTO> content = Lists.newArrayListWithCapacity(page.getContent().size());
            //组装数据
            Map<Long, Boolean> finalLikeResMap = likeResMap;
            page.getContent().forEach(x -> {
                FootprintDetailDTO detailDTO = new FootprintDetailDTO();
                detailDTO.setUserId(x.getUser().getId());
                detailDTO.setUserHeadImg(urlFix + x.getUser().getHeadImg() + "?" + CommonContact.USER_HEAD_IMG_FIX);
                detailDTO.setUserNickname(x.getUser().getName());

                detailDTO.setDateCreated(TimeMaker.toTimeMillis(x.getDateCreated()));
                detailDTO.setDateCreatedStr(TimeMaker.dateCreatedStr(detailDTO.getDateCreated()));
                detailDTO.setFootprintContent(x.getContent());
                detailDTO.setFootprintPhotoArray(photoListMap.get(x.getId()));

                //目前后台没有添加视频支持
                detailDTO.setFootprintType(Footprint.FootprintType.photo);

                //评论
                detailDTO.setFootprintCommentNum(statisticsMap.get(x.getId()).getCommentNum());
                detailDTO.setFootprintLikeNum(statisticsMap.get(x.getId()).getLikeNum());
                if (finalLikeResMap != null && finalLikeResMap.get(x.getId())) {
                    detailDTO.setIfLike(Boolean.TRUE);
                } else {
                    detailDTO.setIfLike(Boolean.FALSE);
                }
                detailDTO.setFootprintId(x.getId());

                content.add(detailDTO);
            });
            page = new PageResult<>(content, searchable.getPage(), page.getTotalElements());
        }
        ((PageResult) page).setCurrentTime(currentTime);
        return page;
    }


    /**
     * 获取 某个 用户 能查询的最新足迹动态
     * 某个用户关注的用户足迹动态，按发布时间 DESC 排序
     *
     * @param number      当前页
     * @param size        每页大小
     * @param currentTime 抓取时间
     * @param userId      某个用户ID
     * @return Page 结果
     */
    public Page searchAttentionByUserId(Integer number, Integer size, Long currentTime, Long userId) {
        if (currentTime == null) {
            currentTime = System.currentTimeMillis();
        }

        Map<String, Object> params = Maps.newHashMap();
        params.put("attention", userId); //某个用户
        params.put("dateCreated_lte", new Date(currentTime));
        params.put("ifDelete_eq", Boolean.FALSE);
        Searchable searchable = Searchable.newSearchable(params,
                new PageRequest(number, size),
                new Sort(Sort.Direction.DESC, "dateCreated"));
        Page<Footprint> page = super.findAllWithNoCount(searchable);
        if (page.getContent().size() > 0) {
            Set<Long> footprintIdSet = Sets.newHashSetWithExpectedSize(page.getContent().size());
            page.getContent().forEach(x -> footprintIdSet.add(x.getId()));
            //获取足迹照片数据
            Map<Long, List<String>> photoListMap = documentService.findFileUrlByParentIds(footprintIdSet, SystemModule.footprint);
            String urlFix = configService.getConfigString(CommonContact.QINIU_BUCKET_URL);
            List<FootprintDetailDTO> content = Lists.newArrayListWithCapacity(page.getContent().size());
            page.getContent().forEach(x -> {
                FootprintDetailDTO detailDTO = new FootprintDetailDTO();
                detailDTO.setUserId(x.getUser().getId());
                detailDTO.setUserHeadImg(urlFix + x.getUser().getHeadImg() + "?" + CommonContact.USER_HEAD_IMG_FIX);
                detailDTO.setUserNickname(x.getUser().getName());

                detailDTO.setDateCreated(TimeMaker.toTimeMillis(x.getDateCreated()));
                detailDTO.setDateCreatedStr(TimeMaker.dateCreatedStr(detailDTO.getDateCreated()));
                detailDTO.setFootprintContent(x.getContent());
                detailDTO.setFootprintPhotoArray(photoListMap.get(x.getId()));

                //目前后台没有添加视频支持
                detailDTO.setFootprintType(Footprint.FootprintType.photo);

                detailDTO.setFootprintId(x.getId());
                detailDTO.setFootprintAddress(x.getAddress());
                content.add(detailDTO);
            });
            page = new PageResult<>(content, searchable.getPage(), page.getTotalElements());
        }
        ((PageResult) page).setCurrentTime(currentTime);
        return page;
    }

    /**
     * 通过足迹ID获取足迹数据
     *
     * @param footprintIds 足迹ID数据
     * @return footprint list
     */
    public List<Footprint> findFootprintByIds(Set<Long> footprintIds) {
        Map<String, Object> params = Maps.newHashMap();
        params.put("id_in", footprintIds);
        return super.findAllWithNoPageNoSort(Searchable.newSearchable(params));
    }

    /**
     * 通过商家ID获取 n 张足迹图片
     *
     * @param businessId 商家ID
     * @param number     抓取数量
     */
    public List<String> findPhotoUrlByBusinessId(Long businessId, int number) {
        return getFootprintRepository().findPhotoUrlByBusinessId(businessId, number);
    }


    //检索的几种类型
    public enum SearchType {
        ar, list, map
    }

    //时间筛选 1天内 7天内 1月内
    public enum SearchTime {
        oneDay, sevenDay, oneMonth
    }

    //范围筛选 100m 500m 1km
    public enum SearchDistance {
        one, two, three
    }

}
