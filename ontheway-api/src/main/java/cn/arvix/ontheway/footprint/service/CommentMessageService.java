package cn.arvix.ontheway.footprint.service;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.entity.PageResult;
import cn.arvix.base.common.entity.search.PageRequest;
import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.base.common.utils.TimeMaker;
import cn.arvix.ontheway.footprint.dto.CommentMessageSearchDTO;
import cn.arvix.ontheway.footprint.entity.Comment;
import cn.arvix.ontheway.footprint.entity.CommentMessage;
import cn.arvix.ontheway.footprint.entity.Footprint;
import cn.arvix.ontheway.footprint.repository.CommentMessageRepository;
import cn.arvix.ontheway.message.dto.MessageTaskDetail;
import cn.arvix.ontheway.message.service.NewMessageCountService;
import cn.arvix.ontheway.sys.config.service.ConfigService;
import cn.arvix.ontheway.sys.user.entity.User;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * @author Created by yangyang on 2017/8/10.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class CommentMessageService extends BaseServiceImpl<CommentMessage, Long> {

    private ConfigService configService;

    @Autowired
    public void setConfigService(ConfigService configService) {
        this.configService = configService;
    }

    private NewMessageCountService newMessageCountService;

    @Autowired
    public void setNewMessageCountService(NewMessageCountService newMessageCountService) {
        this.newMessageCountService = newMessageCountService;
    }

    private CommentMessageRepository getCommentMessageRepository() {
        return (CommentMessageRepository) baseRepository;
    }


    /**
     * 分页获取当前用户的消息列表 按时间 desc排序
     *
     * @param number 当前页
     * @param size   每页大小
     * @return 评论数据
     */
    public JSONResult search(Integer number, Integer size, Long currentTime, boolean clear) {
        User user = webContextUtils.getCheckCurrentUser();
        Map<String, Object> params = Maps.newHashMap();
        params.put("userId_eq", user.getId());
        if (currentTime == null) {
            currentTime = System.currentTimeMillis();
        }
        params.put("dateCreated_lte", currentTime);
        params.put("comment_isNotNull", "");
        if (number == null || number < 0) number = 0;
        if (size == null || size > 30) size = 15;
        Searchable searchable = Searchable.newSearchable(params, new PageRequest(number, size),
                new Sort(Sort.Direction.DESC, "dateCreated"));
        Page<CommentMessage> page = super.findAllWithNoCount(searchable);
        if (page.getContent() != null && page.getContent().size() > 0) {
            List<CommentMessageSearchDTO> content = Lists.newArrayListWithCapacity(page.getContent().size());
            String urlFix = configService.getConfigString(CommonContact.QINIU_BUCKET_URL);
            page.getContent().forEach(x -> {
                CommentMessageSearchDTO dto = CommentMessageSearchDTO.getInstance();
                dto.setUserId(x.getCommentUser().getId());
                dto.setUserNickname(x.getCommentUser().getName());
                dto.setUserHeadImg(urlFix + x.getCommentUser().getHeadImg());
                dto.setFootprintContent(x.getFootprint().getContent());
                dto.setDateCreated(TimeMaker.toTimeMillis(x.getDateCreated()));
                dto.setDateCreatedStr(TimeMaker.toFormatStr(x.getDateCreated(), "MM-dd HH:mm"));
                if (x.getComment() != null) {
                    dto.setCommentId(x.getComment().getId());
                    dto.setCommentContent(x.getComment().getContent());
                }
                content.add(dto);
            });
            page = new PageResult<>(
                    content,
                    searchable.getPage(),
                    page.getTotalElements()
            );
            ((PageResult) page).setCurrentTime(currentTime);
        }
        if (clear) {
            newMessageCountService.updateNewMessageCache(MessageTaskDetail.TaskType.clearComment);
        }
        return JsonUtil.getSuccess(CommonContact.FETCH_SUCCESS, CommonContact.FETCH_SUCCESS, page);
    }

    /**
     * 创建一条消息
     *
     * @param footprint 足迹信息
     * @param comment   评论信息
     */
    public void create(Footprint footprint, Comment comment) {
        //评论人是自己，不添加
        if (Objects.equals(comment.getUser().getId(), footprint.getUser().getId())) return;
        CommentMessage m = new CommentMessage();
        m.setFootprint(footprint);
        m.setUserId(footprint.getUser().getId());
        m.setComment(comment);
        m.setCommentUser(comment.getUser());
        super.save(m);
        //增加消息提醒
        newMessageCountService.updateNewMessageCache(m.getUserId(), MessageTaskDetail.TaskType.comment);
    }

    /**
     * 更新消息信息,足迹删除时调用
     */
    public void updateCommentById(Comment comment) {
        if (comment == null) return;
        CommentMessage commentMessage = getCommentMessageRepository().findByCommentId(comment.getId());
        if (commentMessage != null) {
            commentMessage.setComment(null);
            super.update(commentMessage);
        }
    }

}
