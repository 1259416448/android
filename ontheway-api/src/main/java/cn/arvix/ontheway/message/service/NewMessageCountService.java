package cn.arvix.ontheway.message.service;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.ontheway.message.dto.MessageTaskDetail;
import cn.arvix.ontheway.message.entity.NewMessageCount;
import cn.arvix.ontheway.message.repository.NewMessageCountRepository;
import cn.arvix.ontheway.sys.user.entity.User;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.quartz.JobExecutionContext;
import org.redisson.api.RQueue;
import org.redisson.api.RedissonClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * @author Created by yangyang on 2017/8/11.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class NewMessageCountService extends BaseServiceImpl<NewMessageCount, Long> {

    private NewMessageCountRepository getNewMessageCountRepository() {
        return (NewMessageCountRepository) baseRepository;
    }

    private Cache cache;

    @Autowired
    public void setCache(CacheManager cacheManager) {
        this.cache = cacheManager.getCache("otw-new-message-count-cache");
    }

    private RedissonClient redissonClient;

    @Autowired
    public void setRedissonClient(RedissonClient redissonClient) {
        this.redissonClient = redissonClient;
    }

    private final static String NEW_MESSAGE_COUNT_QUEUE = "newMessageCountQueue";

    /**
     * 获取未读消息数量
     *
     * @return Json
     */
    public JSONResult newCount() {
        NewMessageCount messageCount = getNewMessageByLoginUser();
        Map<String, Object> jsonMap = Maps.newHashMap();
        jsonMap.put("systemNum", messageCount.getSystemNum());
        jsonMap.put("likeNum", messageCount.getLikeNum());
        jsonMap.put("CommentNum", messageCount.getCommentNum());
        jsonMap.put("footprintNum", messageCount.getFootprintNum());
        return JsonUtil.getSuccess(CommonContact.OPTION_SUCCESS, CommonContact.OPTION_SUCCESS, jsonMap);
    }

    /**
     * 通过当前登陆用户获取用户的未读消息数
     * 默认加载缓存中的未读消息数，如果缓存中不存在，在数据库中加载到缓存中
     *
     * @return 未读消息数
     */
    public NewMessageCount getNewMessageByLoginUser() {
        User user = webContextUtils.getCheckCurrentUser();
        return getNewMessageByUserId(user.getId());
    }

    public NewMessageCount getNewMessageByUserId(Long userId) {
        Cache.ValueWrapper valueWrapper = cache.get(getCacheKey(userId));
        NewMessageCount messageCount;
        if (valueWrapper == null) {
            messageCount = getNewMessageCountRepository().findByUserId(userId);
            //加入缓存中
            cache.put(getCacheKey(userId), messageCount);
            //这里获取到的对象为持久态对象  需要转化为 没有调用clear方法 使用直接new一个新对象保存
            NewMessageCount temp = NewMessageCount.getInstance();
            temp.setId(messageCount.getId());
            temp.setLikeNum(messageCount.getLikeNum());
            temp.setCommentNum(messageCount.getCommentNum());
            temp.setSystemNum(messageCount.getSystemNum());
            temp.setFootprintNum(messageCount.getFootprintNum());
            temp.setDateCreated(messageCount.getDateCreated());
            temp.setLastUpdated(messageCount.getLastUpdated());
            temp.setCreater(messageCount.getCreater());
            messageCount = temp;
        } else {
            messageCount = (NewMessageCount) valueWrapper.get();
        }
        return messageCount;
    }

    /**
     * 更新用户缓存的消息数据
     *
     * @param taskType 操作类型
     */
    public void updateNewMessageCache(MessageTaskDetail.TaskType taskType) {
        User user = webContextUtils.getCheckCurrentUser();
        updateNewMessageCache(user.getId(), taskType);
    }

    /**
     * 更新用户缓存的消息数据
     *
     * @param taskType 操作类型
     */
    public void updateNewMessageCache(Long userId, MessageTaskDetail.TaskType taskType) {
        NewMessageCount messageCount = getNewMessageByUserId(userId);
        MessageTaskDetail taskDetail = MessageTaskDetail.getInstance();
        taskDetail.setTaskType(taskType);
        switch (taskType) {
            case comment: {
                messageCount.setCommentNum(messageCount.getCommentNum() + 1);
                cache.put(getCacheKey(messageCount.getUserId()), messageCount);
                taskDetail.setOpId(messageCount.getId());

                //推送新的评论消息

                break;
            }
            case footprint: {
                break;
            }
            case like: {
                messageCount.setLikeNum(messageCount.getLikeNum() + 1);
                cache.put(getCacheKey(messageCount.getUserId()), messageCount);
                break;
            }
            case system: {

                break;
            }
            case clearComment: {
                messageCount.setCommentNum(0);
                cache.put(getCacheKey(messageCount.getUserId()), messageCount);
                taskDetail.setOpId(messageCount.getId());
                break;
            }
            case clearLike: {
                messageCount.setLikeNum(0);
                cache.put(getCacheKey(messageCount.getUserId()), messageCount);
            }
            case clearFootprint: {

            }
            case clearSystem: {
                messageCount.setSystemNum(0);
                cache.put(getCacheKey(messageCount.getUserId()), messageCount);
            }
            default:
                break;
        }
        getRQueue().add(taskDetail);
    }

    /**
     * 定时任务消费者，处理推送，更新数据库中未读消息记录
     * 消费任务保存在redis队列中,每次消费10条记录，每10秒执行一次
     */
    public void consumer(JobExecutionContext context) {

        RQueue<MessageTaskDetail> queue = getRQueue();
        if (!queue.isEmpty()) {
            int size = 10;
            List<MessageTaskDetail> messageTaskDetails = Lists.newArrayListWithCapacity(size);
            if (queue.size() <= size) {
                for (int i = queue.size(); i > 0; i--) {
                    if (!queue.isEmpty()) {
                        messageTaskDetails.add(queue.poll());
                        continue;
                    }
                    break;
                }
            } else {
                for (int i = 0; i < size; i++) {
                    if (!queue.isEmpty()) {
                        messageTaskDetails.add(queue.poll());
                        continue;
                    }
                    break;
                }
            }
            //处理任务
            for (MessageTaskDetail taskDetail : messageTaskDetails) {
                switch (taskDetail.getTaskType()) {
                    case comment: {
                        NewMessageCount messageCount = super.findOneWithNoCheck(taskDetail.getOpId());
                        if (messageCount != null) {
                            messageCount.setCommentNum(messageCount.getCommentNum() + 1);
                            super.update(messageCount);
                        }
                        break;
                    }
                    case footprint: {
                        break;
                    }
                    case like: {
                        NewMessageCount messageCount = super.findOneWithNoCheck(taskDetail.getOpId());
                        if (messageCount != null) {
                            messageCount.setLikeNum(messageCount.getLikeNum() + 1);
                            super.update(messageCount);
                        }
                        break;
                    }
                    case system: {
                        break;
                    }
                    case clearComment: {
                        NewMessageCount messageCount = super.findOneWithNoCheck(taskDetail.getOpId());
                        if (messageCount != null) {
                            messageCount.setCommentNum(0);
                            super.update(messageCount);
                        }
                    }
                    case clearLike: {
                        NewMessageCount messageCount = super.findOneWithNoCheck(taskDetail.getOpId());
                        if (messageCount != null) {
                            messageCount.setLikeNum(0);
                            super.update(messageCount);
                        }
                    }
                    case clearFootprint: {

                    }
                    case clearSystem: {

                    }
                    default:
                        break;
                }
            }
        }
    }

    /**
     * 更新所有用户系统消息未读数量
     * 并清理缓存
     */
    @Transactional
    public void updateAllUserSystemCount(int value) {
        getNewMessageCountRepository().updateSystemCount(value);
        cache.clear();
    }

    /**
     * 创建用户消息记录
     *
     * @param user 用户信息
     */
    public void create(User user) {
        NewMessageCount messageCount = NewMessageCount.getInstance();
        messageCount.setUserId(user.getId());
        super.save(messageCount);
        cache.put(getCacheKey(user.getId()), messageCount);
    }


    /**
     * 获取用户key
     *
     * @param id 用户ID
     * @return key
     */
    public String getCacheKey(Long id) {
        return "otw-message-count-" + id;
    }

    /**
     * 清除所有缓存
     */
    public void clear() {
        cache.clear();
    }

    /**
     * 获取当前消息队列
     *
     * @return 消息队列
     */
    public RQueue<MessageTaskDetail> getRQueue() {
        return redissonClient.getQueue(NEW_MESSAGE_COUNT_QUEUE);
    }

}
