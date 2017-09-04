package cn.arvix.ontheway.business.dto;

import cn.arvix.ontheway.footprint.dto.FootprintDetailDTO;

import java.util.List;
import java.util.Set;

/**
 * @author Created by yangyang on 2017/8/30.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class BusinessDetailDTO {

    private Long id;

    private String name;

    private String address;

    private Double latitude;

    private Double longitude;

    private String contactInfo;

    /**
     * 商家图片，这里最多存在3张
     */
    private List<String> photoUrls;

    private String colorCode;

    private Float weight = 0f;

    //类型ID
    private Set<Long> typeIds;

    /**
     * 是否收藏
     */
    private Boolean ifLike;

    /**
     * 是否签到
     */
    private Boolean ifCheckIn;

    //总收藏数
    private Integer collectionNum = 0;

    //总评论数
    private Integer commentNum = 0;

    //商家上传的照片总数
    private Integer businessPhotoNum = 0;

    //用户总图片数
    private Integer userPhotoNum = 0;

    private Long currentTime;

    /**
     * 足迹，默认抓取10条
     */
    private List<FootprintDetailDTO> footprints;

    public static BusinessDetailDTO getInstance(){
        return new BusinessDetailDTO();
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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

    public List<String> getPhotoUrls() {
        return photoUrls;
    }

    public void setPhotoUrls(List<String> photoUrls) {
        this.photoUrls = photoUrls;
    }

    public Boolean getIfLike() {
        return ifLike;
    }

    public void setIfLike(Boolean ifLike) {
        this.ifLike = ifLike;
    }

    public Boolean getIfCheckIn() {
        return ifCheckIn;
    }

    public void setIfCheckIn(Boolean ifCheckIn) {
        this.ifCheckIn = ifCheckIn;
    }

    public List<FootprintDetailDTO> getFootprints() {
        return footprints;
    }

    public void setFootprints(List<FootprintDetailDTO> footprints) {
        this.footprints = footprints;
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

    public String getColorCode() {
        return colorCode;
    }

    public void setColorCode(String colorCode) {
        this.colorCode = colorCode;
    }

    public Float getWeight() {
        return weight;
    }

    public void setWeight(Float weight) {
        this.weight = weight;
    }

    public Set<Long> getTypeIds() {
        return typeIds;
    }

    public void setTypeIds(Set<Long> typeIds) {
        this.typeIds = typeIds;
    }

    public Integer getCollectionNum() {
        return collectionNum;
    }

    public void setCollectionNum(Integer collectionNum) {
        this.collectionNum = collectionNum;
    }

    public Integer getCommentNum() {
        return commentNum;
    }

    public void setCommentNum(Integer commentNum) {
        this.commentNum = commentNum;
    }

    public Integer getBusinessPhotoNum() {
        return businessPhotoNum;
    }

    public void setBusinessPhotoNum(Integer businessPhotoNum) {
        this.businessPhotoNum = businessPhotoNum;
    }

    public Integer getUserPhotoNum() {
        return userPhotoNum;
    }

    public void setUserPhotoNum(Integer userPhotoNum) {
        this.userPhotoNum = userPhotoNum;
    }

    public Long getCurrentTime() {
        return currentTime;
    }

    public void setCurrentTime(Long currentTime) {
        this.currentTime = currentTime;
    }
}
