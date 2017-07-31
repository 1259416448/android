package cn.arvix.ontheway.footprint.repository;

import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.ontheway.footprint.entity.LikeRecords;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

/**
 * @author Created by yangyang on 2017/7/28.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface LikeRecordsRepository extends BaseRepository<LikeRecords,Long> {

    int deleteByUserIdAndFootprintId(Long userId,Long footprintId);

    @Modifying
    @Query("delete from LikeRecords where footprintId in (?1)")
    int deleteInFootprintId(List footprintIds);

}
