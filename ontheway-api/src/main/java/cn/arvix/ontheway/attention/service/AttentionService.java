package cn.arvix.ontheway.attention.service;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.entity.PageResult;
import cn.arvix.base.common.entity.search.PageRequest;
import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.ontheway.attention.dto.AttentionSearchDTO;
import cn.arvix.ontheway.attention.entity.Attention;
import cn.arvix.ontheway.attention.repository.AttentionRepository;
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

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

/**
 * @author Created by yangyang on 2017/10/25.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class AttentionService extends BaseServiceImpl<Attention, Long> {

    private AttentionStatisticsService attentionStatisticsService;

    @Autowired
    public void setAttentionStatisticsService(AttentionStatisticsService attentionStatisticsService) {
        this.attentionStatisticsService = attentionStatisticsService;
    }

    private ConfigService configService;

    @Autowired
    public void setConfigService(ConfigService configService) {
        this.configService = configService;
    }

    private FootprintService footprintService;

    @Autowired
    public void setFootprintService(FootprintService footprintService) {
        this.footprintService = footprintService;
    }

    private AttentionRepository getAttentionRepository() {
        return (AttentionRepository) baseRepository;
    }

    /**
     * 关注某个用户
     *
     * @param attentionUserId 关注用户ID
     * @return 操作结果
     */
    @Transactional
    public JSONResult create(Long attentionUserId) {
        Long userId = webContextUtils.getCheckCurrentUser().getId();
        if (Objects.equals(userId, attentionUserId)) {
            return JsonUtil.getFailure("不能关注自己！！！", CommonContact.OPTION_ERROR);
        }
        if (!attentionStatus(userId, attentionUserId)) {
            //添加关注记录，并更新关注统计
            User user = new User();
            User attentionUser = new User();
            user.setId(userId);
            attentionUser.setId(attentionUserId);
            Attention attention = new Attention();
            attention.setUser(user);
            attention.setAttentionUser(attentionUser);
            super.save(attention);
            attentionStatisticsService.changeUserStatistics(userId, attentionUserId, 1);
        }
        return JsonUtil.getSuccess(CommonContact.OPTION_SUCCESS, CommonContact.OPTION_SUCCESS);
    }

    /**
     * 获取用户的关注情况
     * true 关注了   false 未关注
     *
     * @param userId          需要判断的用户ID
     * @param attentionUserId 关注的用户ID
     * @return 关注情况
     */
    public Boolean attentionStatus(Long userId, Long attentionUserId) {
        return getAttentionRepository().countUserAndAttentionUser(userId, attentionUserId) != 0;
    }

    /**
     * 取消对某个用户的关注
     *
     * @param attentionUserId 取关用户ID
     * @return 操作结果
     */
    @Transactional
    public JSONResult cancel(Long attentionUserId) {
        Long userId = webContextUtils.getCheckCurrentUser().getId();
        if (attentionStatus(userId, attentionUserId)) {
            //删除当前关注、并更新统计
            getAttentionRepository().deleteUserAndAttentionUser(userId, attentionUserId);
            attentionStatisticsService.changeUserStatistics(userId, attentionUserId, -1);
        }
        return JsonUtil.getSuccess(CommonContact.OPTION_SUCCESS, CommonContact.OPTION_SUCCESS);
    }


    /**
     * 获取我的 关注 或者 粉丝 列表
     *
     * @param type        列表类型
     * @param number      当前页
     * @param size        每页大小
     * @param currentTime 分页时间
     * @return 分页结果
     */
    public JSONResult search(AttentionType type, int number, int size, Long currentTime) {

        Map<String, Object> params = Maps.newHashMap();

        User user = webContextUtils.getCheckCurrentUser();
        //我的关注
        if (AttentionType.attention.equals(type)) {
            params.put("user.id_eq", user.getId());
        } else { //我的粉丝
            params.put("attentionUser.id_eq", user.getId());
        }
        Searchable searchable = Searchable.newSearchable(params, new PageRequest(number, size),
                new Sort(Sort.Direction.DESC, CommonContact.DATE_CREATED));
        Page<Attention> page = super.findAllWithNoCount(searchable);
        if (page.getContent().size() > 0) {
            //获取我关注的 或者 我的粉丝 粉丝 数量
            Set<Long> userIds = Sets.newHashSet();
            if (AttentionType.attention.equals(type)) {
                page.getContent().forEach(x -> userIds.add(x.getAttentionUser().getId()));
            } else {
                page.getContent().forEach(x -> userIds.add(x.getUser().getId()));
            }
            Map<Long, Integer> map = attentionStatisticsService.getFansMapByUserIds(userIds);

            List<AttentionSearchDTO> content = Lists.newArrayListWithCapacity(page.getContent().size());

            String urlFix = configService.getConfigString(CommonContact.QINIU_BUCKET_URL);

            page.getContent().forEach(x -> {
                AttentionSearchDTO dto = AttentionSearchDTO.getInstance();
                if (AttentionType.attention.equals(type)) {
                    dto.setUserId(x.getAttentionUser().getId());
                    dto.setUserNickname(x.getAttentionUser().getName());
                    dto.setUserHeadImg(urlFix + x.getAttentionUser().getHeadImg());
                    dto.setFansNum(map.get(x.getAttentionUser().getId()));
                } else {
                    dto.setUserId(x.getUser().getId());
                    dto.setUserNickname(x.getUser().getName());
                    dto.setUserHeadImg(urlFix + x.getUser().getHeadImg());
                    dto.setFansNum(map.get(x.getUser().getId()));
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
        return JsonUtil.getSuccess(CommonContact.FETCH_SUCCESS, CommonContact.FETCH_SUCCESS, page);
    }

    /**
     * 获取当前用户 关注 用户的最新足迹动态
     *
     * @param number      当前页
     * @param size        每页大小
     * @param currentTime 获取时间
     * @return page
     */
    public JSONResult footprint(Integer number, Integer size, Long currentTime) {
        User user = webContextUtils.getCheckCurrentUser();
        return JsonUtil.getSuccess(CommonContact.FETCH_SUCCESS, CommonContact.FETCH_SUCCESS,
                footprintService.searchAttentionByUserId(number, size, currentTime, user.getId()));

    }

    public enum AttentionType {
        attention, //关注的
        fans //粉丝
    }

}
