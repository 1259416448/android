/**
 * Copyright (c) 2005-2012 https://github.com/zhangkaitao
 * <p>
 * Licensed under the Apache License, Version 2.0 (the "License");
 */
package cn.arvix.ontheway.sys.organization.entity;

import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.base.common.repository.support.annotation.EnableQueryCache;
import cn.arvix.base.common.utils.HibernateValidationUtil;
import cn.arvix.base.common.utils.TimeMaker;
import com.google.common.collect.Maps;
import io.swagger.annotations.ApiModelProperty;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Formula;
import org.hibernate.validator.constraints.Length;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.util.Map;

@Entity
@Table(name = "sys_organization")
@EnableQueryCache
@org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Organization extends BaseEntity<Long> {

    public static final String TABLE_NAME = "sys_organization";

    /**
     * 标题
     */
    @NotNull(message = "name is not null")
    @Length(min = 1, max = 255, message = "The length of the name is between {min} and {max}!")
    private String name;

    /**
     * 组织机构类型 默认 分公司
     */
    @Enumerated(EnumType.STRING)
    private OrganizationType type = OrganizationType.admin;
    /**
     * 父路径
     */
    @Column
    private Long parentId;

    @Column
    private String parentIds;

    private Float sorter;

    /**
     * 图标
     */
    private String iconCode;

    /**
     * 是否有叶子节点
     */
    @Formula(value = "(select count(*) from sys_organization f_t where f_t.parent_id = id)")
    private boolean hasChildren;

    /**
     * 是否显示
     */
    @Column(name = "is_show")
    private Boolean show = Boolean.FALSE;

    private String memo;

    public Organization() {
    }

    public Organization(Long organizationId) {
        setId(organizationId);
    }

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
        objectMap.put("name", name);
        objectMap.put("sorter", sorter);
        objectMap.put("iconCode", iconCode);
        objectMap.put("type", type);
        objectMap.put("parentIds", parentIds);
        objectMap.put("parentId", parentId);
        objectMap.put("show", show);
        objectMap.put("hasChildren", hasChildren);
        objectMap.put("memo", memo);
        objectMap.put("creater", getCreater());
        objectMap.put("dateCreated", TimeMaker.toDateTimeStr(getDateCreated()));
        objectMap.put("lastUpdated", TimeMaker.toDateTimeStr(getLastUpdated()));
        return objectMap;
    }

    private String getPId() {
        if (parentId == null) {
            return "begin";
        }
        return String.valueOf(parentId);
    }

    public String makeSelfAsNewParentIds() {
        return org.apache.commons.lang3.StringUtils.isEmpty(getParentIds())
                ? getSeparator() + getId() + getSeparator()
                : getParentIds() + getId() + getSeparator();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public OrganizationType getType() {
        return type;
    }

    public void setType(OrganizationType type) {
        this.type = type;
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

    public String getSeparator() {
        return "/";
    }

    public String getIconCode() {
        return iconCode;
    }

    public void setIconCode(String iconCode) {
        this.iconCode = iconCode;
    }

    public Float getSorter() {
        return sorter;
    }

    public void setSorter(Float sorter) {
        this.sorter = sorter;
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

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

}
