package cn.arvix.ontheway.footprint.dto;

import cn.arvix.ontheway.footprint.entity.Footprint;

import java.io.Serializable;

/**
 * @author Created by yangyang on 2017/7/28.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class FootprintSearchListDTO implements Serializable {

    private Long userId;

    private String userHeadImg;

    private String userNickname;

    private String footprintContent;

    private String footprintAddress;

    private Long dateCreated;

    private String dataCreatedStr;

    private String footprintPhoto;

    private Long footprintId;

    private Footprint.FootprintType footprintType;

    private Double distance;

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getUserHeadImg() {
        return userHeadImg;
    }

    public void setUserHeadImg(String userHeadImg) {
        this.userHeadImg = userHeadImg;
    }

    public String getUserNickname() {
        return userNickname;
    }

    public void setUserNickname(String userNickname) {
        this.userNickname = userNickname;
    }

    public String getFootprintContent() {
        return footprintContent;
    }

    public void setFootprintContent(String footprintContent) {
        this.footprintContent = footprintContent;
    }

    public String getFootprintAddress() {
        return footprintAddress;
    }

    public void setFootprintAddress(String footprintAddress) {
        this.footprintAddress = footprintAddress;
    }

    public Long getDateCreated() {
        return dateCreated;
    }

    public void setDateCreated(Long dateCreated) {
        this.dateCreated = dateCreated;
    }

    public String getDataCreatedStr() {
        return dataCreatedStr;
    }

    public void setDataCreatedStr(String dataCreatedStr) {
        this.dataCreatedStr = dataCreatedStr;
    }

    public String getFootprintPhoto() {
        return footprintPhoto;
    }

    public void setFootprintPhoto(String footprintPhoto) {
        this.footprintPhoto = footprintPhoto;
    }

    public Long getFootprintId() {
        return footprintId;
    }

    public void setFootprintId(Long footprintId) {
        this.footprintId = footprintId;
    }

    public Footprint.FootprintType getFootprintType() {
        return footprintType;
    }

    public void setFootprintType(Footprint.FootprintType footprintType) {
        this.footprintType = footprintType;
    }

    public Double getDistance() {
        return distance;
    }

    public void setDistance(Double distance) {
        this.distance = distance;
    }
}
