package cn.arvix.ontheway.message.controller;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.web.controller.ExceptionHandlerController;
import cn.arvix.ontheway.message.service.SystemMessageService;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author Created by yangyang on 2017/10/25.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Controller
@RequestMapping(value = "/app/message/system")
public class AppSystemMessageController extends ExceptionHandlerController {

    private final SystemMessageService systemMessageService;

    @Autowired
    public AppSystemMessageController(SystemMessageService systemMessageService) {
        this.systemMessageService = systemMessageService;
    }

    @GetMapping(value = "/search")
    @ResponseBody
    @ApiOperation(value = "获取系统消息数据", notes = "clear = true 清空消息页面中提醒数据")
    @ApiImplicitParams(value = {
            @ApiImplicitParam(value = "当前页", name = "number", required = true, paramType = "query"),
            @ApiImplicitParam(value = "每页大小", name = "size", required = true, paramType = "query"),
            @ApiImplicitParam(value = "开始分页时间", name = "currentTime", paramType = "query"),
            @ApiImplicitParam(value = "清理消息", name = "clear", required = true, paramType = "query")
    })
    public JSONResult search(int number, int size, Long currentTime, boolean clear) {
        return systemMessageService.appSearch(number, size, currentTime, clear);
    }

}
