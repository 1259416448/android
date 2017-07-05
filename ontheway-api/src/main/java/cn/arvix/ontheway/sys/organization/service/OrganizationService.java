package cn.arvix.ontheway.sys.organization.service;

import cn.arvix.ontheway.sys.organization.entity.Organization;
import cn.arvix.ontheway.sys.organization.entity.OrganizationType;
import cn.arvix.ontheway.sys.organization.repository.OrganizationRepository;
import cn.arvix.ontheway.sys.user.entity.User;
import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.entity.search.exception.SearchException;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.base.common.utils.MessageUtils;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.apache.commons.lang3.StringUtils;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @author Created by yangyang on 2017/3/8.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class OrganizationService extends BaseServiceImpl<Organization, Long> {

    private OrganizationRepository getOrganizationRepository() {
        return (OrganizationRepository) baseRepository;
    }

    /**
     * 添加一个组织机构
     *
     * @param m 实体
     * @return 添加结果
     */
    @Override
    public JSONResult save_(Organization m) {
        modify(m);
        return super.save_(m);
    }

    private void modify(Organization m) {
        //设置父节点IDs
        Organization parent;
        if (m.getParentId() != null) {
            parent = findOne(m.getParentId());
        } else { //自动补全上级节点
            User user = webContextUtils.getCheckCurrentUser();
            parent = getOrganizationRepository().findByTypeAndCompanyId(OrganizationType.saas, user.getCompanyId());
        }
        if (parent != null) {
            m.setParentId(parent.getId());
            m.setParentIds(StringUtils.isEmpty(parent.getParentIds()) ?
                    parent.getSeparator() + parent.getId().toString() + parent.getSeparator() :
                    parent.getParentIds() + parent.getId() + parent.getSeparator());
        }
        //这里目前只有2级关系 都是department类型,把缺省的参数自动补全
        m.setType(OrganizationType.department);
        m.setShow(true);
        m.setSorter(5f);
    }

    /**
     * 修改一个组织机构信息
     *
     * @param m 实体
     * @return 修改结果
     */
    public JSONResult update_(Organization m) {
        //modify(m);
        //目前这里只修改名称而已，saas类型不允许修改
        Organization organization = findOne(m.getId());
        if (organization.getType().equals(OrganizationType.saas))
            return JsonUtil.getFailure(MessageUtils.message(CommonContact.OPTION_ERROR), CommonContact.OPTION_SUCCESS);

        organization.setName(m.getName());

        return super.update_(organization);
    }

    /**
     * 获取所有树结构数据
     *
     * @return ztree json 数据
     */
    public JSONResult tree() {
        Map<String, Object> paramsMap = Maps.newHashMap();
        User user = webContextUtils.getCheckCurrentUser();
        paramsMap.put("companyId_eq", user.getCompanyId());
        Searchable searchable = Searchable.newSearchable(paramsMap, new Sort(Sort.Direction.ASC, "sorter"));
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.FETCH_SUCCESS),
                CommonContact.FETCH_SUCCESS,
                JsonUtil.getBaseEntityMapList(findAllWithSort(searchable)));
    }

    /**
     * 部门删除 递归删除
     *
     * @param id 主键
     * @return json
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public JSONResult delete_(Long id) {
        User user = webContextUtils.getCheckCurrentUser();
        deleteOne(id, user.getCompanyId());
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.DELETE_SUCCESS),
                CommonContact.DELETE_SUCCESS, id);
    }

    /**
     * 多项删除
     *
     * @param id 主键数组
     * @return json
     */
    @Transactional(rollbackFor = Exception.class)
    public JSONResult delete_(Long[] id) {
        for (Long one : id) {
            delete_(one);
        }
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.DELETE_MORE_SUCCESS),
                CommonContact.DELETE_MORE_SUCCESS, id);
    }

    /**
     * 删除一个部门
     * 1、检查用户存在
     * 2、检查是否拥有下级
     * 3、清除角色关联信息
     *
     * @param id 主键
     */
    private void deleteOne(Long id, Long companyId) {
        Long userCount = getOrganizationRepository().findUserCountByOrganizationId(id);
        if (userCount > 0) throw new SearchException("user.exist");
        List<Organization> list = getOrganizationRepository().findByParentIdAndCompanyId(id, companyId);
        if (list != null && list.size() > 0) {
            for (Organization one : list) {
                deleteOne(one.getId(), companyId);
            }
        }
        super.delete(id);
    }

    /**
     * 下拉框数据获取 如果传入ID 会去掉当前节点及所有下级数据
     *
     * @param id 去掉的节点ID
     * @return 下拉框数据
     */
    public JSONResult select(Long id) {
        Map<String, Object> paramsMap = Maps.newHashMap();
        User user = webContextUtils.getCheckCurrentUser();
        paramsMap.put("companyId_eq", user.getCompanyId());
        Searchable searchable = Searchable.newSearchable(paramsMap, new Sort(Sort.Direction.ASC, "sorter"));
        List<Organization> organizationList = findAllWithSort(searchable);
        List<Map<String, Object>> selectList = Lists.newArrayList();
        if (organizationList != null && organizationList.size() > 0) {
            if (id != null) {
                organizationList = organizationList.stream().filter(x -> !(x.getId().equals(id)
                        || (x.getParentIds() != null && x.getParentIds().contains(x.getSeparator() + id + x.getSeparator()))))
                        .collect(Collectors.toList());
            }
            if (organizationList.size() > 0) {
                organizationList.forEach(x -> {
                    Map<String, Object> selectMap = Maps.newHashMap();
                    selectMap.put("key", x.getId());
                    selectMap.put("value", x.getName());
                    selectList.add(selectMap);
                });
            }
        }
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.FETCH_SUCCESS),
                CommonContact.FETCH_SUCCESS, selectList);
    }

    /**
     * 把传入的部门按传入顺序排序
     *
     * @param ids 数组
     * @return 排序结果
     */
    @Transactional(rollbackFor = Exception.class)
    public JSONResult sorter(Long[] ids) {
        float sorter = 5f;
        for (Long id : ids) {
            Organization organization = super.findOne(id);
            organization.setSorter(sorter);
            super.update(organization);
            sorter++;
        }
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.OPTION_SUCCESS), CommonContact.OPTION_SUCCESS);
    }

    /**
     * 获取当前用户当前的组织
     *
     * @return 当前的saas组织
     */
    public Organization getUserCurrentOrganization() {
        return getOrganizationRepository().findByTypeAndCompanyId(OrganizationType.saas, webContextUtils.getCompanyId());
    }

    /**
     * 通过saas organization companyId 获取他下的所有部门Id
     * 直接获取相同companyId的 organization即可
     *
     * @return 部门ID信息
     */
    public Long[] getOrganizationByCompanyId(Long companyId) {
        return getOrganizationRepository().findIdByCompanyId(companyId);
    }

}
