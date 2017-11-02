package cn.arvix.ontheway.business.entity;

import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.base.common.utils.HibernateValidationUtil;
import cn.arvix.ontheway.sys.user.entity.User;
import io.swagger.annotations.ApiModelProperty;
import org.hibernate.validator.constraints.Length;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;

/**
 * @author Created by yangyang on 2017/8/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Table(name = "otw_business_expand")
@Entity
public class BusinessExpand extends BaseEntity<Long> {

    //认领的用户
    @ManyToOne(fetch = FetchType.LAZY)
    @NotNull(message = "user is not null")
    @ApiModelProperty(hidden = true)
    private User user;

    //用户姓名
    @NotNull(message = "name is not null")
    @Length(min = 1, max = 64, message = "1 <= name <= 64 ")
    private String name;

    //手机号码
    @NotNull(message = "mobilePhoneNumber is not null")
    @Length(min = 1, max = 32, message = "1 <= mobilePhoneNumber <= 32 ")
    private String mobilePhoneNumber;

    //证件类型
    @NotNull(message = "certificateType is not null")
    private CertificateType certificateType;

    //证件号码
    @NotNull(message = "certificateNumber is not null")
    @Length(min = 1, max = 32, message = "1 <= certificateNumber <= 32 ")
    private String certificateNumber;

    //组织机构代码
    @NotNull(message = "organizationNumber is not null")
    @Length(min = 1, max = 32, message = "1 <= organizationNumber <= 32 ")
    private String organizationNumber;

    //手持身份证正面照片
    @NotNull(message = "certificatePhoto is not null")
    @Length(min = 1, max = 255, message = "1 <= certificatePhoto <= 255 ")
    @ApiModelProperty(hidden = true)
    private String certificatePhoto;

    //手持营业执照照片
    @Length(min = 1, max = 255, message = "1 <= businessLicensePhoto <= 255 ")
    @NotNull(message = "businessLicensePhoto is not null")
    @ApiModelProperty(hidden = true)
    private String businessLicensePhoto;

    //认领状态
    @NotNull(message = "status is not null")
    @ApiModelProperty(hidden = true)
    private ClaimStatus status = ClaimStatus.submit;

    /**
     * 认领状态
     */
    public enum ClaimStatus {
        none,
        submit, //提交
        approved, //通过
        notApproved //不通过审核
    }

    /**
     * 证件类型enum
     */
    public enum CertificateType {
        idCard //身份证
    }

    /**
     * checkLack
     */
    public String checkLack() {
        StringBuilder builder = HibernateValidationUtil.validateModel(this);
        return builder.toString();
    }

    public ClaimStatus getStatus() {
        return status;
    }

    public void setStatus(ClaimStatus status) {
        this.status = status;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getMobilePhoneNumber() {
        return mobilePhoneNumber;
    }

    public void setMobilePhoneNumber(String mobilePhoneNumber) {
        this.mobilePhoneNumber = mobilePhoneNumber;
    }

    public CertificateType getCertificateType() {
        return certificateType;
    }

    public void setCertificateType(CertificateType certificateType) {
        this.certificateType = certificateType;
    }

    public String getCertificateNumber() {
        return certificateNumber;
    }

    public void setCertificateNumber(String certificateNumber) {
        this.certificateNumber = certificateNumber;
    }

    public String getOrganizationNumber() {
        return organizationNumber;
    }

    public void setOrganizationNumber(String organizationNumber) {
        this.organizationNumber = organizationNumber;
    }

    public String getCertificatePhoto() {
        return certificatePhoto;
    }

    public void setCertificatePhoto(String certificatePhoto) {
        this.certificatePhoto = certificatePhoto;
    }

    public String getBusinessLicensePhoto() {
        return businessLicensePhoto;
    }

    public void setBusinessLicensePhoto(String businessLicensePhoto) {
        this.businessLicensePhoto = businessLicensePhoto;
    }
}
