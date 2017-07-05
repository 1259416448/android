package cn.arvix.ontheway.sys.user.repository;

import cn.arvix.ontheway.sys.organization.entity.Organization;
import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.repository.callback.DefaultSearchCallback;

import javax.persistence.Query;
import java.util.Arrays;

/**
 * @author Created by yangyang on 2017/3/19.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class UserSearchCallback extends DefaultSearchCallback {

    public UserSearchCallback() {
        super("x");
    }

    //目前未加入职位检索，以后有需求可加入
    @Override
    public void prepareQL(StringBuilder ql, Searchable search) {
        super.prepareQL(ql, search);
        boolean hasOrganization = search.containsSearchKey("organization");
        boolean hasJob = search.containsSearchKey("job");
        if (hasOrganization || hasJob) {
            ql.append(" and exists(select 1 from UserOrganizationJob oj");
            if (hasOrganization) {
                ql.append(" left join oj.organization o ");

            }
            ql.append(" where oj.user=x ");
            if (hasOrganization) {
                ql.append(" and (o.id=:organizationId or o.parentIds like :organizationParentIds)");
            }
            ql.append(")");
        }

        /*
         * 添加过滤条件
         */
        boolean uIds = search.containsSearchKey("uIds");
        boolean oIds = search.containsSearchKey("oIds");
        if (uIds || oIds) {
            ql.append(" and (");
            if (uIds) {
                ql.append(" x.id in (:uIds)");
            }
            if (oIds) {
                if (uIds) ql.append(" and ");
                ql.append(" exists (select 1 from UserOrganizationJob oj left join oj.organization o where oj.user = x and o.id in (:oIds))");
            }
            ql.append(" )");
        }
    }

    @Override
    public void setValues(Query query, Searchable search) {
        super.setValues(query, search);
        if (search.containsSearchKey("organization")) {
            Organization organization = search.getValue("organization");
            query.setParameter("organizationId", organization.getId());
            query.setParameter("organizationParentIds", organization.makeSelfAsNewParentIds() + "%");
        }
        if (search.containsSearchKey("uIds")) {
            Long[] uIds = search.getValue("uIds");
            query.setParameter("uIds", Arrays.asList(uIds));
        }
        if (search.containsSearchKey("oIds")) {
            Long[] oIds = search.getValue("oIds");
            query.setParameter("oIds", Arrays.asList(oIds));
        }
    }

}
