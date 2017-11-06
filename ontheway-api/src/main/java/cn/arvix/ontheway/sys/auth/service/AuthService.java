package cn.arvix.ontheway.sys.auth.service;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.entity.PageResult;
import cn.arvix.base.common.entity.search.PageRequest;
import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.base.common.utils.*;
import cn.arvix.ontheway.sys.auth.entity.Auth;
import cn.arvix.ontheway.sys.auth.entity.AuthType;
import cn.arvix.ontheway.sys.auth.repository.AuthRepository;
import cn.arvix.ontheway.sys.dto.AuthDataOneDTO;
import cn.arvix.ontheway.sys.dto.AuthUserOrganizationDTO;
import cn.arvix.ontheway.sys.organization.entity.Organization;
import cn.arvix.ontheway.sys.organization.repository.OrganizationRepository;
import cn.arvix.ontheway.sys.permission.entity.Role;
import cn.arvix.ontheway.sys.permission.entity.RoleType;
import cn.arvix.ontheway.sys.permission.repository.RoleRepository;
import cn.arvix.ontheway.sys.resource.repository.ResourceRepository;
import cn.arvix.ontheway.sys.user.entity.User;
import cn.arvix.ontheway.sys.user.entity.UserType;
import cn.arvix.ontheway.sys.user.repository.UserRepository;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.subject.PrincipalCollection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * @author Created by yangyang on 2017/3/19.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class AuthService extends BaseServiceImpl<Auth, Long> {

    private static final Logger log = LoggerFactory.getLogger(AuthService.class);


    @Autowired
    public AuthService(RoleRepository roleRepository,
                       ResourceRepository resourceRepository,
                       UserRepository userRepository,
                       OrganizationRepository organizationRepository) {
        this.roleRepository = roleRepository;
        this.resourceRepository = resourceRepository;
        this.userRepository = userRepository;
        this.organizationRepository = organizationRepository;
    }

    private AuthRepository getAuthRepository() {
        return (AuthRepository) baseRepository;
    }

    private final RoleRepository roleRepository;
    private final ResourceRepository resourceRepository;

    private final UserRepository userRepository;
    private final OrganizationRepository organizationRepository;

    /**
     * 保存授权信息
     * 1、处理用户授权
     * a、判断当前用户是否有授权信息，如果有添加新添加的角色
     * b、没有授权信息，直接添加新的授权信息
     * 2、处理组织机构（团队）授权信息，与用户授权逻辑相同
     * 不同saas用户的授权信息分开保存
     *
     * @param authUserOrganizationDTO 授权数据
     * @return 授权结果
     */
    public JSONResult saveAuth(AuthUserOrganizationDTO authUserOrganizationDTO) {
        if (authUserOrganizationDTO.getRoleIds() == null
                || authUserOrganizationDTO.getRoleIds().length == 0)
            return JsonUtil.getFailure("rIds is null", CommonContact.OPTION_ERROR);
        if (authUserOrganizationDTO.getUserIds() != null
                && authUserOrganizationDTO.getUserIds().length > 0) {
            for (Long uId : authUserOrganizationDTO.getUserIds()) {
                saveUserAuth(uId, authUserOrganizationDTO.getRoleIds());
            }
        }
        if (authUserOrganizationDTO.getOrganizationIds() != null
                && authUserOrganizationDTO.getOrganizationIds().length > 0) {
            for (Long oId : authUserOrganizationDTO.getOrganizationIds()) {
                saveOrganization(oId, authUserOrganizationDTO.getRoleIds());
            }
        }
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.AUTH_OPTION_SUCCESS),
                CommonContact.AUTH_OPTION_SUCCESS);
    }

    /**
     * 保存单条数据数据分权信息
     * //首先删除所有的分权数据
     * //再添加新的授权数据
     *
     * @param dto      分权信息
     * @param opModule 数据模块
     * @param opId     数据ID
     * @return 授权结果
     */
    @Transactional(rollbackFor = Exception.class)
    public JSONResult saveAuth(AuthDataOneDTO dto, Integer opModule, Long opId) {
        User user = webContextUtils.getCheckCurrentUser();
        //删除原来的分权数据信息
        getAuthRepository().deleteByOpModuleAndOpId(opModule, opId);
        //添加新的
        saveAuthOne(dto, opModule, opId);
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.OPTION_SUCCESS), CommonContact.OPTION_SUCCESS);
    }

    private void saveAuthOne(AuthDataOneDTO dto, Integer opModule, Long opId) {
        //添加新的
        if (dto.getUserIds() != null) {
            for (Long userId : dto.getUserIds()) {
                Auth newAuth = new Auth();
                newAuth.setType(AuthType.user);
                newAuth.setUserId(userId);
                newAuth.setOpModule(opModule);
                newAuth.setOpId(opId);
                newAuth.setOpType(dto.getOpType());
                super.save(newAuth);
            }
        }
        if (dto.getOrganizationIds() != null) {
            for (Long oId : dto.getOrganizationIds()) {
                Auth newAuth = new Auth();
                newAuth.setType(AuthType.organization_job);
                newAuth.setOrganizationId(oId);
                newAuth.setOpModule(opModule);
                newAuth.setOpId(opId);
                newAuth.setOpType(dto.getOpType());
                super.save(newAuth);
            }
        }
    }

    /**
     * 一次性创建多种操作类型的数据分权
     *
     * @param dtos     操作类型对应的dto
     * @param opModule 模块
     * @param opId     数据
     */
    @Transactional(rollbackFor = Exception.class)
    public JSONResult saveAuth(List<AuthDataOneDTO> dtos, Integer opModule, Long opId) {
        User user = webContextUtils.getCheckCurrentUser();
        //删除原来的分权数据信息
        getAuthRepository().deleteByOpModuleAndOpId(opModule, opId);
        if (dtos != null) {
            dtos.forEach(x -> saveAuthOne(x, opModule, opId));
        }
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.OPTION_SUCCESS), CommonContact.OPTION_SUCCESS);
    }

    /**
     * 保存一组用户角色授权
     *
     * @param uId  用户ID
     * @param rIds 角色ID 数组
     */
    public void saveUserAuth(Long uId, Long[] rIds) {
        Auth auth = getAuthRepository().findByUserIdAndCompanyId(uId);
        if (auth == null) {
            Auth newAuth = new Auth();
            newAuth.setType(AuthType.user);
            newAuth.setUserId(uId);
            for (Long rId : rIds) {
                newAuth.getRoleIds().add(rId);
            }
            save(newAuth);
        } else {
            for (Long rId : rIds) {
                auth.getRoleIds().add(rId);
            }
            update(auth);
        }
    }

    /**
     * 保存一组组织机构（团队）授权
     *
     * @param oId  组织机构（团队）ID
     * @param rIds 角色ID 数组
     */
    public void saveOrganization(Long oId, Long[] rIds) {
        Auth auth = getAuthRepository().findByOrganizationIdAndCompanyId(oId);
        if (auth == null) {
            Auth newAuth = new Auth();
            newAuth.setType(AuthType.organization_job);//这里暂时未加入职务概念
            newAuth.setOrganizationId(oId);
            for (Long rId : rIds) {
                newAuth.getRoleIds().add(rId);
            }
            save(newAuth);
        } else {
            for (Long rId : rIds) {
                auth.getRoleIds().add(rId);
            }
            update(auth);
        }
    }

    /**
     * 或分权信息列表
     *
     * @param q         查询参数
     * @param number    当前页
     * @param size      每页大小
     * @param direction 排序方式
     * @param order     排序字段
     * @return 查询结果
     */
    @RequiresPermissions(value = CommonPermission.SYSTEM_AUTH_AND_ROLE)
    public JSONResult search(String q, Integer number, Integer size, Sort.Direction direction, String order) {

        Sort sort = null;
        if (direction != null && order != null) {
            sort = new Sort(direction, order);
        }

        Searchable searchable = Searchable.newSearchable(null, new PageRequest(number, size), sort);
        if (!StringUtils.isEmpty(q)) {
            searchable.addSearchParam("q", q);
        }

        Page<Auth> page = getAuthRepository().findAll(searchable);
        //抓取其他关联数据
        List<Auth> authList = page.getContent();
        List<Map<String, Object>> jsonList = Lists.newArrayList();
        if (authList.size() > 0) {
            for (Auth auth : authList) {
                Map<String, Object> jsonMap = Maps.newHashMap();
                if (auth.getType().equals(AuthType.user)) {
                    User user = userRepository.findOne(auth.getUserId());
                    if (user == null) continue;
                    jsonMap.put("name", user.getName());
                } else if (auth.getType().equals(AuthType.organization_job)) {
                    Organization organization = organizationRepository.findOne(auth.getOrganizationId());
                    if (organization == null) continue;
                    jsonMap.put("name", organization.getName());
                }
                jsonMap.put("type", MessageUtils.message(auth.getType().toString()));
                //加载角色信息
                List<Role> roleList = Lists.newArrayList();
                for (Long rId : auth.getRoleIds()) {
                    Role role = roleRepository.findOne(rId);
                    if (role == null) continue;
                    roleList.add(role);
                }
                if (roleList.size() == 0) continue;
                //如果一条权限信息中，只有一个saas角色 当前信息不允许删除
                if (roleList.size() == 1 && roleList.get(0).getRoleType().equals(RoleType.saas)) {
                    jsonMap.put("notDelete", true);
                }
                jsonMap.put("role", JsonUtil.getBaseEntityMapList(roleList));
                jsonMap.put("id", auth.getId());
                jsonMap.put("creater", auth.getCreater());
                jsonMap.put("dateCreated", TimeMaker.toDateTimeStr(auth.getDateCreated()));
                jsonList.add(jsonMap);
            }
        }
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.FETCH_SUCCESS),
                CommonContact.FETCH_SUCCESS, new PageResult<>(jsonList, searchable.getPage(), page.getTotalElements()));
    }

    /**
     * 获取当前用户登陆权限信息
     * 登陆成功后，realm 会调用此方法
     * 1、获取当前用户授权的所有角色
     * 2、获取当前角色的所有操作权限
     *
     * @return @{@link AuthorizationInfo}
     */
    public AuthorizationInfo getAuth(PrincipalCollection principalCollection, String name) {
        Collection collection = principalCollection.fromRealm(name);
        String principal;
        if (collection.size() > 0) {
            principal = collection.iterator().next().toString();
        } else return null;
        log.info("start get AuthorizationInfo realm name:{}", name);
        SimpleAuthorizationInfo info = new SimpleAuthorizationInfo();
        //通过用户凭证（用户名）获取用户信息
        User user = webContextUtils.getCurrentUser(principal);
        List<String> roles;
        List<String> permissions;
        //如果当前用户类型为开发者，这里直接获取所有权限和所有角色。
        if (UserType.dev.equals(user.getUserType())) {
            roles = roleRepository.findRole();
            permissions = resourceRepository.findIdentity();
        } else {
            //1、获取用户角色
            Set<Long> organizationIds = Sets.newHashSet();
            user.getOrganizationJobs().forEach(x -> organizationIds.add(x.getOrganization().getId()));
            Set<Long> roleIds = getAuthRepository().findRoleIds(user.getId(), null, organizationIds, null, null);
            //通过角色ID获取角色名称
            roles = roleRepository.findRoleByIds(roleIds);
            //2、获取用户权限
            permissions = resourceRepository.findIdentityByRoleIds(roleIds);
        }
        if (roles != null) {
            info.addRoles(roles);
        }
        if (permissions != null) {
            info.addStringPermissions(permissions);
        }
        return info;
    }

    /**
     * 获取当前用户所拥有的所有角色
     *
     * @return 角色ID 数组
     */
    public Set<Long> getRoleIds() {
        User user = webContextUtils.getCheckCurrentUser();
        Set<Long> organizationIds = Sets.newHashSet();
        user.getOrganizationJobs().forEach(x -> organizationIds.add(x.getOrganization().getId()));
        return getAuthRepository().findRoleIds(user.getId(), null, organizationIds, null, null);
    }

    /**
     * 更新某个分权的角色
     * saas用户的 saas角色权限不允许移除
     *
     * @param id  权限ID
     * @param rId 角色ID
     * @return 分权结果
     */
    public JSONResult updateRole(Long id, Long rId) {
        Auth auth = super.findOne(id);
        //saas用户权限 saas用户的 saas角色权限不允许移除
        if (auth.getType().equals(AuthType.user)) {
            Role role = roleRepository.findOne(rId);
            if (role.getRoleType().equals(RoleType.saas))
                return JsonUtil.getFailure(MessageUtils.message(CommonContact.OPTION_ERROR), CommonContact.OPTION_SUCCESS);
        }
        auth.getRoleIds().remove(rId);
        //如果当前数据已经没有其他角色信息了 直接删除掉
        if (auth.getRoleIds().size() == 0) {
            return super.delete_(id);
        }
        super.update(auth);
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.DELETE_SUCCESS), CommonContact.DELETE_SUCCESS);
    }

    /**
     * 授权初始化，异步获取所有用户、所有团队、所有自定义的角色信息
     *
     * @return 初始化数据
     */
    @RequiresPermissions(value = CommonPermission.SYSTEM_AUTH_AND_ROLE)
    public JSONResult createInit() {
        Map<String, Object> params = Maps.newHashMap();
        //根据当前用户类型增加一些查询参数
        User user = webContextUtils.getCheckCurrentUser();
        //所有角色
        List<Role> roles = roleRepository.findAll(Searchable.newSearchable(params)).getContent();
        params.remove("roleType_eq");
        params.put("deleted_eq", false);
        List<User> users = userRepository.findAll(Searchable.newSearchable(params)).getContent();
        params.remove("deleted_eq");
        List<Organization> organizations = organizationRepository.findAll(Searchable.newSearchable(params)).getContent();
        params.put("roles", JsonUtil.getBaseEntityMapList(roles));
        params.put("users", JsonUtil.getBaseEntityMapList(users));
        params.put("organizations", JsonUtil.getBaseEntityMapList(organizations));
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.FETCH_SUCCESS), CommonContact.FETCH_SUCCESS, params);
    }

    /**
     * 获取某一条数据的初始化分权信息
     *
     * @param opModule 数据所在模块
     * @param opId     数据ID
     * @return 数据格式body  {userIds:[],organizationIds:[]}
     */
    public JSONResult createInit(Integer opModule, Long opId) {
        User user = webContextUtils.getCheckCurrentUser();
        List<Auth> list = getAuthRepository().fromByOpModuleAndOpId(opModule, opId);
        List<Object> jsonList = Lists.newArrayList();
        if (list != null) {
            //先分组
            list.stream().collect(Collectors.groupingBy(Auth::getOpType))
                    .forEach((key, value) -> {
                        Map<String, Object> jsonMap = Maps.newHashMap();
                        Set<Long> userIds = Sets.newHashSet();
                        Set<Long> organizationIds = Sets.newHashSet();
                        value.stream().filter(x -> AuthType.user.equals(x.getType()))
                                .forEach(x -> userIds.add(x.getUserId()));
                        value.stream().filter(x -> AuthType.organization_job.equals(x.getType()))
                                .forEach(x -> organizationIds.add(x.getOrganizationId()));
                        jsonMap.put("opType", key);
                        jsonMap.put("userIds", userIds);
                        jsonMap.put("organizationIds", organizationIds);
                        jsonList.add(jsonMap);
                    });
        }
        Map<String, Object> params = Maps.newHashMap();
        params.put("deleted_eq", false);
        List<User> users = userRepository.findAll(Searchable.newSearchable(params)).getContent();
        params.remove("deleted_eq");
        List<Organization> organizations = organizationRepository.findAll(Searchable.newSearchable(params)).getContent();
        params.clear();
        params.put("users", JsonUtil.getBaseEntityMapList(users));
        params.put("organizations", JsonUtil.getBaseEntityMapList(organizations));
        params.put("data", jsonList);
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.FETCH_SUCCESS), CommonContact.FETCH_SUCCESS, params);
    }

    /**
     * 删除 这里不能删除用户的saas角色。
     *
     * @param id 主键
     * @return 删除结果
     */
    public JSONResult delete_(Long id) {
        return super.delete_(id);
    }

    public JSONResult delete_(Long[] ids) {
        for (Long id : ids) {
            this.delete_(id);
        }
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.DELETE_MORE_SUCCESS),
                CommonContact.DELETE_MORE_SUCCESS);
    }

    /**
     * 通过用户ID和公司ID删除满足条件的角色分派数据
     *
     * @param uid 用户ID
     */
    public void deleteByUserIdAndCompanyId(Long uid) {
        getAuthRepository().deleteByUserIdAndCompanyId(uid);
    }

    /**
     * 通过opId获取当前用户对这些opId的操作权限
     *
     * @param longSet  数据ID
     * @param user     当前用户
     * @param opModule 对应模块
     */
    public Map<Long, Integer> getOpTypeByOpIds(Set<Long> longSet, Integer opModule, User user) {
        List<Object[]> list = getAuthRepository().findByOpTypeByOpIds(longSet, opModule);
        Map<Long, Integer> opTypeMap = Maps.newHashMap();
        if (list != null) {
            list.forEach(x -> opTypeMap.put(Checks.toLong(String.valueOf(x[0])),
                    Checks.toInteger(String.valueOf(x[1]))));
        }
        return opTypeMap;
    }

    /**
     * 操作权限使用int表示，如果存在多个分权，这里取最高操作权限
     *
     * @param opId     数据ID
     * @param opModule 数据模块
     * @param user     当前用户
     * @return 最高操作权限
     */
    public Integer getOpTypeByOpId(Long opId, Integer opModule, User user) {
        List<Auth> authList = getAuthRepository()
                .findByOpTypeByOpId(user.getId(), user.getOrganizationIds(), opId, opModule);
        Integer authOpType = -1;
        if (authList != null) {
            for (Auth auth : authList) {
                if (auth.getOpType() > authOpType) {
                    authOpType = auth.getOpType();
                }
            }
        }
        return authOpType;
    }

}
