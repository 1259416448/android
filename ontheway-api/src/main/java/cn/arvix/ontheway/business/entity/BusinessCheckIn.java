package cn.arvix.ontheway.business.entity;

import cn.arvix.base.common.entity.BaseEntity;

import javax.persistence.Entity;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;

/**
 * 用户商家签到
 *
 * @author Created by yangyang on 2017/10/25.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Entity
@Table(name = "otw_business_check_in")
public class BusinessCheckIn extends BaseEntity<Long> {

    @NotNull(message = "businessId is not null")
    private Long businessId;

    @NotNull(message = "userId is not null")
    private Long userId;

    public Long getBusinessId() {
        return businessId;
    }

    public void setBusinessId(Long businessId) {
        this.businessId = businessId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }
}
