package cn.arvix.ontheway.footprint.service;

import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.ontheway.footprint.entity.LikeRecords;
import cn.arvix.ontheway.footprint.repository.LikeRecordsRepository;
import com.google.common.collect.Maps;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @author Created by yangyang on 2017/7/28.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@Service
public class LikeRecordsService extends BaseServiceImpl<LikeRecords,Long> {

    private LikeRecordsRepository getLikeRecordsRepository(){
        return (LikeRecordsRepository) baseRepository;
    }

    /**
     * 通过userId 和 footprintId 查询是否已经点赞
     * @param userId 用户ID
     * @param footprintId 足迹ID
     * @return 0 表示未点赞
     */
    public Long countByUserIdAndFootprintId(Long userId,Long footprintId){
        Map<String,Object> params = Maps.newHashMap();
        params.put("userId_eq",userId);
        params.put("footprint_eq",footprintId);
        return super.count(Searchable.newSearchable(params));
    }

    /**
     * 通过用户ID和足迹ID删除点赞记录
     * @param userId 用户ID
     * @param footprintId 足迹ID
     * @return 删除结果
     */
    public int deleteByUserIdAndFootprintId(Long userId,Long footprintId){
        return getLikeRecordsRepository().deleteByUserIdAndFootprintId(userId,footprintId);
    }

    /**
     * 创建点赞记录
     * @param userId 用户ID
     * @param footprintId 足迹ID
     */
    public void createByUserIdAndFootprintId(Long userId,Long footprintId){
        LikeRecords records = new LikeRecords();
        records.setUserId(userId);
        records.setFootprintId(footprintId);
        super.save(records);
    }

    /**
     * 通过足迹IDs删除点赞记录
     * @param footprintIds 点赞记录
     */
    public void deleteByFootprintIds(List<Long> footprintIds){
        getLikeRecordsRepository().deleteInFootprintId(footprintIds);
    }

}
