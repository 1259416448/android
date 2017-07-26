package cn.arvix.ontheway.footprint.entity;

import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.base.common.utils.HibernateValidationUtil;
import cn.arvix.ontheway.ducuments.entity.Document;
import cn.arvix.ontheway.sys.user.entity.User;
import io.swagger.annotations.ApiModelProperty;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

/**
 * 足迹实体
 *
 * @author Created by yangyang on 2017/7/26.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@Entity
@Table(name = "otw_footprint")
public class Footprint extends BaseEntity<Long> {

    //发布内容
    @NotNull(message = "content is not null")
    @ApiModelProperty(value = "足迹内容，不能为空，字数现在未做限制")
    private String content;

    //主题图片
    @ManyToOne
    @ApiModelProperty(hidden = true)
    private Document photo;

    //发布用户
    @ManyToOne
    @NotNull(message = "user is not null")
    @ApiModelProperty(hidden = true)
    private User user;

    //定位地址
    @NotNull(message = "address is not null")
    @ApiModelProperty(value = "定位地址")
    private String address;

    //纬度
    @ApiModelProperty(value = "纬度")
    @NotNull(message = "latitude is not null")
    private Double latitude;

    //经度
    @ApiModelProperty(value = "经度")
    @NotNull(message = "longitude is not null")
    private Double longitude;

    //足迹统计信息
    @OneToOne(fetch = FetchType.LAZY)
    @NotNull(message = "statistics is not null")
    @ApiModelProperty(hidden = true)
    private Statistics statistics;

    //附件类型，是视频还是照片
    @Enumerated(EnumType.STRING)
    @ApiModelProperty(hidden = true)
    private FootprintType type;

    //是否是商家评论
    @ApiModelProperty(hidden = true)
    private Boolean ifBusinessComment = Boolean.FALSE;

    //商家ID
    private Long business;

    /**
     * checkLack
     */
    public String checkLack() {
        StringBuilder builder = HibernateValidationUtil.validateModel(this);
        return builder.toString();
    }

    public enum FootprintType {
        media, photo
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Document getPhoto() {
        return photo;
    }

    public void setPhoto(Document photo) {
        this.photo = photo;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
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

    public Statistics getStatistics() {
        return statistics;
    }

    public void setStatistics(Statistics statistics) {
        this.statistics = statistics;
    }

    public FootprintType getType() {
        return type;
    }

    public void setType(FootprintType type) {
        this.type = type;
    }

    public Boolean getIfBusinessComment() {
        return ifBusinessComment;
    }

    public void setIfBusinessComment(Boolean ifBusinessComment) {
        this.ifBusinessComment = ifBusinessComment;
    }

    public Long getBusiness() {
        return business;
    }

    public void setBusiness(Long business) {
        this.business = business;
    }
}
