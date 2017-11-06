/**
 * Copyright (c) 2005-2012 https://github.com/zhangkaitao
 * <p>
 * Licensed under the Apache License, Version 2.0 (the "License");
 */
package cn.arvix.ontheway.sys.user.entity;

import cn.arvix.ontheway.sys.organization.entity.Job;
import cn.arvix.ontheway.sys.organization.entity.Organization;
import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.base.common.repository.support.annotation.EnableQueryCache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import java.util.Map;

/**
 * 为了提高连表性能 使用数据冗余 而不是 组织机构(1)-----(*)职务的中间表
 * 即在该表中 用户--组织机构--职务 是唯一的  但 用户-组织机构可能重复
 */
@Entity
@Table(name = "sys_user_organization_job")
@EnableQueryCache
@org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class UserOrganizationJob extends BaseEntity<Long> {

    @ManyToOne(fetch = FetchType.LAZY)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    private Organization organization;

    @ManyToOne(fetch = FetchType.LAZY)
    private Job job;


    public Map<String, Object> toMap() {
        return organization.toMap();
    }

    public UserOrganizationJob() {
    }

    public UserOrganizationJob(Long id) {
        setId(id);
    }

    public UserOrganizationJob(Long organizationId, Long jobId) {
        if (organizationId != null) {
            this.organization = new Organization(organizationId);
        }
        if (jobId != null) {
            this.job = new Job(jobId);
        }
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Organization getOrganization() {
        return organization;
    }

    public void setOrganization(Organization organization) {
        this.organization = organization;
    }

    public Job getJob() {
        return job;
    }

    public void setJob(Job job) {
        this.job = job;
    }

    @Override
    public String toString() {
        return "UserOrganizationJob{id = " + this.getId() +
                ",organizationId=" + organization.getId() +
                ", jobId=" + job +
                ", userId=" + (user != null ? user.getId() : "null") +
                '}';
    }
}
