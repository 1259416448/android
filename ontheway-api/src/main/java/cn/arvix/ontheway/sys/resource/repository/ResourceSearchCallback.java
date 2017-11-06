package cn.arvix.ontheway.sys.resource.repository;

import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.repository.callback.DefaultSearchCallback;

import javax.persistence.Query;
import java.util.Set;

/**
 * @author Created by yangyang on 2017/4/13.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class ResourceSearchCallback extends DefaultSearchCallback {

    public ResourceSearchCallback() {
        super("x");
    }

    @Override
    public void prepareQL(StringBuilder ql, Searchable search) {
        super.prepareQL(ql, search);
        boolean roleIds = search.containsSearchKey("roleIds");
        if (roleIds) {
            ql.append(" and exists (select 1 from RoleResource rr where role.id in (:roleIds) and x.id = rr.resourceId ) ");
        }
    }

    @Override
    public void setValues(Query query, Searchable search) {
        super.setValues(query, search);
        if (search.containsSearchKey("roleIds")) {
            Set<Long> roleIds = search.getValue("roleIds");
            query.setParameter("roleIds", roleIds);
        }
    }

}
