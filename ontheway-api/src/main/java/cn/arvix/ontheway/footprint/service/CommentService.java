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
import cn.arvix.ontheway.footprint.dto.CommentCreateDTO;
import cn.arvix.ontheway.footprint.dto.CommentDetailDTO;
import cn.arvix.ontheway.footprint.entity.Comment;
import cn.arvix.ontheway.footprint.entity.Footprint;
import cn.arvix.ontheway.footprint.repository.CommentRepository;
import cn.arvix.ontheway.sys.config.service.ConfigService;
import cn.arvix.ontheway.sys.user.entity.User;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * @author Created by yangyang on 2017/7/30.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class CommentService extends BaseServiceImpl<Comment, Long> {

    private ConfigService configService;

    @Autowired
    public void setConfigService(ConfigService configService) {
        this.configService = configService;
    }

    private StatisticsService statisticsService;

    @Autowired
    public void setStatisticsService(StatisticsService statisticsService) {
        this.statisticsService = statisticsService;
    }

    private FootprintService footprintService;

    @Autowired
    public void setFootprintService(FootprintService footprintService) {
        this.footprintService = footprintService;
    }

    private CommentRepository getCommentRepository() {
        return (CommentRepository) baseRepository;
    }

    /**
     * 根据足迹ID删除评论信息
     *
     * @param footprintIds 足迹IDs
     */
    public void deleteByFootprintIds(List<Long> footprintIds) {
        getCommentRepository().deleteInFootprintId(footprintIds);
    }

    /**
     * 创建评论
     *
     * @return 评论创建成功后会返回评论信息
     */
    @Transactional(rollbackFor = Exception.class)
    public JSONResult create(CommentCreateDTO dto) {
        User user = webContextUtils.getCheckCurrentUser();
        Comment comment = new Comment();
        comment.setUser(user);
        comment.setContent(dto.getContent());
        if (dto.getCommentUserId() != null) {
            User commentUser = new User();
            commentUser.setId(dto.getCommentUserId());
            comment.setCommentUser(commentUser);
        }
        if (dto.getFootprintId() != null) {
            Footprint footprint = footprintService.findOne(dto.getFootprintId());
            if (footprint.getIfDelete()) return JsonUtil.getFailure("footprint already delete", CommonErrorCode.FOOTPRINT_ALREADY_DELETE);
            comment.setFootprint(footprint);
        }
        comment.setReplyCommentId(dto.getReplyCommentId());
        super.save(comment);
        //更新评论统计记录
        statisticsService.updateCommentNumByInstanceId(comment.getFootprint().getId(), 1, SystemModule.footprint);
        return JsonUtil.getSuccess(CommonContact.SAVE_SUCCESS, CommonContact.SAVE_SUCCESS,
                comment.toDetailDTO(configService.getConfigString(CommonContact.QINIU_BUCKET_URL)));
    }

    /**
     * 删除评论，用户调用 只能删除自己的评论
     * 1 删除评论数据
     * 2 更新统计数据
     * 3 更新可能存在关联的评论数据
     *
     * @param id 主键
     * @return 删除结果
     */
    @Transactional(rollbackFor = Exception.class)
    public JSONResult delete_(Long id) {
        Comment comment = super.findOne(id);
        User user = webContextUtils.getCheckCurrentUser();
        if (!Objects.equals(comment.getUser().getId(), user.getId()))
            return JsonUtil.getFailure(CommonContact.NO_PERMISSION, CommonErrorCode.COMMENT_DELETE_NO_PERMISSION);
        super.delete(comment);
        statisticsService.updateCommentNumByInstanceId(comment.getFootprint().getId(), -1, SystemModule.footprint);
        getCommentRepository().updateReplyCommentId(id);
        return JsonUtil.getSuccess(CommonContact.DELETE_SUCCESS, CommonContact.DELETE_SUCCESS);
    }

    /**
     * 获取评论信息，评论按 dateCreated desc 排序
     *
     * @param number      当前页
     * @param size        每页大小
     * @param footprintId 足迹ID
     * @return 评论数据
     */
    public JSONResult search(Integer number, Integer size, Long footprintId,Long currentTime) {
        //检查足迹是否被删除
        Footprint footprint = footprintService.findOne(footprintId);
        if(footprint.getIfDelete()) return JsonUtil.getFailure("footprint already deleted",CommonErrorCode.FOOTPRINT_ALREADY_DELETE);
        return JsonUtil.getSuccess(CommonContact.FETCH_SUCCESS, CommonContact.FETCH_SUCCESS,
                search(number,size,footprintId,currentTime,Boolean.TRUE));
    }

    public Page search(Integer number, Integer size, Long footprintId,Long currentTime, Boolean b) {
        Map<String, Object> params = Maps.newHashMap();
        params.put("footprint.id_eq", footprintId);
        params.put("dateCreated_lte",currentTime);
        Searchable searchable = Searchable.newSearchable(params, new PageRequest(number, size),
                new Sort(Sort.Direction.DESC, "dateCreated"));
        Page<Comment> page = super.findAllWithNoCount(searchable);
        if (page.getContent() != null && page.getContent().size() > 0) {
            String fixUrl = configService.getConfigString(CommonContact.QINIU_BUCKET_URL);
            List<CommentDetailDTO> content = Lists.newArrayListWithCapacity(page.getContent().size());
            page.getContent().forEach(x -> content.add(x.toDetailDTO(fixUrl)));
            page = new PageResult<>(content, searchable.getPage(), page.getTotalElements());
        }
        ((PageResult)page).setCurrentTime(currentTime);
        return page;
    }

}
