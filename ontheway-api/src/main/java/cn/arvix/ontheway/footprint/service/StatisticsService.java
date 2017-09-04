package cn.arvix.ontheway.footprint.service;

import cn.arvix.base.common.entity.SystemModule;
import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.ontheway.footprint.entity.Statistics;
import cn.arvix.ontheway.footprint.repository.StatisticsRepository;
import com.google.common.collect.Maps;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @author Created by yangyang on 2017/7/26.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class StatisticsService extends BaseServiceImpl<Statistics, Long> {

    private StatisticsRepository getStatisticsRepository() {
        return (StatisticsRepository) baseRepository;
    }

    /**
     * 更新统计记录
     *
     * @param instanceId   实体ID
     * @param value        统计值
     * @param systemModule 模块
     * @return 操作结果
     */
    public int updateByInstanceId(Long instanceId, int value, SystemModule systemModule) {
        return getStatisticsRepository().updateLikeNumByInstanceId(value, instanceId, systemModule);
    }

    /**
     * 更新评论统计记录
     *
     * @param instanceId   实体ID
     * @param value        统计值
     * @param systemModule 模块
     * @return 操作结果
     */
    public int updateCommentNumByInstanceId(Long instanceId, int value, SystemModule systemModule) {
        return getStatisticsRepository().updateCommentNumByInstanceId(value, instanceId, systemModule);
    }

    /**
     * 删除统计数据
     * 根据instanceIds
     *
     * @param instanceIds  实例id数组
     * @param systemModule 系统模块
     */
    public void deleteByInstanceIds(List<Long> instanceIds, SystemModule systemModule) {
        getStatisticsRepository().deleteInInstanceId(instanceIds, systemModule);
    }

    /**
     * 获取足迹统计数据，并放入Map key = footprintId
     *
     * @param footprintIds 足迹ID
     * @return 足迹统计数据Map
     */
    public Map<Long, Statistics> findByFootprintIds(Set<Long> footprintIds) {
        Map<String, Object> params = Maps.newHashMap();
        params.put("instanceId_in", footprintIds);
        params.put("systemModule_eq", SystemModule.footprint);
        List<Statistics> statisticsList = super.findAllWithNoPageNoSort(Searchable.newSearchable(params));
        Map<Long, Statistics> statisticsMap = Maps.newHashMap();
        statisticsList.forEach(x -> statisticsMap.put(x.getInstanceId(), x));
        return statisticsMap;
    }

}
