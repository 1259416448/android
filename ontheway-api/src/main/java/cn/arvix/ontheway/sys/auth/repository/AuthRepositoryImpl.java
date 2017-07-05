/**
 * Copyright (c) 2005-2012 https://github.com/zhangkaitao
 * <p>
 * Licensed under the Apache License, Version 2.0 (the "License");
 */
package cn.arvix.ontheway.sys.auth.repository;

import cn.arvix.ontheway.sys.utils.WebContextUtils;
import com.google.common.collect.Sets;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import java.util.List;
import java.util.Set;

@Repository
public class AuthRepositoryImpl {

    @PersistenceContext
    private EntityManager em;

    private WebContextUtils webContextUtils;

    @Autowired
    public void setWebContextUtils(WebContextUtils webContextUtils) {
        this.webContextUtils = webContextUtils;
    }

    public Set<Long> findRoleIds(Long userId, Set<Long> groupIds, Set<Long> organizationIds, Set<Long> jobIds, Set<Long[]> organizationJobIds) {

        boolean hasGroupIds = groupIds != null && groupIds.size() > 0;
        boolean hasOrganizationIds = organizationIds != null && organizationIds.size() > 0;
        boolean hasJobIds = jobIds != null && jobIds.size() > 0;
        boolean hasOrganizationJobIds = organizationJobIds != null && organizationJobIds.size() > 0;

        StringBuilder hql = new StringBuilder("select roleIds from Auth where ");
        hql.append("( (userId=:userId) ");

        if (hasGroupIds) {
            hql.append(" or ");
            hql.append(" (groupId in (:groupIds)) ");
        }

        if (hasOrganizationIds) {
            hql.append(" or ");
            hql.append(" ( organizationId in (:organizationIds) and jobId=0 ) ");
        }

        if (hasJobIds) {
            hql.append(" or ");
            hql.append(" (( organizationId=0 and jobId in (:jobIds) )) ");
        }
        if (hasOrganizationJobIds) {
            int i = 0, l = organizationJobIds.size();
            while (i < l) {
                hql.append(" or ");
                hql.append(" ( organizationId=:organizationId_").append(i).append(" and jobId=:jobId_").append(i).append(" ) ");
                i++;
            }
        }

        hql.append(") and companyId = :companyId and opId = 0 and opModule = 0 "); //加上saas信息 剔除单条数据权限

        Query q = em.createQuery(hql.toString());

        q.setParameter("userId", userId);

        if (hasGroupIds) {
            q.setParameter("groupIds", groupIds);
        }

        if (hasOrganizationIds) {
            q.setParameter("organizationIds", organizationIds);
        }

        if (hasJobIds) {
            q.setParameter("jobIds", jobIds);
        }
        q.setParameter("companyId", webContextUtils.getCompanyId());
        if (hasOrganizationJobIds) {
            int i = 0;
            for (Long[] organizationJobId : organizationJobIds) {
                q.setParameter("organizationId_" + i, organizationJobId[0]);
                q.setParameter("jobId_" + i, organizationJobId[1]);
                i++;
            }
        }
        //开启查询缓存
        q.setHint("org.hibernate.cacheable", true);

        List<Set<Long>> roleIdSets = (List<Set<Long>>) q.getResultList();

        Set<Long> roleIds = Sets.newHashSet();
        for (Set<Long> set : roleIdSets) {
            roleIds.addAll(set);
        }
        return roleIds;
    }
}
