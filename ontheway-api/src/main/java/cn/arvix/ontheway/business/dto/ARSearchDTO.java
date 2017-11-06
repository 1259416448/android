package cn.arvix.ontheway.business.dto;

import cn.arvix.ontheway.business.entity.BusinessExpand;

/**
 * @author Created by yangyang on 2017/8/29.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class ARSearchDTO {

    private Double distance;

    private String name;

    private String address;

    private Double latitude;

    private Double longitude;

    private String contactInfo;

    private Long businessId;

    private String colorCode;

    private String photoUrl;

    private BusinessExpand.ClaimStatus claimStatus;

    public static ARSearchDTO getInstance() {
        return new ARSearchDTO();
    }

    public Double getDistance() {
        return distance;
    }

    public void setDistance(Double distance) {
        this.distance = distance;
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

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public String getContactInfo() {
        return contactInfo;
    }

    public void setContactInfo(String contactInfo) {
        this.contactInfo = contactInfo;
    }

    public Long getBusinessId() {
        return businessId;
    }

    public void setBusinessId(Long businessId) {
        this.businessId = businessId;
    }

    public String getColorCode() {
        return colorCode;
    }

    public void setColorCode(String colorCode) {
        this.colorCode = colorCode;
    }

    public String getPhotoUrl() {
        return photoUrl;
    }

    public void setPhotoUrl(String photoUrl) {
        this.photoUrl = photoUrl;
    }

    public BusinessExpand.ClaimStatus getClaimStatus() {
        return claimStatus;
    }

    public void setClaimStatus(BusinessExpand.ClaimStatus claimStatus) {
        this.claimStatus = claimStatus;
    }
}
