package cn.arvix.ontheway.sys.user.controller;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.base.common.utils.MessageUtils;
import cn.arvix.base.common.web.controller.ExceptionHandlerController;
import cn.arvix.ontheway.sys.dto.LoginDTO;
import cn.arvix.ontheway.sys.dto.PasswordDTO;
import cn.arvix.ontheway.sys.dto.RegisterDTO;
import cn.arvix.ontheway.sys.user.service.UserService;
import cn.arvix.ontheway.sys.utils.WebContextUtils;
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

    @RequestMapping(value = "/login/sms/sent/{mobile}", method = RequestMethod.GET)
    @ResponseBody
    @ApiOperation(value = "发送登陆验证码", notes = "发送登陆验证码，需要使用同一的key求消息摘要, digest 消息摘要")
    public JSONResult sentSMSCode(@PathVariable String mobile, String digest) {
        return userService.sentSMSCode(mobile, digest);
    }


    @ApiOperation(value = "使用手机验证码登陆")
    @ResponseBody
    @RequestMapping(value = "/login/sms", method = RequestMethod.POST)
    public JSONResult smsCodeLogin(@RequestBody LoginDTO dto) {
        return userService.smsCodeLogin(dto);
    }

}
