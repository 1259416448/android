package cn.arvix.ontheway.ducuments.repository;

import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.repository.callback.DefaultSearchCallback;
import cn.arvix.base.common.utils.CommonContact;

import javax.persistence.Query;

/**
 * @author Created by yangyang on 2017/10/12.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

public class DocumentSearchCallback extends DefaultSearchCallback {

    public DocumentSearchCallback() {
        super("x");
    }

    @Override
    public void prepareQL(StringBuilder ql, Searchable search) {
        super.prepareQL(ql, search);

        //是否存在获取商家的用户图集标识，如果存在，需要进行嵌套查询
        boolean hasBusinessUserPhotos = search.containsSearchKey(CommonContact.BUSINESS_USER_PHOTOS);
        if (hasBusinessUserPhotos) {
            ql.append(" and exists ( select 1 from Footprint otwf " +
                    "where otwf.ifDelete = :ifDelete " +
                    "and otwf.ifBusinessComment = :ifBusinessComment " +
                    "and business=:businessId and otwf.id = x.parentId )");
        }
    }

    @Override
    public void setValues(Query query, Searchable search) {
        super.setValues(query, search);
        boolean hasBusinessUserPhotos = search.containsSearchKey(CommonContact.BUSINESS_USER_PHOTOS);
        if (hasBusinessUserPhotos) {
            Boolean ifDelete = search.getValue("ifDelete");
            Boolean ifBusinessComment = search.getValue("ifBusinessComment");
            Long businessId = search.getValue("businessId");
            query.setParameter("ifDelete", ifDelete);
            query.setParameter("ifBusinessComment", ifBusinessComment);
            query.setParameter("businessId", businessId);
        }
    }
}
