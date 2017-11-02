package cn.arvix.ontheway.business.repository;

import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.repository.callback.DefaultSearchCallback;
import cn.arvix.ontheway.business.entity.BusinessExpand;

import javax.persistence.Query;
import java.util.Date;

/**
 * @author Created by yangyang on 2017/10/31.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class BusinessSearchCallback extends DefaultSearchCallback {

    public BusinessSearchCallback() {
        super("x");
    }


    @Override
    public void prepareQL(StringBuilder ql, Searchable search) {
        super.prepareQL(ql, search);
        boolean ifClaim = search.containsSearchKey("claim");
        if (ifClaim) {
            if (ql.indexOf("count(x)") == -1) {
                ql = ql.delete(0, 16);
                ql.insert(0, "select new cn.arvix.ontheway.business.dto.UserClaimBusinessDTO ( " +
                        " x.id as businessId , " +
                        " x.name as name , " +
                        " x.address as address , " +
                        " x.contactInfo as contactInfo , " +
                        " be.dateCreated as claimDate " +
                        " ) from Business x left join x.businessExpand be ");
                ql.append("and be.user.id=:userId " +
                        "and be.id = x.businessExpand.id " +
                        "and be.status = :claimStatus " +
                        "and be.dateCreated <= :dateCreated ) order by claimDate desc");
            } else {
                ql.append("and exists (select 1 from BusinessExpand be where be.id = x.businessExpand.id " +
                        "and be.user.id=:userId " +
                        "and be.status = :claimStatus " +
                        "and be.dateCreated <= :dateCreated )");
            }
        }
    }

    @Override
    public void setValues(Query query, Searchable search) {

        super.setValues(query, search);
        boolean ifClaim = search.containsSearchKey("claim");

        if (ifClaim) {
            Long userId = search.getValue("userId");
            Date dateCreated = search.getValue("dateCreated");
            BusinessExpand.ClaimStatus claimStatus = search.getValue("claimStatus");
            query.setParameter("userId", userId);
            query.setParameter("dateCreated", dateCreated);
            query.setParameter("claimStatus", claimStatus);
        }
    }
}
