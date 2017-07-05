package cn.arvix.ontheway.sys.user.controller;

import cn.arvix.ontheway.sys.dto.InvitationDTO;
import cn.arvix.ontheway.sys.dto.LoginDTO;
import cn.arvix.ontheway.sys.dto.PasswordDTO;
import cn.arvix.ontheway.sys.dto.RegisterDTO;
import cn.arvix.ontheway.sys.user.entity.User;
import cn.arvix.ontheway.sys.user.entity.UserStatus;
import cn.arvix.ontheway.sys.user.service.UserService;
import cn.arvix.ontheway.sys.utils.WebContextUtils;
import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.base.common.utils.MessageUtils;
import cn.arvix.base.common.web.controller.ExceptionHandlerController;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiOperation;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.*;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.Objects;

/**
 * 有状态的登陆
 *
 * @author Created by yangyang on 2017/3/20.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@RequestMapping(value = "/api/v1")
@Controller
public class LoginController extends ExceptionHandlerController {

    private final UserService userService;

    private final WebContextUtils webContextUtils;

    @Autowired
    public LoginController(WebContextUtils webContextUtils, UserService userService) {
        this.webContextUtils = webContextUtils;
        this.userService = userService;
    }

    @ApiOperation(value = "用户登陆，有状态用户登陆", notes = "密码连续错误5次会锁定10分钟")
    @ResponseBody
    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public JSONResult login(@RequestBody final LoginDTO dto) {
        Subject subject = SecurityUtils.getSubject();
        UsernamePasswordToken token = new UsernamePasswordToken(dto.getUsername(), dto.getPassword());
        //token.setRememberMe(dto.getRememberMe());
        try {
            subject.login(token);
            //记录登陆日志
            //验证用户状态
            User current = webContextUtils.getCheckCurrentUser();
            if (UserStatus.unactivated.equals(current.getStatus())) {
                return JsonUtil.getFailure(UserStatus.unactivated.toString(), UserStatus.unactivated.toString(), current.getUsername());
            } else if (UserStatus.noteam.equals(current.getStatus())) {
                return JsonUtil.getFailure(UserStatus.noteam.toString(), UserStatus.noteam.toString(), current.getUsername());
            }
            //登陆成功，返回登陆用户基本信息
            userService.onLoginSuccess(dto.getRememberMe());
            return JsonUtil.getSuccess(MessageUtils.message(CommonContact.LOGIN_SUCCESS),
                    CommonContact.LOGIN_SUCCESS, webContextUtils.getCheckCurrentUser().toMap());
        } catch (ExcessiveAttemptsException ex) {
            if (webContextUtils.ifDev()) {
                ex.printStackTrace();
            }
            return JsonUtil.getFailure(MessageUtils.message(CommonContact.ACCOUNT_IS_LOCK, 10)
                    , CommonContact.ACCOUNT_IS_LOCK);
        } catch (LockedAccountException lex) {
            if (webContextUtils.ifDev()) {
                lex.printStackTrace();
            }
            return JsonUtil.getFailure(MessageUtils.message(CommonContact.ACCOUNT_IS_DISABLED),
                    CommonContact.ACCOUNT_IS_DISABLED);
        } catch (IncorrectCredentialsException ix) {
            if (webContextUtils.ifDev()) {
                ix.printStackTrace();
            }
            return JsonUtil.getFailure(MessageUtils.message(CommonContact.USERNAME_OR_PASSWORD_ERROR_LOCK, 10),
                    CommonContact.USERNAME_OR_PASSWORD_ERROR_LOCK);
        } catch (AuthenticationException aex) {
            if (webContextUtils.ifDev()) {
                aex.printStackTrace();
            }
            if (Objects.equals(aex.getMessage(), CommonContact.USERNAME_OR_PASSWORD_ERROR_LOCK)) {
                return JsonUtil.getFailure(MessageUtils.message(CommonContact.USERNAME_OR_PASSWORD_ERROR_LOCK, 10),
                        CommonContact.USERNAME_OR_PASSWORD_ERROR_LOCK);
            }
        }
        return JsonUtil.getFailure(MessageUtils.message(CommonContact.USERNAME_OR_PASSWORD_ERROR),
                CommonContact.USERNAME_OR_PASSWORD_ERROR);
    }

    @ApiOperation(value = "未登录返回数据接口", notes = "未登录返回数据接口")
    @ResponseBody
    @RequestMapping(value = "/no/login", method = RequestMethod.GET)
    public JSONResult noLogin() {
        return JsonUtil.getFailure(MessageUtils.message(CommonContact.NO_LOGIN), CommonContact.NO_LOGIN);
    }

    @ApiOperation(value = "获取当前登陆用户", notes = "获取当前登陆用户")
    @ResponseBody
    @RequestMapping(value = "/login/current/user", method = RequestMethod.GET)
    public JSONResult currentUser() {
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.FETCH_SUCCESS),
                CommonContact.FETCH_SUCCESS, webContextUtils.getCheckCurrentUser().toMap());
    }

    @ApiOperation(value = "退出登陆", notes = "退出登陆")
    @ResponseBody
    @RequestMapping(value = "/login/out", method = RequestMethod.GET)
    public JSONResult loginOut() {
        userService.loginOut();
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.OPTION_SUCCESS), CommonContact.OPTION_SUCCESS);
    }

    @ApiOperation(value = "新saas用户初次注册", notes = "新saas用户初次注册，当前版本不提供独立域名，下次迭代添加功能，调用此接口后用户状态为未激活")
    @ResponseBody
    @RequestMapping(value = "/register", method = RequestMethod.POST)
    public JSONResult register(@RequestBody RegisterDTO dto) {
        return userService.register(dto);
    }

    @ApiOperation(value = "账号激活，邮件方式激活", notes = "账号激活，邮件方式,当前用户状态未添加团队")
    @ResponseBody
    @RequestMapping(value = "/send/activation/email/{username}", method = RequestMethod.GET)
    public JSONResult activationSentEmail(@PathVariable String username) {
        return userService.sendActivationEmail(username);
    }

    @ApiOperation(value = "激活账号", notes = "激活账号，邮件方式")
    @ResponseBody
    @RequestMapping(value = "/activation/email/{username}/{uuid}", method = RequestMethod.PUT)
    public JSONResult activationEmail(@PathVariable String username, @PathVariable String uuid) {
        return userService.activationEmail(username, uuid);
    }

    @ApiOperation(value = "发送邮件验证码", notes = "发送邮件验证码，一般在忘记密码时通过邮件找回密码使用")
    @ResponseBody
    @RequestMapping(value = "/forget/email", method = RequestMethod.GET)
    @ApiImplicitParam(name = "username", value = "邮箱", paramType = "query")
    public JSONResult sentEmailCode(String username) {
        return userService.forgetEmail(username);
    }

    @ApiOperation(value = "账号激活，手机方式", notes = "账号激活，手机方式,当前用户状态未添加团队")
    public JSONResult activationPhone() {
        return null;
    }

    @ApiOperation(value = "验证用户名是否可用", notes = "返回验证情况")
    @RequestMapping(value = "/check/username", method = RequestMethod.POST)
    @ResponseBody
    public JSONResult checkUsername(@RequestBody RegisterDTO dto) {
        return userService.checkUsername(dto.getUsername());
    }

    /**
     * 修改密码相关接口
     */

    @RequestMapping(value = "/password", method = RequestMethod.PUT)
    @ResponseBody
    @ApiOperation(value = "密码修改", notes = "需要传递新密码和旧密码")
    public JSONResult password(@RequestBody PasswordDTO passwordDTO) {
        //SecurityUtils.getSubject().checkPermission(userService.getEntityName() + ":tab:myPassword");
        return userService.password(passwordDTO);
    }

    @RequestMapping(value = "/checkPassword", method = RequestMethod.POST)
    @ResponseBody
    @ApiOperation(value = "验证当前用户密码是否正确", notes = "需要传递旧密码")
    public JSONResult checkPassword(@RequestBody PasswordDTO passwordDTO) {
        //SecurityUtils.getSubject().checkPermission(userService.getEntityName() + ":tab:myPassword");
        return userService.checkPassword(passwordDTO);
    }

    @RequestMapping(value = "/reset/{id}", method = RequestMethod.PUT)
    @ResponseBody
    @ApiOperation(value = "重置密码", notes = "管理员重置密码")
    public JSONResult resetPassword(@PathVariable Long id) {
        //SecurityUtils.getSubject().checkPermission(userService.getEntityName() + ":tab:password");
        return userService.resetPassword(id);
    }

    @RequestMapping(value = "/invitation", method = RequestMethod.POST)
    @ApiOperation(value = "邀请同事", notes = "目前只支持邮箱方式，邀请同事,这里回返回一个数据，表示邀请结果")
    @ResponseBody
    public JSONResult invitation(@RequestBody InvitationDTO dto) {
        return userService.invitation(dto);
    }

    @RequestMapping(value = "/remove/{uid}/team", method = RequestMethod.POST)
    @ApiOperation(value = "把某个成员从当前saas中移除", notes = "传入用户id即可")
    @ResponseBody
    public JSONResult removeTeam(@PathVariable Long uid) {
        return userService.removeTeam(uid);
    }


}
