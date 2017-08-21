package cn.arvix.ontheway.business.service;

import cn.arvix.base.common.entity.search.PageRequest;
import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.ontheway.business.entity.BusinessTypeContact;
import com.google.common.collect.Maps;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @author Created by yangyang on 2017/8/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class BusinessTypeContactService extends BaseServiceImpl<BusinessTypeContact, Long> {


    /**
     * 判断商家类型是否使用过
     *
     * @param id 类型ID
     * @return 使用结果  true  false
     */
    public boolean checkBusinessTypeUsed(Long id) {
        Map<String, Object> params = Maps.newHashMap();
        params.put("businessTypeId_eq", id);
        List<BusinessTypeContact> contents = super.findAllWithNoCount(Searchable.newSearchable(params,
                new PageRequest(0, 1))).getContent();
        return contents != null && contents.size() > 0;
    }

    /**
     * 添加商家 和 商家类型关联关系
     *
     * @param businessId 商家ID
     * @param typeIds    商家所属类型
     */
    @Transactional(rollbackFor = Exception.class)
    public void createContact(Long businessId, Set<Long> typeIds) {
        for (Long typeId : typeIds) {
            BusinessTypeContact businessTypeContact = BusinessTypeContact.getInstance(businessId, typeId);
            super.save(businessTypeContact);
        }
    }
}
