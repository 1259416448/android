package cn.arvix.ontheway.sys.organization.service;

import cn.arvix.ontheway.ducuments.service.DocumentDirService;
import cn.arvix.ontheway.sys.auth.service.AuthService;
import cn.arvix.ontheway.sys.dto.AuthUserOrganizationDTO;
import cn.arvix.ontheway.sys.dto.CompanyCreateDTO;
import cn.arvix.ontheway.sys.dto.UserDTO;
import cn.arvix.ontheway.sys.organization.entity.Company;
import cn.arvix.ontheway.sys.organization.entity.Organization;
import cn.arvix.ontheway.sys.organization.entity.OrganizationType;
import cn.arvix.ontheway.sys.permission.entity.Role;
import cn.arvix.ontheway.sys.permission.entity.RoleType;
import cn.arvix.ontheway.sys.permission.service.RoleService;
import cn.arvix.ontheway.sys.shiro.token.AutoLoginToken;
import cn.arvix.ontheway.sys.user.entity.User;
import cn.arvix.ontheway.sys.user.entity.UserStatus;
import cn.arvix.ontheway.sys.user.entity.UserType;
import cn.arvix.ontheway.sys.user.repository.UserRepository;
import cn.arvix.ontheway.sys.user.service.UserService;
import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.HibernateValidationUtil;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.base.common.utils.MessageUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author Created by yangyang on 2017/3/27.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class CompanyService extends BaseServiceImpl<Company, Long> {


    private final UserRepository userRepository;

    private final OrganizationService organizationService;

    private final UserService userService;

    private final RoleService roleService;

    private final AuthService authService;

    private final DocumentDirService documentDirService;

    @Autowired
    public CompanyService(UserRepository userRepository,
                          OrganizationService organizationService,
                          UserService userService,
                          RoleService roleService,
                          AuthService authService,
                          DocumentDirService documentDirService) {
        this.userRepository = userRepository;
        this.organizationService = organizationService;
        this.userService = userService;
        this.roleService = roleService;
        this.authService = authService;
        this.documentDirService = documentDirService;
    }

    /**
     * 新用户创建一个公司或者团队
     * 创建成功后系统需要默认生成一个当前公司的角色，
     * 角色命名方式使用saas_companyId
     * 当前角色是需要进行授权管理
     *
     * @param username 用户名
     * @param dto      公司以及用户信息
     * @return 创建结果
     */
    @Transactional(rollbackFor = Exception.class)
    public JSONResult create(String username, CompanyCreateDTO dto) {
        String msg = HibernateValidationUtil.validateModel(dto).toString();
        if (!StringUtils.isEmpty(msg)) return JsonUtil.getFailure(MessageUtils.message(msg, null, msg), "option.error");
        User user = userRepository.findByUsername(username);
        if (user == null)
            return JsonUtil.getFailure(MessageUtils.message("user.not.find"), "user.not.find");
        if (!user.getStatus().equals(UserStatus.noteam))
            return JsonUtil.getFailure(MessageUtils.message("user.already.team"), "user.already.team");
        //执行自动登录方法 自动登录肯定保证登陆成功
        AutoLoginToken autoLoginToken = new AutoLoginToken(user.getUsername(), user.getPassword());
        SecurityUtils.getSubject().login(autoLoginToken);

        Company company = new Company();
        //user.setName(dto.getName());
        company.setName(dto.getCompanyName());
        company.setSumPeople(1);
        super.save(company);
        //创建组织机构
        Organization organization = new Organization();
        organization.setName(dto.getCompanyName());
        organization.setSorter(0.0f);
        organization.setType(OrganizationType.saas);
        organization.setShow(Boolean.TRUE);
        organization.setCompanyId(company.getId());
        organization.setCreater(user.getUsername());
        //外部设置部门公司信息
        organizationService.saveNoCompanyId(organization);
        //更新用户信息
        UserDTO userDTO = new UserDTO();
        user.setStatus(UserStatus.normal); //正常用户
        user.setUserType(UserType.saas); //公司创建者 saas用户
        user.setCompanyId(company.getId());
        userDTO.setUser(user);
        userDTO.setOrganizationIds(new Long[]{organization.getId()});
        userService.onLoginSuccess();
        userService.update_(userDTO);
        //创建角色
        Role role = new Role();
        role.setShow(Boolean.TRUE);
        role.setCompanyId(company.getId());
        role.setDescription(company.getName() + " 用户名称：" + user.getName());
        role.setName(company.getName());
        role.setRoleType(RoleType.saas);
        role.setRole("saas_" + company.getId());
        roleService.save(role);
        //创建角色分权 默认拥有日志、周志、任务权限，功能未添加功能


        //创建角色关联，角色关联直接与当前用户进行关联
        AuthUserOrganizationDTO authUserOrganizationDTO = new AuthUserOrganizationDTO();
        authUserOrganizationDTO.setUserIds(new Long[]{user.getId()});
        authUserOrganizationDTO.setRoleIds(new Long[]{role.getId()});
        authService.saveAuth(authUserOrganizationDTO);

        //初始化默认文库
        documentDirService.saasInit();

        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.SAVE_SUCCESS), CommonContact.SAVE_SUCCESS);
    }

    /**
     * 获取当前登陆用户的公司信息
     *
     * @return 公司信息 json
     */
    public JSONResult view() {
        Long cid = webContextUtils.getCompanyId();
        return super.findOne_(cid);
    }

}
