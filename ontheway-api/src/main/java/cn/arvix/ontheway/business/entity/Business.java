package cn.arvix.ontheway.business.entity;

import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.base.common.repository.hibernate.type.CollectionToStringUserType;
import cn.arvix.base.common.utils.HibernateValidationUtil;
import io.swagger.annotations.ApiModelProperty;
import org.hibernate.annotations.Parameter;
import org.hibernate.annotations.Type;
import org.hibernate.annotations.TypeDef;
import org.hibernate.validator.constraints.Length;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import java.util.Set;

/**
 * @author Created by yangyang on 2017/8/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Entity
@Table(name = "otw_business")
@TypeDef(
        name = "SetToStringUserType",
        typeClass = CollectionToStringUserType.class,
        parameters = {
                @Parameter(name = "separator", value = ","),
                @Parameter(name = "collectionType", value = "java.util.HashSet"),
                @Parameter(name = "elementType", value = "java.lang.Long")
        }
)
public class Business extends BaseEntity<Long> {

    //商家名称
    @NotNull(message = "name is not null")
    @ApiModelProperty(value = "商家名称")
    @Length(min = 1, max = 128, message = "1 <= name <= 128 ")
    private String name;

    //定位地址
    @NotNull(message = "address is not null")
    @ApiModelProperty(value = "定位地址")
    @Length(min = 1, max = 255, message = "1 <= address <= 255 ")
    private String address;

    //纬度
    @ApiModelProperty(value = "纬度")
    @NotNull(message = "latitude is not null")
    private Double latitude;

    //经度
    @ApiModelProperty(value = "经度")
    @NotNull(message = "longitude is not null")
    private Double longitude;

    //联系方式
    @ApiModelProperty(value = "联系方式")
    @NotNull(message = "contactInfo is not null")
    @Length(min = 0, max = 255, message = "0 <= contactInfo <= 255 ")
    private String contactInfo;

    //类型IDs
    @Type(type = "SetToStringUserType")
    @NotNull(message = "typeIds is not null")
    private Set<Long> typeIds;

    //商家拓展信息，认领后的商家会有当前信息
    @OneToOne(fetch = FetchType.LAZY)
    private BusinessExpand businessExpand;

    //商家信息统计
    @OneToOne(fetch = FetchType.LAZY)
    @NotNull(message = "statistics is not null")
    @ApiModelProperty(hidden = true)
    private BusinessStatistics statistics;

    //商家颜色代码
    @NotNull(message = "colorCode is not null")
    @Length(min = 3, max = 6, message = "3 <= colorCode <= 6 ")
    private String colorCode;

    //权重 用于排序 desc 排序 默认值为 0
    @NotNull(message = "weight is not null")
    private Float weight = 0f;

    //商家是否展示 如果是用户自己添加的商家，需要认领通过后才会展示
    private Boolean ifShow = Boolean.FALSE;

    private String poiDetailUrl;

    /**
     * checkLack
     */
    public String checkLack() {
        StringBuilder builder = HibernateValidationUtil.validateModel(this);
        return builder.toString();
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

    public String getContactInfo() {
        return contactInfo;
    }

    public void setContactInfo(String contactInfo) {
        this.contactInfo = contactInfo;
    }

    public Set<Long> getTypeIds() {
        return typeIds;
    }

    public void setTypeIds(Set<Long> typeIds) {
        this.typeIds = typeIds;
    }

    public BusinessExpand getBusinessExpand() {
        return businessExpand;
    }

    public void setBusinessExpand(BusinessExpand businessExpand) {
        this.businessExpand = businessExpand;
    }

    public BusinessStatistics getStatistics() {
        return statistics;
    }

    public void setStatistics(BusinessStatistics statistics) {
        this.statistics = statistics;
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

    public Boolean getIfShow() {
        return ifShow;
    }

    public void setIfShow(Boolean ifShow) {
        this.ifShow = ifShow;
    }

    public String getPoiDetailUrl() {
        return poiDetailUrl;
    }

    public void setPoiDetailUrl(String poiDetailUrl) {
        this.poiDetailUrl = poiDetailUrl;
    }
}
