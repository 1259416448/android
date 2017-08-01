package cn.arvix.ontheway.footprint.dto;

import cn.arvix.ontheway.footprint.entity.Footprint;

import java.io.Serializable;
import java.util.List;

/**
 * App足迹详情模型数据
 * @author Created by yangyang on 2017/7/29.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class FootprintDetailDTO implements Serializable {

    private List<String> footprintPhotoArray;
    private String userHeadImg;
    private String userNickname;
    private Long userId;
    private String footprintContent;
    private String footprintAddress;
    private Long dateCreated;
    private String dateCreatedStr;
    private String footprintPhoto;
    private Long footprintId;
    private Boolean ifLike;
    private Footprint.FootprintType footprintType;
    private Integer footprintCommentNum;
    private Integer footprintLikeNum;
    //商家ID标示
    private Long business;
    private List<CommentDetailDTO> comments;

    public List<String> getFootprintPhotoArray() {
        return footprintPhotoArray;
    }

    public void setFootprintPhotoArray(List<String> footprintPhotoArray) {
        this.footprintPhotoArray = footprintPhotoArray;
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

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
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

    public String getDateCreatedStr() {
        return dateCreatedStr;
    }

    public void setDateCreatedStr(String dateCreatedStr) {
        this.dateCreatedStr = dateCreatedStr;
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

    public Integer getFootprintCommentNum() {
        return footprintCommentNum;
    }

    public void setFootprintCommentNum(Integer footprintCommentNum) {
        this.footprintCommentNum = footprintCommentNum;
    }

    public Integer getFootprintLikeNum() {
        return footprintLikeNum;
    }

    public void setFootprintLikeNum(Integer footprintLikeNum) {
        this.footprintLikeNum = footprintLikeNum;
    }

    public List<CommentDetailDTO> getComments() {
        return comments;
    }

    public void setComments(List<CommentDetailDTO> comments) {
        this.comments = comments;
    }

    public Long getBusiness() {
        return business;
    }

    public void setBusiness(Long business) {
        this.business = business;
    }

    public Boolean getIfLike() {
        return ifLike;
    }

    public void setIfLike(Boolean ifLike) {
        this.ifLike = ifLike;
    }
}
