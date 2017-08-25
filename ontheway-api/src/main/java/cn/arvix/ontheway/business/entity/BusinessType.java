package cn.arvix.ontheway.business.entity;

import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.base.common.repository.support.annotation.EnableQueryCache;
import cn.arvix.base.common.utils.HibernateValidationUtil;
import cn.arvix.base.common.utils.TimeMaker;
import com.google.common.collect.Maps;
import io.swagger.annotations.ApiModelProperty;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Formula;

import javax.persistence.Entity;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import java.util.Map;

/**
 * 类型明确只有2级
 *
 * @author Created by yangyang on 2017/8/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Entity
@Table(name = "otw_business_type")
@EnableQueryCache
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class BusinessType extends BaseEntity<Long> {

    //名称
    @NotNull(message = "name is not null")
    private String name;

    //权重 用于排序 desc 排序
    @NotNull(message = "weight is not null")
    private Float weight;

    //是否置顶 表示把当前类型展示在首页 发现上
    private Boolean ifTop = Boolean.FALSE;

    //父级ID，如果为空，表示顶级节点
    private Long parentId;

    //图标Str IOS
    private String iconStr;

    //图标Str Android
    private String iconStrAndroid;

    //是否展示
    private Boolean ifShow = Boolean.TRUE;

    //是否拥有子节点
    @Formula(value = "( select count(*) from otw_business_type otwbt where otwbt.parent_id = id ) ")
    @ApiModelProperty(hidden = true)
    private Boolean hasChildren;

    //类型的颜色代码
    private String colorCode;

    /**
     * checkLack
     */
    public String checkLack() {
        StringBuilder builder = HibernateValidationUtil.validateModel(this);
        return builder.toString();
    }

    public Map<String, Object> toMap() {
        Map<String, Object> jsonMap = Maps.newHashMap();
        jsonMap.put("id", getId());
        jsonMap.put("name", name);
        jsonMap.put("weight", weight);
        jsonMap.put("ifTop", ifTop);
        jsonMap.put("parentId", parentId);
        jsonMap.put("iconStr", iconStr);
        jsonMap.put("iconStrAndroid", iconStrAndroid);
        jsonMap.put("ifShow", ifShow);
        jsonMap.put("hasChildren", hasChildren);
        jsonMap.put("colorCode", colorCode);
        jsonMap.put("dateCreated", TimeMaker.toTimeMillis(getDateCreated()));
        jsonMap.put("lastUpdated", TimeMaker.toTimeMillis(getLastUpdated()));
        return jsonMap;
    }

    public Boolean getIfTop() {
        return ifTop;
    }

    public void setIfTop(Boolean ifTop) {
        this.ifTop = ifTop;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Float getWeight() {
        return weight;
    }

    public void setWeight(Float weight) {
        this.weight = weight;
    }

    public Long getParentId() {
        return parentId;
    }

    public void setParentId(Long parentId) {
        this.parentId = parentId;
    }

    public String getIconStr() {
        return iconStr;
    }

    public void setIconStr(String iconStr) {
        this.iconStr = iconStr;
    }

    public Boolean getHasChildren() {
        return hasChildren;
    }

    public void setHasChildren(Boolean hasChildren) {
        this.hasChildren = hasChildren;
    }

    public Boolean getIfShow() {
        return ifShow;
    }

    public void setIfShow(Boolean ifShow) {
        this.ifShow = ifShow;
    }

    public String getColorCode() {
        return colorCode;
    }

    public void setColorCode(String colorCode) {
        this.colorCode = colorCode;
    }

    public String getIconStrAndroid() {
        return iconStrAndroid;
    }

    public void setIconStrAndroid(String iconStrAndroid) {
        this.iconStrAndroid = iconStrAndroid;
    }
}
