package cn.arvix.ontheway.sys.resource.service;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.base.common.utils.*;
import cn.arvix.ontheway.sys.auth.service.AuthService;
import cn.arvix.ontheway.sys.permission.repository.RoleResourceRepository;
import cn.arvix.ontheway.sys.resource.entity.Resource;
import cn.arvix.ontheway.sys.resource.entity.ResourceType;
import cn.arvix.ontheway.sys.resource.repository.ResourceRepository;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * @author Created by yangyang on 2017/3/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class ResourceService extends BaseServiceImpl<Resource, Long> {

    private final RoleResourceRepository roleResourceRepository;

    private final AuthService authService;

    @Autowired
    public ResourceService(RoleResourceRepository roleResourceRepository,
                           AuthService authService) {
        this.roleResourceRepository = roleResourceRepository;
        this.authService = authService;
    }

    private ResourceRepository getResourceRepository() {
        return (ResourceRepository) baseRepository;
    }

    /**
     * 添加一个组织机构
     *
     * @param m 实体
     * @return 添加结果
     */
    @Override
    public JSONResult save_(Resource m) {
        modify(m);
        return super.save_(m);
    }

    private void modify(Resource m) {
        //设置父节点IDs
        if (m.getParentId() != null) {
            Resource parent = findOne(m.getParentId());
            if (parent != null) {
                m.setParentIds(StringUtils.isEmpty(parent.getParentIds()) ?
                        parent.getSeparator() + parent.getId().toString() + parent.getSeparator() :
                        parent.getParentIds() + parent.getId() + parent.getSeparator());
            }
        }
    }

    /**
     * 修改一个资源信息
     *
     * @param m 实体
     * @return 修改结果
     */
    public JSONResult update_(Resource m) {
        modify(m);
        return super.update_(m);
    }

    /**
     * 获取所有树结构数据，这里不允许user类型用户访问
     *
     * @return ztree json 数据
     */
    @SuppressWarnings("unchecked")
    public JSONResult tree(Long rId) {
        if (!SecurityUtils.getSubject().isPermitted(CommonPermission.SYSTEM_AUTH_AND_ROLE))
            return JsonUtil.getFailure(MessageUtils.message(CommonContact.NO_PERMISSION), CommonContact.NO_PERMISSION);
        Map<String, Object> params = Maps.newHashMap();
        List<Long> resourceIds = null;
        if (rId != null) {
            resourceIds = roleResourceRepository.findResourceIdWithRoleId(rId);
            params.put("show_eq", Boolean.TRUE);
        }
        Searchable searchable = Searchable.newSearchable(params, new Sort(Sort.Direction.ASC, "sorter"));
        List<Resource> resourceList = findAllWithSort(searchable);
        List<?> jsonList = JsonUtil.getBaseEntityMapList(resourceList);
        //增加选中节点
        if (resourceIds != null && resourceIds.size() > 0) {
            Set<Long> checkedSet = Sets.newHashSet();
            resourceIds.forEach(checkedSet::add);
            jsonList.forEach(x -> {
                Map<String, Object> map = (Map<String, Object>) x;
                map.put("checked", checkedSet.contains(Checks.toLong(String.valueOf(map.get("id")))));
            });
        }
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.FETCH_SUCCESS),
                CommonContact.FETCH_SUCCESS, jsonList);
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
        deleteOne(id);
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
     * 删除一个资源
     * 1、检查是否拥有下级
     *
     * @param id 主键
     */
    private void deleteOne(Long id) {
        List<Resource> list = getResourceRepository().findByParentId(id);
        if (list != null && list.size() > 0) {
            for (Resource one : list) {
                deleteOne(one.getId());
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
        Map<String, Object> params = Maps.newHashMap();
        params.put("resourceType_eq", ResourceType.column);
        List<Resource> resourceList = findAllWithSort(Searchable.newSearchable(params,
                new Sort(Sort.Direction.ASC, "sorter")));
        List<Map<String, Object>> selectList = Lists.newArrayList();
        if (resourceList != null && resourceList.size() > 0) {
            if (id != null) {
                resourceList = resourceList.stream().filter(x -> !(x.getId().equals(id)
                        || (x.getParentIds() != null && x.getParentIds().contains(x.getSeparator() + id + x.getSeparator()))))
                        .collect(Collectors.toList());
            }
            if (resourceList.size() > 0) {
                resourceList.forEach(x -> {
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
     * 根据当前登陆用户获取管理端栏目
     * 权限系统暂时没有开发完成，后期集成分权获取栏目信息
     */
    public JSONResult adminColumn() {
        Map<String, Object> params = Maps.newHashMap();
        params.put("show_eq", Boolean.TRUE);
        params.put("beforeShow_eq", Boolean.FALSE);
        params.put("resourceType_eq", ResourceType.column);
        Searchable searchable = Searchable.newSearchable(params, new Sort(Sort.Direction.ASC, "sorter"));
        //加入sql分权查询
        if (!webContextUtils.ifDevUser()) {
            searchable.addSearchParam("roleIds", authService.getRoleIds());
        }
        List<Resource> resourceList = findAllWithSort(searchable);
        //目前只使用2级
        List<Map<String, Object>> list = Lists.newArrayList();
        if (resourceList != null) {
            resourceList.stream().filter(x -> x.getParentId() == null).forEach(x -> {
                Map<String, Object> map = x.toMap();
                List<Map<String, Object>> list1 = Lists.newArrayList();
                resourceList.stream().filter(r -> Objects.equals(r.getParentId(), x.getId()))
                        .forEach(r -> list1.add(r.toMap()));
                map.put("son", list1);
                list.add(map);
            });
        }
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.FETCH_SUCCESS),
                CommonContact.FETCH_SUCCESS, list);
    }

    //根据当前用户获取类型为button的授权信息
    public JSONResult auth() {
        List<String> identityList = getResourceRepository().findIdentityByRoleIds(authService.getRoleIds());
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.FETCH_SUCCESS), CommonContact.FETCH_SUCCESS, identityList);
    }

}
