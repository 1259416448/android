package cn.arvix.ontheway.business.repository;

import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.ontheway.business.entity.CollectionRecords;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

/**
 * @author Created by yangyang on 2017/8/30.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface CollectionRecordsRepository extends BaseRepository<CollectionRecords,Long> {

    @Query("delete from CollectionRecords where userId = ?1 and businessId = ?2")
    @Modifying
    int deleteByUserIdAndBusinessId(Long userId,Long businessId);

}
