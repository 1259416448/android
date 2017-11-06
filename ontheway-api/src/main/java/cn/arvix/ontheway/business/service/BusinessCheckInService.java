package cn.arvix.ontheway.business.service;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.ontheway.business.entity.BusinessCheckIn;
import cn.arvix.ontheway.business.repository.BusinessCheckInRepository;
import cn.arvix.ontheway.sys.user.entity.User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author Created by yangyang on 2017/10/25.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class BusinessCheckInService extends BaseServiceImpl<BusinessCheckIn, Long> {

    private BusinessCheckInRepository getBusinessCheckInRepository() {
        return (BusinessCheckInRepository) baseRepository;
    }

    /**
     * 签到
     *
     * @return 签到结果
     */
    @Transactional
    public JSONResult checkIn(Long businessId) {
        User user = webContextUtils.getCheckCurrentUser();
        if (!checkInStatus(user.getId(), businessId)) {
            BusinessCheckIn businessCheckIn = new BusinessCheckIn();
            businessCheckIn.setUserId(user.getId());
            businessCheckIn.setBusinessId(businessId);
            super.save(businessCheckIn);
        }
        return JsonUtil.getSuccess(CommonContact.OPTION_SUCCESS, CommonContact.OPTION_SUCCESS);
    }

    /**
     * 取消签到
     *
     * @return 取消结果
     */
    @Transactional
    public JSONResult cancel(Long businessId) {
        User user = webContextUtils.getCheckCurrentUser();
        if (checkInStatus(user.getId(), businessId)) {
            getBusinessCheckInRepository().deleteUserIdAndBusinessId(user.getId(), businessId);
        }
        return JsonUtil.getSuccess(CommonContact.OPTION_SUCCESS, CommonContact.OPTION_SUCCESS);
    }

    /**
     * 获取 某个用户 在某个 商家 下的签到情况
     *
     * @param userId     用户ID
     * @param businessId 商家ID
     * @return 签到结果
     */
    public Boolean checkInStatus(Long userId, Long businessId) {
        return getBusinessCheckInRepository().countUserIdAndBusinessId(userId, businessId) != 0;
    }

}
