package cn.arvix.ontheway.business.repository;

import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.ontheway.business.entity.BusinessExpand;
import org.springframework.data.jpa.repository.Query;

/**
 * @author Created by yangyang on 2017/8/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface BusinessExpandRepository extends BaseRepository<BusinessExpand, Long> {

    @Query("select count(*) from BusinessExpand where user.id = ?1 and status = ?2 ")
    int countByUserIdAndStatus(Long userId, BusinessExpand.ClaimStatus status);

}

