package cn.arvix.ontheway.business.service;

import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.ontheway.business.entity.CollectionRecords;
import cn.arvix.ontheway.business.repository.CollectionRecordsRepository;
import com.google.common.collect.Maps;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

/**
 * @author Created by yangyang on 2017/8/30.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@Service
public class CollectionRecordsService extends BaseServiceImpl<CollectionRecords, Long> {

    private CollectionRecordsRepository getCollectionRecordsRepository() {
        return (CollectionRecordsRepository) baseRepository;
    }

    /**
     * 通过userId 和 商家Id 判断用户是否收藏
     *
     * @param userId     用户ID
     * @param businessId 商家ID
     * @return count
     */
    public Long countByUserIdAndBusinessId(Long userId, Long businessId) {
        Map<String, Object> params = Maps.newHashMap();
        params.put("userId_eq", userId);
        params.put("businessId_eq", businessId);
        return super.count(Searchable.newSearchable(params));
    }


    /**
     * 创建收藏记录通过 用户ID 和 商家ID
     *
     * @param userId     用户ID
     * @param businessId 商家ID
     */
    @Transactional(rollbackFor = Exception.class)
    public void createByUserIdAndBusinessId(Long userId, Long businessId) {
        CollectionRecords collectionRecords = CollectionRecords.getInstance(userId, businessId);
        super.save(collectionRecords);
    }

    /**
     * 删除收藏记录通过  用户ID 和 商户ID
     *
     * @param userId     用户ID
     * @param businessId 商家ID
     */
    public void deleteByUserIdAndBusinessId(Long userId, Long businessId) {
        getCollectionRecordsRepository().deleteByUserIdAndBusinessId(userId, businessId);
    }
}
