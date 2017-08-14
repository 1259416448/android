package cn.arvix.ontheway.footprint.controller;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.web.controller.ExceptionHandlerController;
import cn.arvix.ontheway.footprint.service.LikeRecordsService;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author Created by yangyang on 2017/8/14.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Controller
@RequestMapping(value = "/app/message/like")
public class LikeMessageController extends ExceptionHandlerController {

    private LikeRecordsService service;

    @Autowired
    public void setService(LikeRecordsService service) {
        this.service = service;
    }

    @ApiImplicitParams(value = {
            @ApiImplicitParam(value = "当前页", name = "number", required = true, paramType = "query"),
            @ApiImplicitParam(value = "每页大小", name = "size", required = true, paramType = "query"),
            @ApiImplicitParam(value = "开始分页时间", name = "currentTime", paramType = "query"),
            @ApiImplicitParam(value = "清理消息", name = "clear", required = true, paramType = "query")
    })
    @ResponseBody
    @GetMapping(value = "/search")
    @ApiOperation(value = "获取点赞消息 clear = true 清空消息页面中提醒数据")
    public JSONResult search(Integer number, Integer size, Long currentTime, boolean clear) {
        return service.search(number, size, currentTime, clear);
    }

}
