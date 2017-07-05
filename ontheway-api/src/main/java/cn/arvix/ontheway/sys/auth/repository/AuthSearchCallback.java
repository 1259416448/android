package cn.arvix.ontheway.sys.auth.repository;

import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.repository.callback.DefaultSearchCallback;

import javax.persistence.Query;

/**
 * @author Created by yangyang on 2017/3/19.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class AuthSearchCallback extends DefaultSearchCallback {

    public AuthSearchCallback() {
        super("x");
    }

    //目前未加入职位检索，以后有需求可加入
    @Override
    public void prepareQL(StringBuilder ql, Searchable search) {
        super.prepareQL(ql, search);
        //是否拥有检索条件
        boolean hasQ = search.containsSearchKey("q");
        boolean ifOnlySaas = search.containsSearchKey("notUser");
        //添加条件检索
        if (hasQ) {
            ql.append("  and ( exists (select 1 from Organization o where name like :q1 and o.id = x.organizationId ) " +
                    "or exists ( select 1 from User u where (username = :q or mobilePhoneNumber = :q or email = :q or name like:q1) and u.id = x.userId ) ) ");
        }
        if (ifOnlySaas) {
            ql.append(" and exists ( select 1 from User u where u.userType != 'user' and u.id = x.userId ) ");
        }
    }

    @Override
    public void setValues(Query query, Searchable search) {
        super.setValues(query, search);
        if (search.containsSearchKey("q")) {
            String q = search.getValue("q");
            query.setParameter("q1", "%" + q + "%");
            query.setParameter("q", q);
        }
    }

}
