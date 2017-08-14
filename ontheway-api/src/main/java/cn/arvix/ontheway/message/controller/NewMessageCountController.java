package cn.arvix.ontheway.message.controller;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.web.controller.ExceptionHandlerController;
import cn.arvix.ontheway.message.service.NewMessageCountService;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author Created by yangyang on 2017/8/11.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Controller
@RequestMapping(value = "/app/message")
public class NewMessageCountController extends ExceptionHandlerController {

    private NewMessageCountService service;

    @Autowired
    public void setService(NewMessageCountService service) {
        this.service = service;
    }

    @ApiOperation(value = "获取当前用户消息未读数")
    @GetMapping(value = "/new")
    @ResponseBody
    public JSONResult newCount() {
        return service.newCount();
    }

}
