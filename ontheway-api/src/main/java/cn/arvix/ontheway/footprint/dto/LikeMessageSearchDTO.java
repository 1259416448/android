package cn.arvix.ontheway.footprint.dto;

/**
 * @author Created by yangyang on 2017/8/14.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class LikeMessageSearchDTO {

    private Long userId;

    private String userNickname;

    private String userHeadImg;

    private String footprintContent;

    private Long footprintId;

    private Long dateCreated;

    private String dateCreatedStr;

    public static LikeMessageSearchDTO getInstance(){
        return new LikeMessageSearchDTO();
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

    public String getUserHeadImg() {
        return userHeadImg;
    }

    public void setUserHeadImg(String userHeadImg) {
        this.userHeadImg = userHeadImg;
    }

    public String getFootprintContent() {
        return footprintContent;
    }

    public void setFootprintContent(String footprintContent) {
        this.footprintContent = footprintContent;
    }

    public Long getFootprintId() {
        return footprintId;
    }

    public void setFootprintId(Long footprintId) {
        this.footprintId = footprintId;
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
}
