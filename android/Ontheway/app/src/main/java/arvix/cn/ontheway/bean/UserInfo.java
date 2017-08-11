package arvix.cn.ontheway.bean;

/**
 * Created by asdtiang on 2017/8/4 0004.
 * asdtiangxia@163.com
 */

public class UserInfo {
    private String name;
    private String mobilePhoneNumber;
    private String headImg;
    private String gender;
    private Long id = 0l ;
    private String headImgYun;
    private String username;

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

    public String getHeadImg() {
        return headImg;
    }

    public void setHeadImg(String headImg) {
        this.headImg = headImg;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getHeadImgYun() {
        return headImgYun;
    }

    public void setHeadImgYun(String headImgYun) {
        this.headImgYun = headImgYun;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }
}
