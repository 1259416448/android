package cn.arvix.ontheway.sys.user.entity;

import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.base.common.plugin.entity.LogicDeleteable;
import cn.arvix.base.common.repository.support.annotation.EnableQueryCache;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.HibernateValidationUtil;
import cn.arvix.base.common.utils.SpringUtils;
import cn.arvix.base.common.utils.TimeMaker;
import cn.arvix.qiniu.utils.QiniuDownloadUtil;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import io.swagger.annotations.ApiModelProperty;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;
import org.hibernate.validator.constraints.Length;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * @author Created by yangyang on 2017/3/8.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */


@Entity
@Table(name = "sys_user")
@EnableQueryCache
@org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class User extends BaseEntity<Long> implements LogicDeleteable {

    public static final String EMAIL_PATTERN = "^((([a-z]|\\d|[!#\\$%&'\\*\\+\\-\\/=\\?\\^_`{\\|}~]|[\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF])+(\\.([a-z]|\\d|[!#\\$%&'\\*\\+\\-\\/=\\?\\^_`{\\|}~]|[\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF])+)*)|((\\x22)((((\\x20|\\x09)*(\\x0d\\x0a))?(\\x20|\\x09)+)?(([\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x7f]|\\x21|[\\x23-\\x5b]|[\\x5d-\\x7e]|[\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF])|(\\\\([\\x01-\\x09\\x0b\\x0c\\x0d-\\x7f]|[\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF]))))*(((\\x20|\\x09)*(\\x0d\\x0a))?(\\x20|\\x09)+)?(\\x22)))@((([a-z]|\\d|[\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF])|(([a-z]|\\d|[\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF])([a-z]|\\d|-|\\.|_|~|[\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF])*([a-z]|\\d|[\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF])))\\.)+(([a-z]|[\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF])|(([a-z]|[\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF])([a-z]|\\d|-|\\.|_|~|[\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF])*([a-z]|[\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF])))\\.?";
    public static final String MOBILE_PHONE_NUMBER_PATTERN = "^0{0,1}(13[0-9]|15[0-9]|14[0-9]|17[0-9]|18[0-9])[0-9]{8}$";
    public static final int PASSWORD_MIN_LENGTH = 5;
    public static final int PASSWORD_MAX_LENGTH = 50;
    public static final String TABLE_NAME = "sys_user";

    @NotNull(message = "username is not null")
    private String username;

    //@NotEmpty(message = "email is not null")
    @Pattern(regexp = EMAIL_PATTERN, message = "email is error")
    private String email;

    //@NotEmpty(message = "mobilePhoneNumber is not null")
    @Pattern(regexp = MOBILE_PHONE_NUMBER_PATTERN, message = "mobilePhoneNumber is error")
    @Column
    private String mobilePhoneNumber;

    @Length(min = PASSWORD_MIN_LENGTH, max = PASSWORD_MAX_LENGTH, message = "{user.password.not.valid}")
    private String password;

    private String headImg;

    //头像原图名称
    private String headImgYuan;

    private String name;

    //职位
    private String job;
    /**
     * 加密密码时使用的种子
     */
    private String salt;

    @Enumerated(EnumType.STRING)
    private UserStatus status;

    @Enumerated(EnumType.STRING)
    private UserType userType;

    @Enumerated(EnumType.STRING)
    private UserGender gender = UserGender.secrecy;


    public enum UserGender {
        secrecy, man, woman
    }

    /**
     * 用户 组织机构 工作职务关联表
     */
    @OneToMany(fetch = FetchType.EAGER, mappedBy = "user")
    @org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)//集合缓存
    @ApiModelProperty(hidden = true)
    //@NotFound(action = NotFoundAction.IGNORE)
    @Fetch(FetchMode.SELECT)
    private Set<UserOrganizationJob> organizationJobs = Sets.newHashSet();

    public String tableName() {
        return TABLE_NAME;
    }

    @ApiModelProperty(hidden = true)
    private transient Map<String, Object> objectMap;

    public Map<String, Object> getObjectMap() {
        if (objectMap == null) {
            objectMap = Maps.newHashMap();
        }
        return objectMap;
    }

    public void setObjectMap(Map<String, Object> objectMap) {
        this.objectMap = objectMap;
    }


    /**
     * checkLack
     */
    public String checkLack() {
        StringBuilder builder = HibernateValidationUtil.validateModel(this);
        return builder.toString();
    }

    @Transient
    public Map<String, Object> toMap() {
        objectMap = Maps.newHashMap();
        objectMap.put("id", getId());
        objectMap.put("username", username);
        objectMap.put("email", email);
        objectMap.put("mobilePhoneNumber", mobilePhoneNumber);
        objectMap.put("headImg", getReallyHeadImg());
        objectMap.put("headImgYuan", getReallyHeadImgYuan());
        objectMap.put("headImgYuan_", headImgYuan);
        objectMap.put("name", name);
        objectMap.put("status", status);
        objectMap.put("gender", gender);
        objectMap.put("creater", getCreater());
        objectMap.put("deleted", deleted);
        objectMap.put("dateCreated", TimeMaker.toDateTimeStr(getDateCreated()));
        objectMap.put("lastUpdated", TimeMaker.toDateTimeStr(getLastUpdated()));
        List<Map> list = Lists.newArrayList();
        if (organizationJobs != null) {
            getOrganizationJobs().forEach(x -> {
                if (x != null) {
                    list.add(x.toMap());
                }
            });
            objectMap.put("organizationJobs", list);
        }
        return objectMap;
    }

    @Transient
    public Map<String, Object> toSimpleMap() {
        Map<String, Object> jsonMap = Maps.newHashMap();
        jsonMap.put("id", getId());
        jsonMap.put("username", username);
        jsonMap.put("name", getName());
        jsonMap.put("mobilePhoneNumber", getMobilePhoneNumber());
        jsonMap.put("headImg", getReallyHeadImg());
        jsonMap.put("headImgYuan", getReallyHeadImgYuan());
        jsonMap.put("gender", gender);
        return jsonMap;
    }

    /**
     * 逻辑删除flag
     */
    private Boolean deleted = Boolean.FALSE;

    public Set<Long> getOrganizationIds() {
        Set<Long> set = Sets.newHashSet();
        if (organizationJobs != null) {
            getOrganizationJobs().forEach(x -> set.add(x.getOrganization().getId()));
        }
        return set;
    }

    public UserGender getGender() {
        return gender;
    }

    public void setGender(UserGender gender) {
        this.gender = gender;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getHeadImg() {
        return headImg;
    }

    //这里要处理一下用户图片，图片时私有文件夹
    public String getReallyHeadImg() {
        if (!StringUtils.isEmpty(headImg)) {
            QiniuDownloadUtil qiniuDownloadUtil = SpringUtils.getBean(QiniuDownloadUtil.class);
            //这里用户头像有效时间设置长一些
            return qiniuDownloadUtil.
                    getDownloadTokenAuto(headImg + (headImg.contains("?") ? "|" : "?") + CommonContact.USER_HEAD_IMG_FIX, 360000);
        }
        return headImg;
    }

    //获取头像原图的访问路径
    public String getReallyHeadImgYuan() {
        if (!StringUtils.isEmpty(headImgYuan)) {
            QiniuDownloadUtil qiniuDownloadUtil = SpringUtils.getBean(QiniuDownloadUtil.class);
            //这里用户头像有效时间设置长一些
            return qiniuDownloadUtil.
                    getDownloadTokenAuto(headImgYuan, 360000);
        }
        return headImgYuan;
    }

    //获取头像原图的访问路径
    public String getHeadImgYuan() {
        return headImgYuan;
    }

    public void setHeadImgYuan(String headImgYuan) {
        this.headImgYuan = headImgYuan;
    }

    public void setHeadImg(String headImg) {
        this.headImg = headImg;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMobilePhoneNumber() {
        return mobilePhoneNumber;
    }

    public void setMobilePhoneNumber(String mobilePhoneNumber) {
        this.mobilePhoneNumber = mobilePhoneNumber;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getSalt() {
        return salt;
    }

    public void setSalt(String salt) {
        this.salt = salt;
    }

    public UserStatus getStatus() {
        return status;
    }

    public void setStatus(UserStatus status) {
        this.status = status;
    }

    @Override
    public Boolean getDeleted() {
        return deleted;
    }

    @Override
    public void setDeleted(Boolean deleted) {
        this.deleted = deleted;
    }

    @Override
    public void markDeleted() {
        this.deleted = Boolean.TRUE;
    }

    public Set<UserOrganizationJob> getOrganizationJobs() {
        return organizationJobs;
    }

    public void setOrganizationJobs(Set<UserOrganizationJob> organizationJobs) {
        this.organizationJobs = organizationJobs;
    }

    public UserType getUserType() {
        return userType;
    }

    public void setUserType(UserType userType) {
        this.userType = userType;
    }

    public String getJob() {
        return job;
    }

    public void setJob(String job) {
        this.job = job;
    }
}
