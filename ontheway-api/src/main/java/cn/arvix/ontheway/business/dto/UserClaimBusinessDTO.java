package cn.arvix.ontheway.business.dto;

import cn.arvix.base.common.utils.TimeMaker;

import java.util.Date;

/**
 * @author Created by yangyang on 2017/10/31.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class UserClaimBusinessDTO {

    private Long businessId;

    private String name; //商家名称

    private String address; //商家地址

    private String contactInfo; //商家联系方式

    private String claimDateStr; //认领时间

    private String photoUrl; //商家封面照片

    private Date claimDate;

    public UserClaimBusinessDTO() {
    }

    public UserClaimBusinessDTO(Long businessId, String name, String address,
                                String contactInfo, Date claimDate) {
        this.businessId = businessId;
        this.name = name;
        this.address = address;
        this.contactInfo = contactInfo;
        this.claimDate = claimDate;
        this.claimDateStr = TimeMaker.toDateStr(claimDate);
    }

    public Long getBusinessId() {
        return businessId;
    }

    public void setBusinessId(Long businessId) {
        this.businessId = businessId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getContactInfo() {
        return contactInfo;
    }

    public void setContactInfo(String contactInfo) {
        this.contactInfo = contactInfo;
    }

    public String getClaimDateStr() {
        return claimDateStr;
    }

    public void setClaimDateStr(String claimDateStr) {
        this.claimDateStr = claimDateStr;
    }

    public String getPhotoUrl() {
        return photoUrl;
    }

    public void setPhotoUrl(String photoUrl) {
        this.photoUrl = photoUrl;
    }

    public Date getClaimDate() {
        return claimDate;
    }

    public void setClaimDate(Date claimDate) {
        this.claimDate = claimDate;
    }
}
