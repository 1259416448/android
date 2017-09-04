package cn.arvix.ontheway.business.entity;

import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.base.common.utils.HibernateValidationUtil;

import javax.persistence.Entity;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;

/**
 * 商家收藏记录
 *
 * @author Created by yangyang on 2017/8/30.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Entity
@Table(name = "otw_business_collection_records")
public class CollectionRecords extends BaseEntity<Long> {

    //收藏用户ID
    @NotNull(message = "userId is not null")
    private Long userId;

    //收藏商家ID
    @NotNull(message = "businessId is not null")
    private Long businessId;

    public CollectionRecords() {

    }

    public static CollectionRecords getInstance(Long userId, Long businessId){
        return new CollectionRecords(userId,businessId);
    }

    public CollectionRecords(Long userId, Long businessId) {
        this.userId = userId;
        this.businessId = businessId;
    }

    /**
     * checkLack
     */
    public String checkLack() {
        StringBuilder builder = HibernateValidationUtil.validateModel(this);
        return builder.toString();
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getBusinessId() {
        return businessId;
    }

    public void setBusinessId(Long businessId) {
        this.businessId = businessId;
    }
}
