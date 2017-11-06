package cn.arvix.ontheway.sys.cache;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.repository.hibernate.HibernateUtils;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.base.common.utils.MessageUtils;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

/**
 * @author Created by yangyang on 2017/3/8.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class HibernateCacheService {

    @PersistenceContext
    private EntityManager entityManager;

    public JSONResult removeLevel2Cache() {
        HibernateUtils.evictLevel2Cache(entityManager);
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.HIBERNATE_LEVEL2_CACHE_REMOVE_SUCCESS),
                CommonContact.HIBERNATE_LEVEL2_CACHE_REMOVE_SUCCESS);
    }

}
