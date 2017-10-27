package cn.arvix.ontheway.attention.service;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.ontheway.attention.entity.AttentionStatistics;
import cn.arvix.ontheway.attention.repository.AttentionStatisticsRepository;
import cn.arvix.ontheway.sys.user.entity.User;
import com.google.common.collect.Maps;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

/**
 * @author Created by yangyang on 2017/10/25.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class AttentionStatisticsService extends BaseServiceImpl<AttentionStatistics, Long> {

    private AttentionService attentionService;

    @Autowired
    public void setAttentionService(AttentionService attentionService) {
        this.attentionService = attentionService;
    }

    private AttentionStatisticsRepository getAttentionStatisticsRepository() {
        return (AttentionStatisticsRepository) baseRepository;
    }

    /**
     * 改变某个用户的关注统计
     * 会同时修改 关注者的 关注数  和  被关注者的 粉丝数
     *
     * @param userId          关注者ID
     * @param attentionUserId 被关注者ID
     * @param value           改变值
     */
    @Transactional
    public void changeUserStatistics(Long userId, Long attentionUserId, int value) {
        AttentionStatistics attentionStatistics = getAttentionStatisticsRepository().findByUserId(userId);
        //用户不存在关注统计
        if (attentionStatistics == null) {
            attentionStatistics = save(userId);
        }
        attentionStatistics.setAttentionNum(attentionStatistics.getAttentionNum() + value);
        modify(attentionStatistics);
        super.update(attentionStatistics);

        attentionStatistics = getAttentionStatisticsRepository().findByUserId(attentionUserId);

        if (attentionStatistics == null) {
            attentionStatistics = save(attentionUserId);
        }
        attentionStatistics.setFansNum(attentionStatistics.getFansNum() + value);
        modify(attentionStatistics);
        super.update(attentionStatistics);
    }

    /**
     * 创建某个用户的关注统计
     *
     * @param userId 用户ID
     */
    public AttentionStatistics save(Long userId) {
        AttentionStatistics attentionStatistics = new AttentionStatistics();
        attentionStatistics.setUserId(userId);
        return super.save(attentionStatistics);
    }

    /**
     * 获取某个用户关注情况、粉丝情况、是否关注
     *
     * @param userId 用户ID
     * @return JSONResult
     */
    public JSONResult getInfoByUserId(Long userId) {
        Map<String, Object> map = Maps.newHashMap();
        User user = webContextUtils.getCheckCurrentUser();
        //获取自己的信息  返回粉丝数量、关注数量
        if (Objects.equals(user.getId(), userId)) {
            AttentionStatistics statistics = getAttentionStatisticsRepository().findByUserId(userId);
            Integer fansNum = 0;
            Integer attentionNum = 0;
            if (statistics != null) {
                fansNum = statistics.getFansNum();
                attentionNum = statistics.getAttentionNum();
            }
            map.put("fansNum", fansNum);
            map.put("attentionNum", attentionNum);
        } else { //当前用户的粉丝情况、当前用户是否关注
            AttentionStatistics statistics = getAttentionStatisticsRepository().findByUserId(userId);
            Integer fansNum = 0;
            if (statistics != null) {
                fansNum = statistics.getFansNum();
            }
            //检测是否关注过当前用户
            Boolean attentionStatus = attentionService.attentionStatus(user.getId(), userId);
            map.put("fansNum", fansNum);
            map.put("attentionStatus", attentionStatus);
        }
        return JsonUtil.getSuccess(CommonContact.FETCH_SUCCESS, CommonContact.FETCH_SUCCESS, map);
    }

    /**
     * 获取用户的粉丝数量
     *
     * @param userIds 需要获取的用户IDs
     * @return Map 用户ID作为 key  粉丝数量  value
     */
    public Map<Long, Integer> getFansMapByUserIds(Set<Long> userIds) {
        List<AttentionStatistics> attentionStatisticsList = getAttentionStatisticsRepository().findInUserId(userIds);
        Map<Long, Integer> map = Maps.newHashMap();
        if (attentionStatisticsList != null) {
            attentionStatisticsList.forEach(x -> map.put(x.getUserId(), x.getFansNum()));
        }
        return map;
    }

    private void modify(AttentionStatistics m) {
        if (m.getAttentionNum() < 0) {
            m.setAttentionNum(0);
        }
        if (m.getFansNum() < 0) {
            m.setFansNum(0);
        }
    }

}
