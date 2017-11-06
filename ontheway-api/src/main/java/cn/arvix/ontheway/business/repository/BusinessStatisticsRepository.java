package cn.arvix.ontheway.business.repository;

import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.ontheway.business.entity.BusinessStatistics;

/**
 * @author Created by yangyang on 2017/8/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface BusinessStatisticsRepository extends BaseRepository<BusinessStatistics, Long> {

    /**
     * 通过 businessId 获取当前Business的统计对象，肯定只会存在一个
     * @param businessId 商家ID
     * @return BusinessStatistics 数据
     */
    BusinessStatistics findByBusinessId(Long businessId);

}
