package cn.arvix.ontheway.business.repository;

import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.ontheway.business.entity.BusinessCheckIn;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

/**
 * @author Created by yangyang on 2017/10/25.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface BusinessCheckInRepository extends BaseRepository<BusinessCheckIn, Long> {

    @Query("select count(*) from BusinessCheckIn where userId = ?1 and businessId = ?2")
    int countUserIdAndBusinessId(Long userId, Long businessId);

    @Query("delete BusinessCheckIn where userId = ?1 and businessId = ?2")
    @Modifying
    int deleteUserIdAndBusinessId(Long userId, Long businessId);

}
