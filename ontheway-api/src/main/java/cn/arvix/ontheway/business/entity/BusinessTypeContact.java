package cn.arvix.ontheway.business.entity;

import cn.arvix.base.common.entity.BaseEntity;

import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * business - businessType 关系保存
 *
 * @author Created by yangyang on 2017/8/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Table(name = "otw_business_type_contact")
@Entity
public class BusinessTypeContact extends BaseEntity<Long> {

    private Long businessId;

    private Long businessTypeId;

    public BusinessTypeContact() {
    }

    public BusinessTypeContact(Long businessId, Long businessTypeId) {
        this.businessId = businessId;
        this.businessTypeId = businessTypeId;
    }

    public static BusinessTypeContact getInstance(Long businessId, Long businessTypeId) {
        return new BusinessTypeContact(businessId, businessTypeId);
    }

    public static BusinessTypeContact getInstance() {
        return new BusinessTypeContact();
    }

    public Long getBusinessId() {
        return businessId;
    }

    public void setBusinessId(Long businessId) {
        this.businessId = businessId;
    }

    public Long getBusinessTypeId() {
        return businessTypeId;
    }

    public void setBusinessTypeId(Long businessTypeId) {
        this.businessTypeId = businessTypeId;
    }
}
