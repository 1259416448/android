package cn.arvix.ontheway.attention.repository;

import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.ontheway.attention.entity.AttentionStatistics;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Set;

/**
 * @author Created by yangyang on 2017/10/25.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface AttentionStatisticsRepository extends BaseRepository<AttentionStatistics, Long> {

    AttentionStatistics findByUserId(Long userId);

    @Query("from AttentionStatistics where userId in (?1)")
    List<AttentionStatistics> findInUserId(Set<Long> userIds);

}
