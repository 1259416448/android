package cn.arvix.ontheway.ducuments.repository;

import cn.arvix.ontheway.sys.user.entity.User;
import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.repository.callback.DefaultSearchCallback;

import javax.persistence.Query;

/**
 * @author Created by yangyang on 2017/3/19.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class DocumentDirSearchCallback extends DefaultSearchCallback {

    public DocumentDirSearchCallback() {
        super("x");
    }

    @Override
    public void prepareQL(StringBuilder ql, Searchable search) {
        super.prepareQL(ql, search);
        boolean hasAuth = search.containsSearchKey("auth");
        if (hasAuth) {
            ql.append(" and ( x.documentDirType = 'common' or documentDirType = 'attachment' or exists ( select 1 from Auth a where" +
                    " ( (a.organizationId in (:organizationId) and a.jobId=0 ) " +
                    "or (a.userId=:userId) ) " +
                    "and a.companyId=:companyId " +
                    "and a.opModule=:opModule " +
                    "and a.opId = x.id ) ) ");
        }
    }

    @Override
    public void setValues(Query query, Searchable search) {
        super.setValues(query, search);
        if (search.containsSearchKey("auth")) {
            User user = search.getValue("auth");
            Integer opModule = search.getValue("opModule");
            query.setParameter("companyId", user.getCompanyId());
            query.setParameter("userId", user.getId());
            query.setParameter("organizationId", user.getOrganizationIds());
            query.setParameter("opModule", opModule);
        }
    }

}
