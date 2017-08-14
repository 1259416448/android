package cn.arvix.ontheway.footprint.service;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.entity.PageResult;
import cn.arvix.base.common.entity.search.PageRequest;
import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.base.common.utils.TimeMaker;
import cn.arvix.ontheway.footprint.dto.LikeMessageSearchDTO;
import cn.arvix.ontheway.footprint.entity.Footprint;
import cn.arvix.ontheway.footprint.entity.LikeRecords;
import cn.arvix.ontheway.footprint.repository.LikeRecordsRepository;
import cn.arvix.ontheway.message.dto.MessageTaskDetail;
import cn.arvix.ontheway.message.service.NewMessageCountService;
import cn.arvix.ontheway.sys.config.service.ConfigService;
import cn.arvix.ontheway.sys.user.entity.User;
import cn.arvix.ontheway.sys.user.service.UserService;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

/**
 * @author Created by yangyang on 2017/7/28.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@Service
public class LikeRecordsService extends BaseServiceImpl<LikeRecords, Long> {

    private NewMessageCountService newMessageCountService;

    @Autowired
    public void setNewMessageCountService(NewMessageCountService newMessageCountService) {
        this.newMessageCountService = newMessageCountService;
    }

    private FootprintService footprintService;

    @Autowired
    public void setFootprintService(FootprintService footprintService) {
        this.footprintService = footprintService;
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

    private LikeRecordsRepository getLikeRecordsRepository() {
        return (LikeRecordsRepository) baseRepository;
    }

    /**
     * 通过userId 和 footprintId 查询是否已经点赞
     *
     * @param userId      用户ID
     * @param footprintId 足迹ID
     * @return 0 表示未点赞
     */
    public Long countByUserIdAndFootprintId(Long userId, Long footprintId) {
        Map<String, Object> params = Maps.newHashMap();
        params.put("userId_eq", userId);
        params.put("footprintId_eq", footprintId);
        return super.count(Searchable.newSearchable(params));
    }

    /**
     * 通过用户ID和足迹ID删除点赞记录
     *
     * @param userId      用户ID
     * @param footprintId 足迹ID
     * @return 删除结果
     */
    public int deleteByUserIdAndFootprintId(Long userId, Long footprintId) {
        return getLikeRecordsRepository().deleteByUserIdAndFootprintId(userId, footprintId);
    }

    /**
     * 创建点赞记录
     *
     * @param userId          用户ID
     * @param footprintId     足迹ID
     * @param footprintUserId 足迹发布用户ID
     */
    public void createByUserIdAndFootprintId(Long userId, Long footprintId, Long footprintUserId) {
        LikeRecords records = new LikeRecords();
        records.setUserId(userId);
        records.setFootprintId(footprintId);
        records.setFootprintUserId(footprintUserId);
        super.save(records);
        //增加点赞提醒
        if (!Objects.equals(userId, footprintUserId)) {
            newMessageCountService.updateNewMessageCache(footprintUserId, MessageTaskDetail.TaskType.like);
        }
    }

    /**
     * 通过足迹IDs删除点赞记录
     *
     * @param footprintIds 点赞记录
     */
    public void deleteByFootprintIds(List<Long> footprintIds) {
        getLikeRecordsRepository().deleteInFootprintId(footprintIds);
    }


    /**
     * 获取点赞记录
     *
     * @param number      当前页
     * @param size        每页大小
     * @param currentTime 分页时间
     * @param clear       清空消息缓存
     * @return 新的赞
     */
    public JSONResult search(Integer number, Integer size, Long currentTime, boolean clear) {
        User user = webContextUtils.getCheckCurrentUser();
        Map<String, Object> params = Maps.newHashMap();
        params.put("footprintUserId_eq", user.getId());
        //消息中不加载自己对自己的点赞记录
        params.put("userId_ne", user.getId());
        if (currentTime == null) {
            currentTime = System.currentTimeMillis();
        }
        params.put("dateCreated_lte", currentTime);
        if (number == null || number < 0) number = 0;
        if (size == null || size > 30) size = 15;
        Searchable searchable = Searchable.newSearchable(params, new PageRequest(number, size),
                new Sort(Sort.Direction.DESC, "dateCreated"));
        Page<LikeRecords> page = super.findAllWithNoCount(searchable);
        if (page.getContent() != null && page.getContent().size() > 0) {
            //构建足迹ID set
            Set<Long> footprintIdSets = Sets.newHashSetWithExpectedSize(page.getContent().size());
            Set<Long> userIdSets = Sets.newHashSetWithExpectedSize(page.getContent().size());
            page.getContent().forEach(x -> {
                footprintIdSets.add(x.getFootprintId());
                userIdSets.add(x.getUserId());
            });
            //分别获取用户信息和 足迹信息
            List<User> userList = userService.findUsersByIds(userIdSets);
            List<Footprint> footprintList = footprintService.findFootprintByIds(footprintIdSets);
            //转化为map
            Map<Long, User> userMap = Maps.newHashMapWithExpectedSize(userList.size());
            userList.forEach(x -> userMap.put(x.getId(), x));
            Map<Long, Footprint> footprintMap = Maps.newHashMapWithExpectedSize(footprintList.size());
            footprintList.forEach(x -> footprintMap.put(x.getId(), x));
            //构建前端数据
            List<LikeMessageSearchDTO> content = Lists.newArrayListWithCapacity(page.getContent().size());
            String urlFix = configService.getConfigString(CommonContact.QINIU_BUCKET_URL);
            page.getContent().forEach(x -> {
                User u = userMap.get(x.getUserId());
                Footprint f = footprintMap.get(x.getFootprintId());
                LikeMessageSearchDTO dto = LikeMessageSearchDTO.getInstance();
                dto.setUserId(u.getId());
                dto.setUserNickname(u.getName());
                dto.setUserHeadImg(urlFix + u.getHeadImg() + "?" + CommonContact.USER_HEAD_IMG_FIX);
                dto.setFootprintId(f.getId());
                dto.setFootprintContent(f.getContent());
                dto.setDateCreated(TimeMaker.toTimeMillis(f.getDateCreated()));
                dto.setDateCreatedStr(TimeMaker.toFormatStr(f.getDateCreated(), "MM-dd HH:mm"));
                content.add(dto);
            });
            page = new PageResult<>(
                    content,
                    searchable.getPage(),
                    page.getTotalElements()
            );
        }
        ((PageResult) page).setCurrentTime(currentTime);
        if (clear) {
            newMessageCountService.updateNewMessageCache(MessageTaskDetail.TaskType.clearLike);
        }
        return JsonUtil.getSuccess(CommonContact.FETCH_SUCCESS, CommonContact.FETCH_SUCCESS, page);
    }

}
