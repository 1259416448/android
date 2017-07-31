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
import cn.arvix.ontheway.ducuments.entity.Document;
import cn.arvix.ontheway.ducuments.service.DocumentService;
import cn.arvix.ontheway.footprint.dto.CommentDetailDTO;
import cn.arvix.ontheway.footprint.dto.FootprintCreateDTO;
import cn.arvix.ontheway.footprint.dto.FootprintDetailDTO;
import cn.arvix.ontheway.footprint.dto.FootprintSearchListDTO;
import cn.arvix.ontheway.footprint.entity.Footprint;
import cn.arvix.ontheway.footprint.entity.Statistics;
import cn.arvix.ontheway.sys.config.service.ConfigService;
import cn.arvix.ontheway.sys.user.entity.User;
import cn.arvix.ontheway.sys.user.service.UserService;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.quartz.JobExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * @author Created by yangyang on 2017/7/26.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class FootprintService extends BaseServiceImpl<Footprint, Long> {

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
        return JsonUtil.getSuccess(CommonContact.SAVE_SUCCESS, CommonContact.SAVE_SUCCESS);
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
                             Double latitude, Double longitude, FootprintService.SearchDistance distance,
                             FootprintService.SearchTime time) {
        String urlFix = configService.getConfigString(CommonContact.QINIU_BUCKET_URL);
        if (number == null) number = 0;
        Map<String, Object> params = Maps.newHashMap();
        params.put("searchType", type);
        params.put("latitude", latitude);
        params.put("longitude", longitude);
        params.put("ifDelete_eq",Boolean.FALSE);
        if (SearchType.list.equals(type)) {
            if (size == null) size = 15;
            Searchable searchable = Searchable.newSearchable(params, new PageRequest(number, size));
            //new Sort(Sort.Direction.ASC,"distance")
            //.and(new Sort(Sort.Direction.DESC,"dateCreated")));
            Page<Footprint> page = super.findAll(searchable);
            if (page.getContent() != null) {
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
                    dto.setDataCreatedStr(TimeMaker.dateCreatedStr(dto.getDateCreated()));
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
            }
            return JsonUtil.getSuccess(CommonContact.FETCH_SUCCESS, CommonContact.FETCH_SUCCESS, page);
        }
        return JsonUtil.getSuccess(CommonContact.FETCH_SUCCESS, CommonContact.FETCH_SUCCESS);
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
        if(footprint.getIfDelete()) return JsonUtil.getFailure("footprint already delete",CommonErrorCode.FOOTPRINT_ALREADY_DELETE);
        FootprintDetailDTO dto = new FootprintDetailDTO();
        String urlFix = configService.getConfigString(CommonContact.QINIU_BUCKET_URL);
        dto.setUserHeadImg(urlFix + footprint.getUser().getHeadImg()+"?"+CommonContact.USER_HEAD_IMG_FIX);
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
        Page<CommentDetailDTO> page = commentService.search(0,10,footprint.getId(), Boolean.TRUE);
        dto.setComments(page.getContent());

        //如果当前用户已经登录，需要返回一个是否点赞的数据
        User user = webContextUtils.getCurrentUser();
        if(user!=null){
            if(likeRecordsService.countByUserIdAndFootprintId(user.getId(),footprint.getId())>0){
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
     * @param id 主键
     * @return 删除结果
     */
    public JSONResult delete_(Long id){
        User user = webContextUtils.getCheckCurrentUser();
        Footprint footprint = super.findOne(id);
        //判断一下是否可以删除
        if(!Objects.equals(user.getId(),footprint.getUser().getId())){
            return JsonUtil.getFailure(CommonContact.NO_PERMISSION, CommonErrorCode.FOOTPRINT_DELETE_NO_PERMISSION);
        }
        //设置当前足迹标示为已删除，异步删除
        //异步删除统计信息、点赞记录、图片等关联信息
        footprint.setIfDelete(Boolean.TRUE);
        super.update(footprint);
        return JsonUtil.getSuccess(CommonContact.DELETE_SUCCESS,CommonContact.DELETE_SUCCESS,id);
    }

    /**
     * 正真删除足迹信息，定时任务调用此方法进行删除操作
     * 每次执行 删除10条数据
     */
    @Transactional(rollbackFor = Exception.class)
    public void delete(JobExecutionContext context){
        //获取已删除的数据
        Map<String,Object> params = Maps.newHashMap();
        params.put("ifDelete_eq",Boolean.TRUE);
        //设置删除后的数据只能保存一天，一天后定时任务会自动清空
        params.put("dateCreated_lt",new Date(System.currentTimeMillis()-TimeMaker.ONE_DAY));
        List<Footprint> footprints = super.findAll(Searchable.newSearchable(params,new PageRequest(0,10))).getContent();
        if(footprints!=null && footprints.size()>0){
            List<Long> footprintIds = Lists.newArrayListWithCapacity(footprints.size());
            footprints.forEach(x-> footprintIds.add(x.getId()));
            //1、删除评论
            commentService.deleteByFootprintIds(footprintIds);
            //2、删除足迹
            Long[] ids = new Long[footprintIds.size()];
            super.delete(footprintIds.toArray(ids));
            //3、删除点赞记录
            likeRecordsService.deleteByFootprintIds(footprintIds);
            //4、删除document
            documentService.deleteByParentIds(footprintIds,SystemModule.footprint);
            //5、删除统计数据
            statisticsService.deleteByInstanceIds(footprintIds,SystemModule.footprint);
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
        User user = webContextUtils.getCheckCurrentUser();
        int value = 1;
        if (likeRecordsService.countByUserIdAndFootprintId(user.getId(), id) == 0) {
            //增加点赞
            likeRecordsService.createByUserIdAndFootprintId(user.getId(), id);
        } else {
            //删除点赞
            likeRecordsService.deleteByUserIdAndFootprintId(user.getId(), id);
            //点赞统计-1
            value = -1;
        }
        statisticsService.updateByInstanceId(id, value, SystemModule.footprint);
        return JsonUtil.getSuccess(CommonContact.OPTION_SUCCESS, CommonContact.OPTION_SUCCESS);
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
