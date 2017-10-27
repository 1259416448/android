package cn.arvix.ontheway.business.service;

import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.ontheway.business.entity.BusinessExpand;
import cn.arvix.ontheway.business.repository.BusinessExpandRepository;
import org.springframework.stereotype.Service;

/**
 * @author Created by yangyang on 2017/8/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class BusinessExpandService extends BaseServiceImpl<BusinessExpand, Long> {

    private BusinessExpandRepository getBusinessExpandRepository() {
        return (BusinessExpandRepository) baseRepository;
    }

    /**
     * 获取某个用户 某个状态 的认领 申请 数量
     *
     * @param userId      用户ID
     * @param claimStatus 需要查询的认领状态
     * @return 数量
     */
    public int countByUserIdAndStatus(Long userId, BusinessExpand.ClaimStatus claimStatus) {
        return getBusinessExpandRepository().countByUserIdAndStatus(userId, claimStatus);
    }

}
