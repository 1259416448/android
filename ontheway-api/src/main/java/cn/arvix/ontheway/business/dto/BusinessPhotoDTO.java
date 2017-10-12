package cn.arvix.ontheway.business.dto;

/**
 * @author Created by yangyang on 2017/10/12.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class BusinessPhotoDTO {

    private Long userId; //用户ID

    private String userNickname; //用户昵称

    private String photoUrl; //照片路径

    private Long dateCreated; //发布时间戳

    private String dateCreatedStr; //发布时间

    private Long photoId; //照片ID

    public static BusinessPhotoDTO getInstance() {
        return new BusinessPhotoDTO();
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getUserNickname() {
        return userNickname;
    }

    public void setUserNickname(String userNickname) {
        this.userNickname = userNickname;
    }

    public String getPhotoUrl() {
        return photoUrl;
    }

    public void setPhotoUrl(String photoUrl) {
        this.photoUrl = photoUrl;
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

    public Long getPhotoId() {
        return photoId;
    }

    public void setPhotoId(Long photoId) {
        this.photoId = photoId;
    }
}
