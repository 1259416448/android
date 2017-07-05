package cn.arvix.ontheway.sys.permission.service;

import cn.arvix.ontheway.sys.permission.entity.Role;
import cn.arvix.ontheway.sys.permission.entity.RoleResource;
import cn.arvix.ontheway.sys.permission.entity.RoleType;
import cn.arvix.ontheway.sys.permission.repository.RoleRepository;
import cn.arvix.ontheway.sys.permission.repository.RoleResourceRepository;
import cn.arvix.ontheway.sys.user.entity.User;
import cn.arvix.ontheway.sys.user.entity.UserType;
import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.entity.search.PageRequest;
import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.entity.search.filter.SearchFilter;
import cn.arvix.base.common.entity.search.filter.SearchFilterHelper;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.base.common.utils.*;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @author Created by yangyang on 2017/3/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@Service
public class RoleService extends BaseServiceImpl<Role, Long> {


    private final RoleResourceRepository roleResourceRepository;

    @Autowired
    public RoleService(RoleResourceRepository roleResourceRepository) {
        this.roleResourceRepository = roleResourceRepository;
    }

    private RoleRepository getRoleRepository() {
        return (RoleRepository) baseRepository;
    }

    /**
     * 分页获取角色信息
     *
     * @param q         检索条件
     * @param number    当前页
     * @param size      每页大小
     * @param direction 排序方式
     * @param order     排序字段
     * @return 检索结果
     */
    public JSONResult search(String q, Integer number, Integer size, Sort.Direction direction, String order) {
        Checks.assertSortProperty(order);
        Sort sort = null;
        if (direction != null && order != null) {
            sort = new Sort(direction, order);
        }
        Map<String, Object> params = Maps.newHashMap();
        //根据当前用户类型增加一些查询参数
        User user = webContextUtils.getCheckCurrentUser();
        Boolean a = Boolean.FALSE;
        //saas用户只能获取当前团队下的角色信息
        if (user.getUserType().equals(UserType.saas)
                || (UserType.user.equals(user.getUserType())
                && SecurityUtils.getSubject().isPermitted(CommonPermission.SYSTEM_AUTH_AND_ROLE))) {
            params.put("companyId_eq", user.getCompanyId());
            params.put("roleType_eq", RoleType.normal);
        } else if (!UserType.user.equals(user.getUserType())
                && SecurityUtils.getSubject().isPermitted(CommonPermission.SYSTEM_AUTH_AND_ROLE)) { //非user类型用户 但是拥有SYSTEM_AUTH_AND_ROLE权限
            //companyId = null 或者 roleType = saas
            a = Boolean.TRUE;
        } else {
            return JsonUtil.getFailure(MessageUtils.message(CommonContact.NO_PERMISSION), CommonContact.NO_PERMISSION);
        }
        Searchable searchable = Searchable.newSearchable(params, new PageRequest(number, size), sort).setEnableToMap(true);
        if (a) { //添加条件
            searchable.or(SearchFilterHelper.newCondition("companyId_isNull", ""), SearchFilterHelper.newCondition("roleType_eq", "saas"));
        }
        if (!StringUtils.isEmpty(q)) {
            SearchFilter searchFilter = SearchFilterHelper.newCondition("name_like", q);
            SearchFilter searchFilter1 = SearchFilterHelper.newCondition("role_like", q);
            searchable.or(searchFilter, searchFilter1);
        }
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.FETCH_SUCCESS),
                CommonContact.FETCH_SUCCESS, super.findAll(searchable));

    }

    @RequiresPermissions(value = CommonPermission.SYSTEM_AUTH_AND_ROLE)
    public JSONResult save_(Role m) {
        if (m.getRoleType() == null) m.setRoleType(RoleType.normal);
        if (!checkRole(m)) return JsonUtil.getFailure(MessageUtils.message("role.exist"), CommonContact.ADD_EXIST);
        return super.save_(m);
    }

    @RequiresPermissions(value = CommonPermission.SYSTEM_AUTH_AND_ROLE)
    public JSONResult update_(Role m) {
        if (!checkRole(m)) return JsonUtil.getFailure(MessageUtils.message("role.exist"), CommonContact.ADD_EXIST);
        Role role = super.findOne(m.getId());
        role.setName(m.getName());
        role.setDescription(m.getDescription());
        role.setShow(m.getShow());
        role.setRole(m.getRole());
        return super.update_(role);
    }

    @Transactional
    @RequiresPermissions(value = CommonPermission.SYSTEM_AUTH_AND_ROLE)
    public JSONResult delete_(Long id) {
        //删除角色ID与资源的关联信息
        roleResourceRepository.deleteByRoleId(id);
        return super.delete_(id);
    }

    @Transactional
    @RequiresPermissions(value = CommonPermission.SYSTEM_AUTH_AND_ROLE)
    public JSONResult delete_(Long[] id) {
        //删除所有角色关系
        roleResourceRepository.deleteByRoleIds(Sets.newHashSet(id));
        return super.delete_(id);
    }

    /**
     * 检查role是否存在
     */
    private boolean checkRole(Role m) {
        User user = webContextUtils.getCheckCurrentUser();
        if (m.getId() != null) {
            return getRoleRepository().findByRoleAndCompanyIdNotEqId(m.getRole(), user.getCompanyId(), m.getId()) == null;
        } else {
            return getRoleRepository().findByRoleAndCompanyId(m.getRole(), user.getCompanyId()) == null;
        }
    }

    /**
     * 添加角色资源关联关系
     * 1、获取当前角色的所有关联关系
     * 2、删选出需要删除的
     * 3、添加新的
     *
     * @param id          角色ID
     * @param resourceIds 资源ID数组
     * @return 操作结果
     */
    @Transactional(rollbackFor = Exception.class)
    public JSONResult roleResourceSave(Long id, Long[] resourceIds) {
        if (resourceIds == null || resourceIds.length == 0) {
            roleResourceRepository.deleteByRoleId(id);
        } else {
            List<Long> oldIds = roleResourceRepository.findResourceIdWithRoleId(id);
            List<Long> newIds = Lists.newArrayList(Arrays.asList(resourceIds));
            if (oldIds != null) {
                newIds.removeAll(oldIds);
                oldIds.removeAll(Arrays.asList(resourceIds));
                //删除去掉的
                if (oldIds.size() > 0) {
                    Long[] ids = new Long[oldIds.size()];
                    ids = oldIds.toArray(ids);
                    roleResourceRepository.deleteByRoleIdAndResourceIdIsIn(id, ids);
                }
                //添加新的
                if (newIds.size() > 0) {
                    saveRoleResource(id, newIds);
                }
            } else {
                saveRoleResource(id, newIds);
            }
        }
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.UPDATE_SUCCESS),
                CommonContact.UPDATE_SUCCESS, resourceIds);
    }

    //添加新的关联信息
    private void saveRoleResource(Long id, List<Long> newIds) {
        Role role = new Role();
        role.setId(id);
        List<RoleResource> list = Lists.newArrayList();
        Date date = TimeMaker.nowSqlDate();
        for (Long newId : newIds) {
            RoleResource roleResource = new RoleResource();
            roleResource.setRole(role);
            roleResource.setResourceId(newId);
            roleResource.setDateCreated(date);
            list.add(roleResource);
        }
        roleResourceRepository.save(list);
    }

}
