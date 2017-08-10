package cn.arvix.ontheway.footprint.entity;

import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.base.common.utils.HibernateValidationUtil;
import cn.arvix.ontheway.ducuments.entity.Document;
import cn.arvix.ontheway.sys.user.entity.User;
import io.swagger.annotations.ApiModelProperty;
import org.hibernate.annotations.Formula;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.util.Date;

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
    @ManyToOne(fetch = FetchType.LAZY)
    @ApiModelProperty(hidden = true)
    private Document photo;


    @Formula(value = "( select d.file_url from agile_document d where d.id = photo_id )")
    private String footprintPhoto;

    //发布用户
    @ManyToOne(fetch = FetchType.LAZY)
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

    //到某个点的距离
    private Double distance;

    private Boolean ifDelete = Boolean.FALSE;

    public Footprint() {

    }

    public Footprint(Long id, String content, String footprintPhoto, Long userId,
                     String address, Double latitude, Double longitude,
                     FootprintType type, Boolean ifBusinessComment,
                     Long business, Double distance, Date dateCreated) {
        setId(id);
        this.content = content;
        this.footprintPhoto = footprintPhoto;
        this.user = new User();
        this.user.setId(userId);
        this.address = address;
        this.latitude = latitude;
        this.longitude = longitude;
        this.type = type;
        this.ifBusinessComment = ifBusinessComment;
        this.business = business;
        this.distance = distance;
        setDateCreated(dateCreated);
    }

    public Footprint(Long id, String content, Long userId, String address, Double latitude, Double longitude, Date dateCreated) {
        this.content = content;
        this.latitude = latitude;
        this.longitude = longitude;
        this.user = new User();
        this.user.setId(userId);
        this.address = address;
        setDateCreated(dateCreated);
        setId(id);
    }

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

    public String getFootprintPhoto() {
        return footprintPhoto;
    }

    public void setFootprintPhoto(String footprintPhoto) {
        this.footprintPhoto = footprintPhoto;
    }

    public Double getDistance() {
        return distance;
    }

    public void setDistance(Double distance) {
        this.distance = distance;
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

    public Boolean getIfDelete() {
        return ifDelete;
    }

    public void setIfDelete(Boolean ifDelete) {
        this.ifDelete = ifDelete;
    }
}
