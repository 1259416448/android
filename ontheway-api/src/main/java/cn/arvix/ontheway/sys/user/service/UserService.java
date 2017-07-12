package cn.arvix.ontheway.sys.user.service;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.entity.search.PageRequest;
import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.entity.search.filter.SearchFilter;
import cn.arvix.base.common.entity.search.filter.SearchFilterHelper;
import cn.arvix.base.common.repository.hibernate.HibernateUtils;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.base.common.utils.*;
import cn.arvix.ontheway.sys.config.service.ConfigService;
import cn.arvix.ontheway.sys.dto.*;
import cn.arvix.ontheway.sys.organization.entity.Organization;
import cn.arvix.ontheway.sys.organization.service.OrganizationService;
import cn.arvix.ontheway.sys.shiro.token.AutoLoginToken;
import cn.arvix.ontheway.sys.shiro.web.mgt.HeaderRememberMeManager;
import cn.arvix.ontheway.sys.sms.SMSService;
import cn.arvix.ontheway.sys.user.entity.*;
import cn.arvix.ontheway.sys.user.exception.UserException;
import cn.arvix.ontheway.sys.user.repository.UserOrganizationJobRepository;
import cn.arvix.ontheway.sys.user.repository.UserRepository;
import cn.arvix.ontheway.sys.utils.EndecryptUtils;
import cn.arvix.ontheway.sys.utils.HmacSHA256Utils;
import cn.arvix.ontheway.sys.utils.RegExpValidatorUtils;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.redisson.api.RBucket;
import org.redisson.api.RedissonClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
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

    private SMSService smsService;

    @Autowired
    public void setSmsService(@Qualifier("juHeSMSServiceImpl") SMSService smsService) {
        this.smsService = smsService;
    }

    private HeaderRememberMeManager rememberMeManager;

    @Autowired
    public void setRememberMeManager(HeaderRememberMeManager rememberMeManager) {
        this.rememberMeManager = rememberMeManager;
    }

    @PersistenceContext
    private EntityManager entityManager;

    private final Cache authCache;

    @Autowired
    public UserService(UserOrganizationJobRepository userOrganizationJobRepository,
                       OrganizationService organizationService,
                       CacheManager cacheManager, ConfigService configService,
                       RedissonClient redissonClient) {
        this.userOrganizationJobRepository = userOrganizationJobRepository;
        this.organizationService = organizationService;
        this.authCache = cacheManager.getCache(CommonContact.X_AUTH_TOKEN_CACHE);
        this.configService = configService;
        this.redissonClient = redissonClient;
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
        //创建用户
        for (Long organizationId : organizationIds) {
            UserOrganizationJob userOrganizationJob = new UserOrganizationJob(organizationId, null);
            userOrganizationJob.setUser(user);
            userOrganizationJob.setDateCreated(date);
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

    //获取一个6位验证码
    private String getSixNumberCode() {
        Random random = new Random();
        int x = random.nextInt(900000) + 100000;
        //测试环境 默认验证码123456
        if (webContextUtils.ifTest()) {
            return String.valueOf(123456);
        }
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
     * 发送短信验证码，6位验证码
     * 需要进行消息摘要验证，防止恶意访问，目前使用固定的app key
     *
     * @param mobile 手机号
     * @param digest 消息摘要 对手机号求消息摘要
     * @return 操作结果
     */
    public JSONResult sentSMSCode(String mobile, String digest) {

        //首先验证消息摘要正确性  mobile:mobile
        String serverDigest = HmacSHA256Utils.digest(CommonContact.HMAC256_KEY, "mobile:" + mobile);
        if (!Objects.equals(serverDigest, digest)) {
            return JsonUtil.getFailure("消息摘要错误", CommonErrorCode.DIGEST_ERROR);
        }

        RBucket<SmsDTO> bucket = redissonClient.getBucket(getSMSMobileKey(mobile));
        SmsDTO smsDTO = bucket.get();
        if (smsDTO != null) { //55秒不能重复发送
            //新建短信发送内容
            if (smsDTO.getTime() + 55000 > System.currentTimeMillis()) {
                return JsonUtil.getFailure("短信验证码发送操作频繁", CommonErrorCode.FREQUENT_OPERATION);
            }
        }
        Map<String, Object> map = Maps.newHashMap();
        Map<String, Object> params = Maps.newHashMap();
        map.put("mobile", mobile);
        params.put("#minute#", configService.getConfigString(CommonContact.SMS_CODE_TTL_TIME).split("-")[0]);
        params.put("#code#", getSixNumberCode());
        map.put("tpl_id", configService.getConfigString(CommonContact.JU_HE_LOGIN_CODE_TPL_ID));
        map.put("tpl_map", params);
        Boolean opt = Boolean.TRUE;
        //只有在非测试情况下才发送短信
        if (!webContextUtils.ifTest()) {
            opt = smsService.sendMessage(null, map);
        }
        if (opt) {
            //记录redis
            smsDTO = new SmsDTO();
            smsDTO.setMobile(mobile);
            smsDTO.setCode(params.get("#code#").toString());
            smsDTO.setTime(System.currentTimeMillis());
            String[] time = configService.getConfigString(CommonContact.SMS_CODE_TTL_TIME).split("-");
            bucket.set(smsDTO, Long.valueOf(time[0]), TimeUnit.valueOf(time[1]));
            return JsonUtil.getSuccess(MessageUtils.message(CommonContact.OPTION_SUCCESS), CommonContact.OPTION_SUCCESS);
        } else {
            return JsonUtil.getSuccess(MessageUtils.message("短信验证码发送错误"), CommonErrorCode.SMS_CODE_SENT_ERROR);
        }
    }


    /**
     * 使用手机验证码登陆
     *
     * @param dto 登陆信息
     * @return 登陆结果，成功登陆后会返回当前用户信息
     */
    @Transactional(rollbackFor = Exception.class)
    public JSONResult smsCodeLogin(LoginDTO dto) {
        //先在redis中获取缓存的code
        RBucket<SmsDTO> bucket = redissonClient.getBucket(getSMSMobileKey(dto.getUsername()));
        SmsDTO smsDTO = bucket.get();
        if (smsDTO == null) { //为发送短信或短信已过期
            return JsonUtil.getFailure("短信验证码已过期，请重新发送", CommonErrorCode.SMS_CODE_TIMEOUT);
        }
        //比对验证码是否正确
        if (!Objects.equals(smsDTO.getCode(), dto.getPassword())) {
            return JsonUtil.getFailure("短信验证码错误", CommonErrorCode.SMS_CODE_ERROR);
        }
        //通过手机号获取当前用户信息
        User user = getUserRepository().findByMobilePhoneNumber(dto.getUsername());
        JSONResult jsonResult;
        if (user == null) { //执行用户自动注册
            jsonResult = registerByMobile(dto.getUsername());
            if (!jsonResult.ifSuccess()) return jsonResult;
        } else {
            jsonResult = JsonUtil.getSuccess("登录成功", CommonContact.LOGIN_SUCCESS, user.toSimpleMap());
        }
        //执行自动登录
        String username = ((Map) jsonResult.getBody()).get("username").toString();
        AutoLoginToken autoLoginToken = new AutoLoginToken(username, username);
        SecurityUtils.getSubject().login(autoLoginToken);
        //执行rememberMe 设置 x-auth-token 信息
        onLoginSuccess(dto.getRememberMe());
        //移除redis中的缓存记录
        redissonClient.getKeys().delete(getSMSMobileKey(dto.getUsername()));
        //返回登陆结果
        return jsonResult;
    }

    /**
     * 此方法只能通过手机号进行注册
     * 执行注册，用户初始化昵称使用手机号隐藏中间4位
     * 新注册的用户默认密码使用手机号后六位
     *
     * @return 注册结果
     */
    @Transactional(rollbackFor = Exception.class)
    public JSONResult registerByMobile(String mobile) {
        // 检查手机号是否使用过
        User user = getUserRepository().findByMobilePhoneNumber(mobile);
        if (user != null) {
            return JsonUtil.getFailure("注册手机号已被使用", CommonErrorCode.REGISTER_MOBILE_USED);
        }
        //添加用户
        user = new User();
        user.setUsername(UUID.randomUUID().toString().replace("-", ""));
        user.setMobilePhoneNumber(mobile);
        user.setPassword(getUserPass(mobile));
        user.setName(getNickname(mobile));
        user.setStatus(UserStatus.normal);
        user.setUserType(UserType.user);
        //设置默认头像
        Random random = new Random();
        user.setHeadImg("b"+random.nextInt(14)+".jpg");
        user.setHeadImgYuan("b"+random.nextInt(14)+".jpg");
        this.save_(user);
        //获取平台的用户部门
        Organization organization = organizationService.getUserOrg();
        //建立用户与部门之间的关系
        removeOrAddOrganization(user.getId(), organization.getId());
        return JsonUtil.getSuccess("注册成功", "register.success", user.toSimpleMap());
    }

    /**
     * 获取默认昵称
     *
     * @return 昵称
     */
    private String getNickname(String mobile) {
        return mobile.substring(0, 3) + "****" + mobile.substring(mobile.length() - 4, mobile.length());
    }

    /**
     * 获取默认密码
     *
     * @return 默认密码
     */

    private String getUserPass(String mobile) {
        return mobile.substring(mobile.length() - 6, mobile.length());
    }

    /**
     * 获取redis key
     *
     * @param mobile 手机号
     * @return redis key
     */
    private String getSMSMobileKey(String mobile) {
        return "sms_mobile_" + mobile;
    }


}
