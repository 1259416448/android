package cn.arvix.ontheway.sys.user.controller;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.ontheway.ducuments.entity.Document;
import cn.arvix.ontheway.sys.user.entity.User;
import cn.arvix.ontheway.sys.user.service.UserService;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * 用于App操作用户信息
 *
 * @author Created by yangyang on 2017/7/26.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Controller
@RequestMapping(value = "/app/user")
public class AppUserController {

    private UserService userService;

    @Autowired
    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    @ApiOperation(value = "更新用户姓名", notes = "这里只提供用户姓名的更改，其他参数设置无效")
    @RequestMapping(value = "/update/name", method = RequestMethod.POST)
    @ResponseBody
    public JSONResult updateName(@RequestBody User user) {
        return userService.updateUserName(user);
    }

    @ApiOperation(value = "更新用户姓名", notes = "这里只提供性别修改，其他参数设置无效")
    @RequestMapping(value = "/update/gender", method = RequestMethod.POST)
    @ResponseBody
    public JSONResult updateGender(@RequestBody User user) {
        return userService.updateGender(user);
    }

    @ApiOperation(value = "更新用户头像", notes = "这里只提供头像修改，其他参数设置无效")
    @RequestMapping(value = "/update/image", method = RequestMethod.POST)
    @ResponseBody
    public JSONResult updateHeaderImg(@RequestBody Document document) {
        return userService.updateHeaderImg(document);
    }

}
