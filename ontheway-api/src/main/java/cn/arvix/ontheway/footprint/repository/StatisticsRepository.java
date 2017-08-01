package cn.arvix.ontheway.footprint.repository;

import cn.arvix.base.common.entity.SystemModule;
import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.ontheway.footprint.entity.Statistics;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

/**
 * @author Created by yangyang on 2017/7/26.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface StatisticsRepository extends BaseRepository<Statistics, Long> {

    @Modifying
    @Query("update Statistics set likeNum = likeNum + ?1 where instanceId = ?2 and systemModule = ?3")
    int updateLikeNumByInstanceId(int value, Long instanceId, SystemModule systemModule);

    @Modifying
    @Query("update Statistics set commentNum = commentNum + ?1 where instanceId = ?2 and systemModule = ?3")
    int updateCommentNumByInstanceId(int value, Long instanceId, SystemModule systemModule);

    @Modifying
    @Query("delete Statistics where instanceId in (?1) and systemModule = ?2")
    int deleteInInstanceId(List instanceIds, SystemModule systemModule);

}
