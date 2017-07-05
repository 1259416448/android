package cn.arvix.ontheway.sys.user.service;

import cn.arvix.ontheway.sys.auth.service.AuthService;
import cn.arvix.ontheway.sys.config.service.ConfigService;
import cn.arvix.ontheway.sys.dto.*;
import cn.arvix.ontheway.sys.organization.entity.Organization;
import cn.arvix.ontheway.sys.organization.service.OrganizationService;
import cn.arvix.ontheway.sys.shiro.web.mgt.HeaderRememberMeManager;
import cn.arvix.ontheway.sys.user.entity.*;
import cn.arvix.ontheway.sys.user.exception.UserException;
import cn.arvix.ontheway.sys.user.repository.UserOrganizationJobRepository;
import cn.arvix.ontheway.sys.user.repository.UserRepository;
import cn.arvix.ontheway.sys.utils.Email;
import cn.arvix.ontheway.sys.utils.EndecryptUtils;
import cn.arvix.ontheway.sys.utils.RegExpValidatorUtils;
import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.entity.search.PageRequest;
import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.entity.search.filter.SearchFilter;
import cn.arvix.base.common.entity.search.filter.SearchFilterHelper;
import cn.arvix.base.common.repository.hibernate.HibernateUtils;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.base.common.utils.MessageUtils;
import cn.arvix.base.common.utils.TimeMaker;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.redisson.api.RBucket;
import org.redisson.api.RedissonClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * @author Created by yangyang on 2017/3/8.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class UserService extends BaseServiceImpl<User, Long> {


    private final UserOrganizationJobRepository userOrganizationJobRepository;

    private final OrganizationService organizationService;

    private final ConfigService configService;

    private final RedissonClient redissonClient;

    private final Email emailSender;

    private HeaderRememberMeManager rememberMeManager;

    @Autowired
    public void setRememberMeManager(HeaderRememberMeManager rememberMeManager) {
        this.rememberMeManager = rememberMeManager;
    }

    private UserOrganizationRecordsService userOrganizationRecordsService;

    private AuthService authService;

    @Autowired
    public void setAuthService(AuthService authService) {
        this.authService = authService;
    }

    @Autowired
    public void setUserOrganizationRecordsService(UserOrganizationRecordsService userOrganizationRecordsService) {
        this.userOrganizationRecordsService = userOrganizationRecordsService;
    }

    @PersistenceContext
    private EntityManager entityManager;

    private final Cache authCache;

    @Autowired
    public UserService(UserOrganizationJobRepository userOrganizationJobRepository,
                       OrganizationService organizationService,
                       CacheManager cacheManager, ConfigService configService,
                       RedissonClient redissonClient,
                       Email emailSender) {
        this.userOrganizationJobRepository = userOrganizationJobRepository;
        this.organizationService = organizationService;
        this.authCache = cacheManager.getCache(CommonContact.X_AUTH_TOKEN_CACHE);
        this.configService = configService;
        this.redissonClient = redissonClient;
        this.emailSender = emailSender;
    }

    private UserRepository getUserRepository() {
        return (UserRepository) baseRepository;
    }

    /**
     * 用户数据处理， 添加组织机构等
     *
     * @param userDTO 用户信息
     */
    @Transactional(rollbackFor = Exception.class)
    public JSONResult save_(UserDTO userDTO) {
        Assert.notNull(userDTO.getUser(), "user is not null");
        //需要先保存用户信息
        JSONResult jsonResult = save_(userDTO.getUser());
        if (!jsonResult.ifSuccess()) return jsonResult;
        try {
            updateOrganization(userDTO);
        } catch (IllegalAccessException e) {
            e.printStackTrace();
            return JsonUtil.getFailure(e.getMessage(), CommonContact.SERVICE_ERROR_CODE);
        }
        return jsonResult;
    }

    /**
     * 用户信息修改
     * 修改用户所有信息以及组织机构（团队信息）
     *
     * @param userDTO 用户信息
     * @return 修改结果
     */
    @Transactional(rollbackFor = Exception.class)
    public JSONResult update_(UserDTO userDTO) {
        Assert.notNull(userDTO.getUser(), "user is not null");
        JSONResult jsonResult = update_(userDTO.getUser());
        if (!jsonResult.ifSuccess()) return jsonResult;
        try {
            updateOrganization(userDTO);
        } catch (IllegalAccessException e) {
            e.printStackTrace();
            return JsonUtil.getFailure(e.getMessage(), CommonContact.SERVICE_ERROR_CODE);
        }
        //手动清理一下集合缓存
        HibernateUtils.evictLevel2CollectionRegions(entityManager);
        return jsonResult;
    }

    /**
     * 移除或者添加某个用户的某个组织机构或者团队
     *
     * @return 移除结果
     */
    @Transactional(rollbackFor = Exception.class)
    public JSONResult removeOrAddOrganization(Long uId, Long oId) {
        if (uId != null && oId != null) {
            UserOrganizationJob userOrganizationJob = userOrganizationJobRepository.findByUserIdAndOrganizationId(uId, oId);
            if (userOrganizationJob != null) {
                userOrganizationJobRepository.deleteByUserIdAndOrganizationIdIn(uId,
                        new Long[]{userOrganizationJob.getOrganization().getId()});
                //手动清理一下集合缓存
                HibernateUtils.evictLevel2CollectionRegions(entityManager);
                return JsonUtil.getSuccess(MessageUtils.message(CommonContact.DELETE_SUCCESS),
                        CommonContact.DELETE_SUCCESS);
            } else {
                User user = findOne(uId);
                saveUserOrganization(user, new Long[]{oId});
                super.update(user);
                //手动清理一下集合缓存
                HibernateUtils.evictLevel2CollectionRegions(entityManager);
                return JsonUtil.getSuccess(MessageUtils.message(CommonContact.SAVE_SUCCESS),
                        CommonContact.SAVE_SUCCESS);
            }
        }
        return JsonUtil.getFailure(MessageUtils.message(CommonContact.OPTION_ERROR), CommonContact.OPTION_ERROR);
    }

    /*
    用户添加
     */
    @Transactional(rollbackFor = Exception.class)
    public JSONResult save_(User m) {
        String msg;
        try {
            msg = checkUser(m);
        } catch (IllegalAccessException e) {
            e.printStackTrace();
            return JsonUtil.getFailure(e.getMessage(), CommonContact.SERVICE_ERROR_CODE);
        }
        if (msg != null) return JsonUtil.getFailure(MessageUtils.message(msg), msg);
        //设置密码信息
        EndecryptUtils.md5Password(m);
        return super.save_(m);
    }

    /**
     * 更新Organization 关系，目前不加入职务概览 以后有需求在加入
     * 1、获取用户当前所属组织机构（团队）
     * 2、删掉去掉的
     * 3、增加新添加的
     */
    private void updateOrganization(UserDTO userDTO) throws IllegalAccessException {
        if (userDTO.getOrganizationIds() != null && userDTO.getOrganizationIds().length > 0) {
            if (userDTO.getUser().getId() == null) {
                //直接添加
                saveUserOrganization(userDTO.getUser(), userDTO.getOrganizationIds());
            } else {
                List<Long> oldOrganizationIds = userOrganizationJobRepository.findOrganizationIdByUserId(userDTO.getUser().getId());
                List<Long> newList = Lists.newArrayList(userDTO.getOrganizationIds());
                if (oldOrganizationIds != null && oldOrganizationIds.size() > 0) {
                    newList.removeAll(oldOrganizationIds);
                    //删除旧的
                    oldOrganizationIds.removeAll(Arrays.asList(userDTO.getOrganizationIds()));
                    if (oldOrganizationIds.size() > 0) {
                        userOrganizationJobRepository.deleteByUserIdAndOrganizationIdIn(userDTO.getUser().getId(),
                                oldOrganizationIds.toArray(new Long[oldOrganizationIds.size()]));
                    }
                }
                //添加新的
                if (newList.size() > 0) {
                    saveUserOrganization(userDTO.getUser(),
                            newList.toArray(new Long[newList.size()]));
                }
            }
        } else throw new IllegalAccessException("user.organization.is.not.null");

    }

    //保存关系
    private void saveUserOrganization(User user, Long[] organizationIds) {
        List<UserOrganizationJob> list = Lists.newArrayList();
        Date date = TimeMaker.nowSqlDate();
        User currentUser = webContextUtils.getCheckCurrentUser();
        //创建用户
        for (Long organizationId : organizationIds) {
            UserOrganizationJob userOrganizationJob = new UserOrganizationJob(organizationId, null);
            userOrganizationJob.setUser(user);
            userOrganizationJob.setDateCreated(date);
            userOrganizationJob.setCompanyId(currentUser.getCompanyId());
            list.add(userOrganizationJob);
        }
        userOrganizationJobRepository.save(list);
    }

    /**
     * 用户修改，不能修改用户密码、用户名，用户密码只能通过重置和用户自己修改
     *
     * @param m 实体
     * @return 修改结果
     */
    @Transactional(rollbackFor = Exception.class)
    public JSONResult update_(User m) {
        String msg;
        try {
            msg = checkUser(m);
        } catch (IllegalAccessException e) {
            e.printStackTrace();
            return JsonUtil.getFailure(e.getMessage(), CommonContact.SERVICE_ERROR_CODE);
        }
        if (msg != null) return JsonUtil.getFailure(MessageUtils.message(msg), msg);
        //设置不允许修改的信息
        User oldUser = findOne(m.getId());
        m.setUsername(oldUser.getUsername());
        m.setPassword(oldUser.getPassword());
        m.setCreater(oldUser.getCreater());
        m.setDateCreated(oldUser.getDateCreated());
        m.setSalt(oldUser.getSalt());
        m.setHeadImg(oldUser.getHeadImg());
        m.setHeadImgYuan(oldUser.getHeadImgYuan());
        m.setCompanyId(oldUser.getCompanyId());
        m.setOrganizationJobs(oldUser.getOrganizationJobs());
        return super.update_(m);
    }

    /**
     * 允许通过q : username email mobilePhoneNumber进行检索，不支持模糊搜索<br/>
     * name : 通过name字段模糊检索<br/>
     * oId : 组织机构（团队）ID 如果当前值==0，默认获取当前用户所属组织机构（团队）下的所有用户 <br/>
     * 如果 number（当前页传入数据为-1，查询时不分页按条件排序检索）
     *
     * @param q         检索条件
     * @param name      姓名
     * @param oId       组织机构（团队）ID
     * @param number    当前页
     * @param size      每页大小
     * @param direction 排序方式
     * @param order     排序字段
     */
    public JSONResult search(String q, String name, Long oId,
                             Integer number, Integer size, Sort.Direction direction, String order) {
        Sort sort = null;
        if (direction != null && order != null) {
            sort = new Sort(direction, order);
        }
        Searchable searchable = Searchable.newSearchable(null, number == -1 ? null : new PageRequest(number, size), sort).setEnableToMap(true);
        if (!StringUtils.isEmpty(q)) {
            SearchFilter searchFilter = SearchFilterHelper.newCondition("username_eq", q);
            SearchFilter searchFilter1 = SearchFilterHelper.newCondition("email_eq", q);
            SearchFilter searchFilter2 = SearchFilterHelper.newCondition("mobilePhoneNumber_eq", q);
            searchable.or(searchFilter, searchFilter1, searchFilter2);
        }
        if (!StringUtils.isEmpty(name)) {
            SearchFilter searchFilter = SearchFilterHelper.newCondition("name_like", name);
            searchable.and(searchFilter);
        }
        Organization organization = null;
        if (oId == null || oId == 0) {
            //获取当前登陆用户的 organization
        } else {
            organization = organizationService.findOne(oId);
        }
        searchable.addSearchParam("organization", organization);
        SearchFilter searchFilter3 = SearchFilterHelper.newCondition("deleted_eq", Boolean.FALSE);
        searchable.and(searchFilter3);
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.FETCH_SUCCESS),
                CommonContact.FETCH_SUCCESS, number == -1 ? findAllWithSort(searchable) : findAll(searchable));
    }

    /**
     * 用户注册
     * 这里添加的用户都是未激活用户，用户类型都为普通用户类型
     * 这里将生成一个uuid作为当前用户的用户名
     *
     * @param dto 注册数据
     * @return 注册结果
     */
    public JSONResult register(RegisterDTO dto) {
        if (StringUtils.isEmpty(dto.getUsername())) return JsonUtil.getFailure("username.is.null", "username.is.null");
        if (StringUtils.isEmpty(dto.getName())) return JsonUtil.getFailure("name.is.null", "name.is.null");
        if (StringUtils.isEmpty(dto.getPassword())) return JsonUtil.getFailure("password.is.null", "password.is.null");
        User user = new User();
        user.setUsername(UUID.randomUUID().toString().replace("-", ""));
        user.setName(dto.getName());
        user.setStatus(UserStatus.unactivated);
        user.setUserType(UserType.user);
        if (RegExpValidatorUtils.match(User.MOBILE_PHONE_NUMBER_PATTERN, dto.getUsername())) {
            user.setMobilePhoneNumber(dto.getUsername());
        } else if (RegExpValidatorUtils.match(User.EMAIL_PATTERN, dto.getUsername())) {
            user.setEmail(dto.getUsername());
        } else return JsonUtil.getFailure("username.is.error", "username.is.error");
        user.setPassword(dto.getPassword());
        JSONResult jsonResult = save_(user);
        if (!jsonResult.ifSuccess()) return jsonResult;
        //如果邮箱注册方式，这里需要发送激活邮件
        if (!StringUtils.isEmpty(user.getEmail())) {
            sendActivationEmail(user.getUsername());
        }
        return jsonResult;
    }

    /**
     * 发送激活邮件
     *
     * @param username 用户名
     * @return 发送结果
     */
    public JSONResult sendActivationEmail(String username) {
        User user = getUserRepository().findByUsername(username);
        if (user == null || StringUtils.isEmpty(user.getEmail()))
            return JsonUtil.getFailure(MessageUtils.message("user.not.find"), "user.not.find");
        RBucket<EmailDTO> bucket = redissonClient.getBucket(getActivationKey(username));
        EmailDTO email = bucket.get();
        if (email == null) { //不存在，重新发送
            email = new EmailDTO();
            email.setEmailType(EmailDTO.EmailType.activation);
            email.setEmail(user.getEmail());
            email.setContent(UUID.randomUUID().toString().replace("-", ""));
        }
        //获取激活邮件内容 前端路由 /mail/{username}
        String content = configService.getConfigString(CommonContact.SAAS_USER_ACTIVATION_EMAIL);
        Date now = TimeMaker.nowSqlDate();
        content = content.replace(CommonContact.EMAIL_DATE, TimeMaker.toDateTimeStr(now))
                .replace(CommonContact.EMAIL_ACTIVATION_URL, getActivationMailUrl(username, email.getContent()));
        email.setDate(now.getTime());
        //激活邮件有效时间
        String[] time = configService.getConfigString(CommonContact.SENT_EMAIL_TTL_TIME).split("-");
        bucket.set(email, Long.valueOf(time[0]), TimeUnit.valueOf(time[1]));
        //发送邮件
        //如果是测试模式下，这里的邮件都指定发送到一个配置的邮箱中

        if (webContextUtils.ifTest()) {
            emailSender.sendSimpleEmail("账号激活", content,
                    configService.getConfigString(CommonContact.TEST_SENT_EMAIL_APPOINT),
                    Boolean.TRUE);
        } else {
            emailSender.sendSimpleEmail("账号激活", content, email.getEmail(), Boolean.TRUE);
        }
        return JsonUtil.getSuccess(MessageUtils.message("activation.mail.sent.success"), "activation.mail.sent.success");
    }

    /**
     * 激活账号
     *
     * @param username 用户名
     * @return 激活结果
     */
    public JSONResult activationEmail(String username, String uuid) {
        User user = getUserRepository().findByUsername(username);
        if (user == null || StringUtils.isEmpty(user.getEmail()))
            return JsonUtil.getFailure(MessageUtils.message("user.not.find"), "user.not.find");
        //判断是否发送激活邮件
        if (!user.getStatus().equals(UserStatus.unactivated))
            return JsonUtil.getFailure(MessageUtils.message("activation.mail.already"), "activation.mail.already");
        RBucket<EmailDTO> bucket = redissonClient.getBucket(getActivationKey(username));
        EmailDTO email = bucket.get();
        if (email == null || !Objects.equals(email.getContent(), uuid))
            return JsonUtil.getFailure(MessageUtils.message("activation.mail.error"), "activation.mail.error");
        //账号激活，账号目前没有团队
        user.setStatus(UserStatus.noteam);
        super.update(user);
        redissonClient.getKeys().delete(getActivationKey(username));
        return JsonUtil.getSuccess(MessageUtils.message("activation.mail.success"), "activation.mail.success", username);
    }

    /**
     * 发送找回密码验证邮件
     *
     * @param username 登陆邮箱
     * @return 发送结果
     */
    public JSONResult forgetEmail(String username) {
        User user = getUserRepository().findByEmail(username);
        if (user == null) return JsonUtil.getFailure(MessageUtils.message("user.not.find"), "user.not.find");
        RBucket<EmailDTO> bucket = redissonClient.getBucket(getForgetKey(username));
        EmailDTO email = bucket.get();
        if (email == null) { //不存在，重新发送
            email = new EmailDTO();
            email.setEmail(user.getEmail());
            email.setEmailType(EmailDTO.EmailType.activation);
            email.setContent(getVerificationCode());
        }
        String content = configService.getConfigString(CommonContact.USER_FORGET_PASS_EMAIL);
        Date now = TimeMaker.nowSqlDate();
        content = content.replace(CommonContact.EMAIL_DATE, TimeMaker.toDateTimeStr(now))
                .replace(CommonContact.EMAIL_CHECK_CODE, email.getContent());
        email.setDate(now.getTime());
        //激活邮件有效时间
        String[] time = configService.getConfigString(CommonContact.SENT_EMAIL_TTL_TIME).split("-");
        bucket.set(email, Long.valueOf(time[0]), TimeUnit.valueOf(time[1]));
        //发送邮件
        emailSender.sendSimpleEmail("找回密码", content, email.getEmail(), Boolean.TRUE);
        return JsonUtil.getSuccess(MessageUtils.message("code.sent.success"), "code.sent.success");
    }

    //获取激活邮件点击url
    private String getActivationMailUrl(String username, String uuid) {
        return configService.getConfigString(CommonContact.HTML_SERVER_BASE_PATH) + "register/check?u=" + username + "&hash=" + uuid;
    }

    //获取一个4位验证码
    private String getVerificationCode() {
        Random random = new Random();
        int x = random.nextInt(9000) + 1000;
        return String.valueOf(x);
    }

    //获取激活邮件key
    private String getActivationKey(String username) {
        return username + '-' + EmailDTO.EmailType.activation;
    }

    //获取忘记密码邮件key
    private String getForgetKey(String username) {
        return username + '-' + EmailDTO.EmailType.forget;
    }

    /**
     * 验证用户名是否可用
     * 可以直接验证手机号、email等用户名
     *
     * @param username 待验证用户名
     * @return 验证结果
     */
    public JSONResult checkUsername(String username) {
        String msg = null;
        if (StringUtils.isEmpty(username)) {
            msg = "username.is.null";
        } else {
            if (RegExpValidatorUtils.match(User.MOBILE_PHONE_NUMBER_PATTERN, username)) {//手机号码
                if (getUserRepository().findByMobilePhoneNumber(username) != null) {
                    msg = "mobilePhoneNumber.exist";
                }
            } else if (RegExpValidatorUtils.match(User.EMAIL_PATTERN, username)) { //邮箱
                if (getUserRepository().findByEmail(username) != null) {
                    msg = "email.exist";
                }
            } else {
                if (getUserRepository().findByUsername(username) != null) {//普通用户名
                    msg = "username.exist";
                }
            }
        }
        if (msg == null) {
            return JsonUtil.getSuccess("success");
        }
        return JsonUtil.getFailure(MessageUtils.message(msg, null, msg), msg);
    }

    //判断用户是否可以添加
    private String checkUser(User m) throws IllegalAccessException {
        //开发者用户类型不允许添加，目前只能平台自动设置
        if (Objects.equals(m.getUserType(), UserType.dev)) throw new IllegalAccessException("userType.is.illegal");
        if (m.getId() != null) {
            //用户名存在
            if (getUserRepository().findByUsernameAndIdIsNot(m.getUsername(), m.getId()) != null) {
                return "username.exist";
            }
            //邮箱存在
            if (!StringUtils.isEmpty(m.getEmail())
                    && getUserRepository().findByEmailAndIdIsNot(m.getEmail(), m.getId()) != null) {
                return "email.exist";
            }
            //电话号码存在
            if (!StringUtils.isEmpty(m.getMobilePhoneNumber())
                    && getUserRepository().findByMobilePhoneNumberAndIdIsNot(m.getMobilePhoneNumber(), m.getId()) != null) {
                return "mobilePhoneNumber.exist";
            }
        } else {
            //用户名存在
            if (getUserRepository().findByUsername(m.getUsername()) != null) {
                return "username.exist";
            }
            //邮箱存在
            if (!StringUtils.isEmpty(m.getEmail())
                    && getUserRepository().findByEmail(m.getEmail()) != null) {
                return "email.exist";
            }
            //电话号码存在
            if (!StringUtils.isEmpty(m.getMobilePhoneNumber())
                    && getUserRepository().findByMobilePhoneNumber(m.getMobilePhoneNumber()) != null) {
                return "mobilePhoneNumber.exist";
            }
        }
        return null;
    }

    /**
     * 根据公司ID获取当前公司下的saas用户
     *
     * @param companyId 公司ID
     * @return saas用户
     */
    public User getCompanySaasUser(Long companyId) {
        return getUserRepository().findByCompanyIdAndUserType(companyId, UserType.saas);
    }


    /**
     * 更新当前登陆用户名称
     *
     * @return 更新结果
     */
    public JSONResult updateUserName(User user) {
        User user1 = webContextUtils.getCheckCurrentUser();
        if (StringUtils.isEmpty(user.getName())) return JsonUtil.getFailure("name is not null");
        user1.setName(user.getName());
        return super.update_(user1);
    }

    /**
     * 更新当前登陆用户头像
     *
     * @return 更新结果
     */
    public JSONResult updateUserImg(User user) {
        User user1 = webContextUtils.getCheckCurrentUser();
        if (StringUtils.isEmpty(user.getHeadImg())) return JsonUtil.getFailure("headImg is not null");
        user1.setHeadImg(user.getHeadImg());
        //去掉图片修饰参数
        if (user.getHeadImg().contains("?")) {
            user1.setHeadImgYuan(user.getHeadImg().substring(0, user.getHeadImg().indexOf("?")));
        } else {
            user1.setHeadImgYuan(user.getHeadImg());
        }
        return super.update_(user1);
    }

    /**
     * 重置密码
     *
     * @param id 用户ID
     */
    public JSONResult resetPassword(Long id) {
        User user = super.findOne(id);
        user.setPassword("000000");
        EndecryptUtils.md5Password(user);
        super.update(user);
        return JsonUtil.getSuccess(MessageUtils.message("password.reset.ok"), "password.reset.ok");
    }

    /**
     * 修改密码
     *
     * @param passwordDTO 密码信息
     */
    @Transactional(rollbackFor = Exception.class)
    public JSONResult password(PasswordDTO passwordDTO) {
        User user = webContextUtils.getCheckCurrentUser();
        if (!EndecryptUtils.checkMd5Password(user.getUsername(), passwordDTO.getOldPassword(), user.getSalt(), user.getPassword()))
            throw new UserException("old.password.error");
        User userDO = new User();
        userDO.setUsername(user.getUsername());
        userDO.setPassword(passwordDTO.getNewPassword());
        EndecryptUtils.md5Password(userDO);
        int i = getUserRepository().updatePasswordAndSaleById(userDO.getPassword(), userDO.getSalt(), user.getId());
        if (i != 1) throw new UserException("system.error");
        return JsonUtil.getSuccess(MessageUtils.message("password.reset.ok"), "password.reset.ok");
    }

    /**
     * 判断旧密码是否正确
     *
     * @param passwordDTO 密码信息
     */
    public JSONResult checkPassword(PasswordDTO passwordDTO) {
        User user = webContextUtils.getCheckCurrentUser();
        if (!EndecryptUtils.checkMd5Password(user.getUsername(), passwordDTO.getOldPassword(), user.getSalt(), user.getPassword())) {
            return JsonUtil.getFailure("error");
        }
        return JsonUtil.getSuccess("success");
    }

    /**
     * 邀请同事
     * 1、判断邀请用户是否存在。
     * 2、不存在，自动完成注册。
     * 3、存在、判断是否已在当前team，在提醒 不在自动加入组织。
     *
     * @param dto 邀请数据
     * @return 返回邀请结果数组
     */
    @Transactional(rollbackFor = Exception.class)
    public JSONResult invitation(InvitationDTO dto) {
        if (dto.getInvitations() != null && dto.getInvitations().size() > 0) {
            for (RegisterDTO registerDTO : dto.getInvitations()) {
                User register;
                if (RegExpValidatorUtils.match(User.MOBILE_PHONE_NUMBER_PATTERN, registerDTO.getUsername())) {
                    register = getUserRepository().findByMobilePhoneNumber(registerDTO.getUsername());
                } else if (RegExpValidatorUtils.match(User.EMAIL_PATTERN, registerDTO.getUsername())) {
                    register = getUserRepository().findByEmail(registerDTO.getUsername());
                } else throw new UserException("username.is.error");
                if (register == null) {
                    //首先注册用户
                    String defaultPassword = "123456";
                    register = new User();
                    register.setUsername(UUID.randomUUID().toString().replace("-", ""));
                    register.setStatus(UserStatus.normal);
                    register.setUserType(UserType.user);
                    register.setPassword(defaultPassword);
                    register.setName(registerDTO.getName());
                    register.setEmail(registerDTO.getUsername());
                    JSONResult jsonResult = save_(register);
                    if (jsonResult.ifSuccess()) {
                        Organization currentOrganization = organizationService.getUserCurrentOrganization();
                        UserOrganizationRecords userOrganizationRecords = new UserOrganizationRecords();
                        userOrganizationRecords.setUser(register);
                        userOrganizationRecords.setOrganization(currentOrganization);
                        boolean ifExist = userOrganizationRecordsService.create(userOrganizationRecords);
                        if (!ifExist) { //添加关系
                            this.removeOrAddOrganization(register.getId(), currentOrganization.getId());
                        }
                        String emailContent = configService.getConfigString(CommonContact.INVITATION_PASSWORD_HTML);
                        emailContent = emailContent.replace(CommonContact.REMIND_NAME, register.getName());
                        emailContent = emailContent.replace(CommonContact.INVITATION_HTML_URL,
                                configService.getConfigString(CommonContact.HTML_SERVER_BASE_PATH) + "login");
                        emailContent = emailContent.replace(CommonContact.INVITATION_PASSWORD_HTML_PASSWORD, defaultPassword);
                        emailContent = emailContent.replace(CommonContact.EMAIL_DATE, TimeMaker.toDateStr(new Date()));
                        emailContent = emailContent.replace(CommonContact.INVITATION_HTML_TEAM_NAME, currentOrganization.getName());
                        emailSender.sendSimpleEmail("团队邀请提醒", emailContent, register.getEmail(), Boolean.TRUE);
                    }
                } else {
                    //加入当前要求人所有的团队
                    Organization currentOrganization = organizationService.getUserCurrentOrganization();
                    UserOrganizationRecords userOrganizationRecords = new UserOrganizationRecords();
                    userOrganizationRecords.setUser(register);
                    userOrganizationRecords.setOrganization(currentOrganization);
                    boolean ifExist = userOrganizationRecordsService.create(userOrganizationRecords);
                    //变更当前人companyId
                    register.setCompanyId(currentOrganization.getCompanyId());
                    if (!ifExist) {//添加关系
                        this.removeOrAddOrganization(register.getId(), currentOrganization.getId());
                    }
                    register.setStatus(UserStatus.normal);
                    super.update(register);
                    //发送邮件提醒
                    String emailContent = configService.getConfigString(CommonContact.INVITATION_HTML);
                    emailContent = emailContent.replace(CommonContact.REMIND_NAME, register.getName());
                    emailContent = emailContent.replace(CommonContact.INVITATION_HTML_URL,
                            configService.getConfigString(CommonContact.HTML_SERVER_BASE_PATH) + "login");
                    emailContent = emailContent.replace(CommonContact.EMAIL_DATE, TimeMaker.toDateStr(new Date()));
                    emailContent = emailContent.replace(CommonContact.INVITATION_HTML_TEAM_NAME, currentOrganization.getName());
                    emailSender.sendSimpleEmail("团队邀请提醒", emailContent, register.getEmail(), Boolean.TRUE);
                }
            }
            return JsonUtil.getSuccess(MessageUtils.message(CommonContact.OPTION_SUCCESS), CommonContact.OPTION_SUCCESS);
        }
        return JsonUtil.getFailure(MessageUtils.message(CommonContact.REQUIRE_PARAMS_MISS), CommonContact.REQUIRE_PARAMS_MISS);
    }

    /**
     * 把一个用户从当前登陆用户的team中移除
     *
     * @param uid 用户ID
     * @return 操作结果
     */
    @Transactional(rollbackFor = Exception.class)
    public JSONResult removeTeam(Long uid) {
        User user = super.findOne(uid);
        //需要检查一下用户类型，不能移除sass用户
        if (UserType.saas.equals(user.getUserType())) throw new UserException("saas user not remove error");
        Organization currentOrganization = organizationService.getUserCurrentOrganization();
        //删除关系记录
        userOrganizationRecordsService.delete(uid, currentOrganization.getId());
        Long[] oIds = organizationService.getOrganizationByCompanyId(currentOrganization.getCompanyId());
        //删除所有team关系
        userOrganizationJobRepository.deleteByUserIdAndOrganizationIdIn(uid, oIds);
        //操作成功后，设置当前用户的默认companyId 如果不存在任何部门了 需要修改用户状态
        List<UserOrganizationRecords> userOrganizationRecordsList = userOrganizationRecordsService.getByUid(uid);
        if (userOrganizationRecordsList != null && userOrganizationRecordsList.size() > 0) {
            user.setCompanyId(userOrganizationRecordsList.get(0).getOrganization().getCompanyId());
        } else {
            user.setCompanyId(null);
            user.setStatus(UserStatus.noteam);//没有团队状态
        }
        super.updateNoCompanyId(user);
        //删除角色分配数据
        authService.deleteByUserIdAndCompanyId(uid, currentOrganization.getCompanyId());
        //手动清理一下集合缓存
        HibernateUtils.evictLevel2CollectionRegions(entityManager);
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.OPTION_SUCCESS), CommonContact.OPTION_SUCCESS);
    }

    /**
     * 这里会获取当前公司下的所有用户信息
     *
     * @return 分组数组
     */
    @Transactional(readOnly = true)
    public JSONResult mailListInit() {

        User user = webContextUtils.getCheckCurrentUser();
        Map<String, Object> params = Maps.newHashMap();
        params.put("companyId_eq", user.getCompanyId());
        //查询当前用户下的所有组织
        List<Organization> organizations = organizationService.findAllWithSort(Searchable
                .newSearchable(params, new Sort(Sort.Direction.ASC, "sorter")));
        //目前获取用户信息不排序不分页
        params.put("deleted_eq", false);
        List<User> users = super.findAllWithNoPageNoSort(Searchable.newSearchable(params));
        List<Object> jsonList = Lists.newArrayList();
        if (organizations.size() == 1) {
            Map<String, Object> jsonMap = organizations.get(0).toMap();
            jsonMap.put("users", simpleJsonUserList(users));
            jsonList.add(jsonMap);
        } else {
            organizations.forEach(x -> {
                Map<String, Object> jsonMap = x.toMap();
                if (x.getParentId() == null) { //顶级 条件只有一个部门而且是属于当前
                    List<User> userList = users.stream().filter(u -> ifNotFen(u, x.getId())).collect(Collectors.toList());
                    jsonMap.put("users", simpleJsonUserList(userList));
                } else { // 用户可能存在多个
                    List<User> userList = users.stream().filter(u -> ifBelongToOrganization(u, x.getId()))
                            .collect(Collectors.toList());
                    jsonMap.put("users", simpleJsonUserList(userList));
                }
                jsonList.add(jsonMap);
            });
        }
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.FETCH_SUCCESS), CommonContact.FETCH_SUCCESS, jsonList);
    }

    //当前用户为分配
    private boolean ifNotFen(User user, Long oId) {
        return user.getOrganizationJobs().size() == 1
                && ifBelongToOrganization(user, oId);
    }

    //判断一个用户是否属于某个团队
    private boolean ifBelongToOrganization(User user, Long oId) {
        for (UserOrganizationJob one : user.getOrganizationJobs()) {
            if (one.getOrganization() == null || one.getOrganization().getId() == null) continue;
            if (oId.equals(one.getOrganization().getId())) {
                return true;
            }
        }
        return false;
    }

    private List simpleJsonUserList(List<User> users) {
        List<Object> list = Lists.newArrayList();
        if (users != null && users.size() > 0) {
            users.forEach(x -> list.add(x.toSimpleMap()));
        }
        return list;
    }

    private List simpleJsonOrganizationList(List<Organization> organizations) {
        List<Object> list = Lists.newArrayList();
        if (organizations != null && organizations.size() > 0) {
            organizations.forEach(x -> {
                Map<String, Object> jsonMap = Maps.newHashMap();
                jsonMap.put("id", x.getId());
                jsonMap.put("name", x.getName());
                list.add(jsonMap);
            });
        }
        return list;
    }

    /**
     * 移动，把某个用户由某个部门移动到某个部门下
     *
     * @param uId 用户ID
     * @param oId 原团队ID
     * @param mId 移动的团队ID
     * @return 移动结果
     */
    @Transactional(rollbackFor = Exception.class)
    public JSONResult move(Long uId, Long oId, Long mId) {
        if (!removeOrAddOrganization(uId, oId).ifSuccess()) throw new UserException(CommonContact.OPTION_ERROR);
        if (!removeOrAddOrganization(uId, mId).ifSuccess()) throw new UserException(CommonContact.OPTION_ERROR);
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.OPTION_SUCCESS), CommonContact.OPTION_SUCCESS);
    }


    /**
     * 获取筛选条件接口
     *
     * @return 筛选条件
     */
    public JSONResult choose() {
        User user = webContextUtils.getCheckCurrentUser();
        //获取部门时，不获取parentId = null 的部门
        Map<String, Object> params = Maps.newHashMap();
        params.put("companyId_eq", user.getCompanyId());
        params.put("id_ne", user.getId());
        params.put("deleted_eq", Boolean.FALSE);
        List<User> users = super.findAllWithNoPageNoSort(Searchable.newSearchable(params));
        params.remove("id_ne");
        params.remove("deleted_eq");
        params.put("parentId_isNotNull", null);
        List<Organization> organizations = organizationService.findAllWithSort(Searchable.newSearchable(params, new Sort(Sort.Direction.ASC, "sorter")));
        params.clear();
        params.put("users", simpleJsonUserList(users));
        params.put("organizations", simpleJsonOrganizationList(organizations));
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.FETCH_SUCCESS), CommonContact.OPTION_SUCCESS, params);
    }


    public boolean onLoginSuccess() {
        return onLoginSuccess(false);
    }

    /**
     * 登陆成功后 增加x-auth-token信息
     *
     * @return 登陆成功，添加x-auth-token信息
     */
    public boolean onLoginSuccess(boolean rememberMe) {
        //用户信息
        TokenInfo tokenInfo = new TokenInfo(UUID.randomUUID().toString(),
                webContextUtils.getCurrentPrincipal(), null);
        authCache.put(tokenInfo.getToken(), tokenInfo);
        if (rememberMe) { //设置免登陆header
            Subject subject = SecurityUtils.getSubject();
            rememberMeManager.rememberIdentity(subject);
        } else {
            rememberMeManager.forgetIdentity(null);
        }
        webContextUtils.getResponse().setHeader(CommonContact.HTTP_HEADER_AUTH_TOKEN, tokenInfo.getToken());
        return true;
    }

    /**
     * 退出登陆，移除 token cache
     */
    public void loginOut() {
        authCache.evict(webContextUtils.getRequest().getHeader(CommonContact.HTTP_HEADER_AUTH_TOKEN));
        //移除
        rememberMeManager.forgetIdentity(null);
        webContextUtils.getResponse().setHeader(CommonContact.HTTP_HEADER_AUTH_TOKEN, null);
    }

    /**
     * 获取当前用户下的公司所有成员
     *
     * @return 成员数据
     */
    public JSONResult team() {
        User user = webContextUtils.getCheckCurrentUser();
        Map<String, Object> params = Maps.newHashMap();
        params.put("companyId_eq", user.getCompanyId());
        params.put("deleted_eq", Boolean.FALSE);
        List<User> users = super.findAllWithNoPageNoSort(Searchable.newSearchable(params));
        params.clear();
        params.put("users", simpleJsonUserList(users));
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.FETCH_SUCCESS), CommonContact.FETCH_SUCCESS, params);
    }

}
