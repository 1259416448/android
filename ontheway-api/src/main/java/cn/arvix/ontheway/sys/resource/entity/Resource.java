package cn.arvix.ontheway.sys.resource.entity;

import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.base.common.repository.support.annotation.EnableQueryCache;
import cn.arvix.base.common.utils.HibernateValidationUtil;
import cn.arvix.base.common.utils.TimeMaker;
import com.google.common.collect.Maps;
import io.swagger.annotations.ApiModelProperty;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Formula;
import org.hibernate.validator.constraints.Length;

import javax.persistence.*;
import javax.validation.constraints.DecimalMax;
import javax.validation.constraints.DecimalMin;
import javax.validation.constraints.NotNull;
import java.util.Map;

/**
 * @author Created by yangyang on 2017/3/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */


@Entity
@Table(name = "sys_resource")
@EnableQueryCache
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Resource extends BaseEntity<Long> {

    public static final String TABLE_NAME = "sys_resource";

    /**
     * 标题
     */
    @NotNull(message = "name is not null")
    @Length(min = 1, max = 255, message = "The length of the name is between {min} and {max}!")
    private String name;

    /**
     * 资源标识符 用于权限匹配的 如sys:resource
     */
    @Length(max = 255, message = "The length of the identity is between {min} and {max}!")
    private String identity;

    /**
     * 点击后前往的地址
     * 菜单才有
     */
    @Length(max = 255, message = "The length of the urls is between {min} and {max}!")
    private String urls;

    /**
     * 父路径
     */
    @Column
    private Long parentId;

    @Column
    @Length(max = 255, message = "The length of the parentIds is between {min} and {max}!")
    private String parentIds;

    @NotNull(message = "sorter is not null!")
    @DecimalMax(value = "9999.99", message = "The sorter must be less than or equal to {value}!")
    @DecimalMin(value = "-9999.99", message = "The sorter must be greater than or equal to {value}!")
    private Float sorter;

    @Enumerated(EnumType.STRING)
    @NotNull(message = "resourceType is not null!")
    private ResourceType resourceType;

    /**
     * 图标
     */
    @Length(max = 255, message = "The length of the iconCode is between {min} and {max}!")
    private String iconCode;

    /**
     * 是否有叶子节点
     */
    @Formula(value = "(select count(*) from sys_resource f_t where f_t.parent_id = id and f_t.resource_type = 'column')")
    private boolean hasChildren;

    /**
     * 是否显示
     */
    @Column(name = "is_show")
    private Boolean show = Boolean.FALSE;

    @Column
    private Boolean beforeShow = Boolean.FALSE;

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
        objectMap.put("pId", getPId());
        objectMap.put("parentIds", parentIds);
        objectMap.put("parentId", parentId);
        objectMap.put("beforeShow", beforeShow);
        objectMap.put("show", show);
        objectMap.put("hasChildren", hasChildren);
        objectMap.put("iconCode", iconCode);
        objectMap.put("identity", identity);
        objectMap.put("sorter", sorter);
        objectMap.put("resourceType", resourceType);
        objectMap.put("name", name);
        objectMap.put("urls", urls);
        objectMap.put("dateCreated", TimeMaker.toDateTimeStr(getDateCreated()));
        objectMap.put("lastUpdated", TimeMaker.toDateTimeStr(getLastUpdated()));
        objectMap.put("creater", getCreater());
        return objectMap;
    }

    private String getPId() {
        if (parentId == null) {
            return "begin";
        }
        return String.valueOf(parentId);
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getIdentity() {
        return identity;
    }

    public void setIdentity(String identity) {
        this.identity = identity;
    }

    public String getUrls() {
        return urls;
    }

    public void setUrls(String urls) {
        this.urls = urls;
    }

    public Long getParentId() {
        return parentId;
    }

    public void setParentId(Long parentId) {
        this.parentId = parentId;
    }

    public String getParentIds() {
        return parentIds;
    }

    public void setParentIds(String parentIds) {
        this.parentIds = parentIds;
    }

    public Float getSorter() {
        return sorter;
    }

    public void setSorter(Float sorter) {
        this.sorter = sorter;
    }

    public String getIconCode() {
        return iconCode;
    }

    public void setIconCode(String iconCode) {
        this.iconCode = iconCode;
    }

    public boolean isHasChildren() {
        return hasChildren;
    }

    public void setHasChildren(boolean hasChildren) {
        this.hasChildren = hasChildren;
    }

    public Boolean getShow() {
        return show;
    }

    public void setShow(Boolean show) {
        this.show = show;
    }

    public Boolean getBeforeShow() {
        return beforeShow;
    }

    public void setBeforeShow(Boolean beforeShow) {
        this.beforeShow = beforeShow;
    }

    public ResourceType getResourceType() {
        return resourceType;
    }

    public void setResourceType(ResourceType resourceType) {
        this.resourceType = resourceType;
    }

    public String getSeparator() {
        return "/";
    }
}
