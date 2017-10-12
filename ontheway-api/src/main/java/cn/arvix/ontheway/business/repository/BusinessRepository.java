package cn.arvix.ontheway.business.repository;

import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.ontheway.business.entity.Business;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Set;

/**
 * @author Created by yangyang on 2017/8/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface BusinessRepository extends BaseRepository<Business, Long> {

    /**
     * 根据商家ID获取商家数据
     *
     * @param businessIds 商家ID
     * @return 商家列表
     */
    @Query("from Business where id in (?1)")
    List<Business> findInId(Set<Long> businessIds);
}
