package arvix.cn.ontheway.bean;

import java.io.Serializable;
import java.util.List;

/**
 * Created by asdtiang on 2017/7/25 0025.
 * asdtiangxia@163.com
 */

public class FootPrintBean implements Serializable{

    private long dateCreated;
    private String dateCreatedStr;
    private float distance;
    private long footprintId;
    private int month;
    private int day;
    private List<String> footprintPhotoArray;
    private List<CommentBean> comments;
    private String footprintAddress;
    private String footprintContent;
    private String userHeadImg;
    private String footprintPhoto;
    private String userNickname;
    private double latitude;
    private double longitude;
    private long userId;
    private boolean ifLike;

    public boolean isIfLike() {
        return ifLike;
    }

    public void setIfLike(boolean ifLike) {
        this.ifLike = ifLike;
    }

    public long getDateCreated() {
        return dateCreated;
    }

    public void setDateCreated(long dateCreated) {
        this.dateCreated = dateCreated;
    }

    public long getFootprintId() {
        return footprintId;
    }

    public void setFootprintId(long footprintId) {
        this.footprintId = footprintId;
    }

    public List<String> getFootprintPhotoArray() {
        return footprintPhotoArray;
    }

    public void setFootprintPhotoArray(List<String> footprintPhotoArray) {
        this.footprintPhotoArray = footprintPhotoArray;
    }

    public String getFootprintAddress() {
        return footprintAddress;
    }

    public void setFootprintAddress(String footprintAddress) {
        this.footprintAddress = footprintAddress;
    }

    public String getFootprintContent() {
        return footprintContent;
    }

    public void setFootprintContent(String footprintContent) {
        this.footprintContent = footprintContent;
    }

    public int getMonth() {
        return month;
    }

    public void setMonth(int month) {
        this.month = month;
    }

    public int getDay() {
        return day;
    }

    public void setDay(int day) {
        this.day = day;
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

    public String getDateCreatedStr() {
        return dateCreatedStr;
    }

    public void setDateCreatedStr(String dateCreatedStr) {
        this.dateCreatedStr = dateCreatedStr;
    }

    public float getDistance() {
        return distance;
    }

    public void setDistance(float distance) {
        this.distance = distance;
    }

    public String getFootprintPhoto() {
        return footprintPhoto;
    }

    public void setFootprintPhoto(String footprintPhoto) {
        this.footprintPhoto = footprintPhoto;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public List<CommentBean> getComments() {
        return comments;
    }

    public void setComments(List<CommentBean> comments) {
        this.comments = comments;
    }
}
