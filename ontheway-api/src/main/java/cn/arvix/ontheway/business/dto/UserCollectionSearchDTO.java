package cn.arvix.ontheway.business.dto;

/**
 * 用户收藏列表 DTO
 *
 * @author Created by yangyang on 2017/10/12.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class UserCollectionSearchDTO {

    private Long businessId; //商家ID

    private String name; //商家名称

    private String address;//商家地址

    private Double latitude;

    private Double longitude;

    private Long dateCreated; //收藏时间戳

    private String dateCreatedStr; //收藏时间

    private Long collectionId; //收藏ID

    public static UserCollectionSearchDTO getInstance() {
        return new UserCollectionSearchDTO();
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

    public Long getDateCreated() {
        return dateCreated;
    }

    public void setDateCreated(Long dateCreated) {
        this.dateCreated = dateCreated;
    }

    public String getDateCreatedStr() {
        return dateCreatedStr;
    }

    public void setDateCreatedStr(String dateCreatedStr) {
        this.dateCreatedStr = dateCreatedStr;
    }

    public Long getCollectionId() {
        return collectionId;
    }

    public void setCollectionId(Long collectionId) {
        this.collectionId = collectionId;
    }
}
