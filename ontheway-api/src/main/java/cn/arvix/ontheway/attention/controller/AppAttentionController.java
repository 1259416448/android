package cn.arvix.ontheway.attention.controller;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.web.controller.ExceptionHandlerController;
import cn.arvix.ontheway.attention.service.AttentionService;
import cn.arvix.ontheway.attention.service.AttentionStatisticsService;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

/**
 * @author Created by yangyang on 2017/10/25.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Controller
@RequestMapping(value = "/app/attention")
public class AppAttentionController extends ExceptionHandlerController {

    private final AttentionService attentionService;

    @Autowired
    public AppAttentionController(AttentionService attentionService) {
        this.attentionService = attentionService;
    }

    private AttentionStatisticsService attentionStatisticsService;

    @Autowired
    public void setAttentionStatisticsService(AttentionStatisticsService attentionStatisticsService) {
        this.attentionStatisticsService = attentionStatisticsService;
    }

    @ApiOperation(value = "关注")
    @ResponseBody
    @PostMapping(value = "/create/{attentionUserId}")
    public JSONResult create(@PathVariable Long attentionUserId) {
        return attentionService.create(attentionUserId);
    }

    @ApiOperation(value = "取消关注")
    @ResponseBody
    @PostMapping(value = "/cancel/{attentionUserId}")
    public JSONResult cancel(@PathVariable Long attentionUserId) {
        return attentionService.cancel(attentionUserId);
    }

    @ApiOperation(value = "获取关注列表或者粉丝列表", notes = "通过不同类型获取不同数据")
    @ResponseBody
    @PostMapping(value = "/search")
    @ApiImplicitParams({
            @ApiImplicitParam(value = "当前页", name = "number", required = true, paramType = "query"),
            @ApiImplicitParam(value = "每页大小", name = "size", required = true, paramType = "query"),
            @ApiImplicitParam(value = "开始分页时间", name = "currentTime", paramType = "query"),
            @ApiImplicitParam(value = "查询类型", name = "type", paramType = "query", required = true),
    })
    public JSONResult search(AttentionService.AttentionType type, int number, int size, Long currentTime) {
        return attentionService.search(type, number, size, currentTime);
    }

    @ApiOperation(value = "获取关注数量、粉丝数量以及关注状态", notes = "如果是本人 返回关注数量、粉丝数量 <br/>" +
            " 查看他人 返回粉丝数量、关注状态")
    @ResponseBody
    @GetMapping(value = "/info/{userId}")
    public JSONResult info(@PathVariable Long userId) {
        return attentionStatisticsService.getInfoByUserId(userId);
    }

    @ApiOperation(value = "获取新的足迹动态", notes = "获取我关注用户的新的足迹动态，按发布时间排序")
    @ResponseBody
    @GetMapping(value = "/footprint")
    @ApiImplicitParams({
            @ApiImplicitParam(value = "当前页", name = "number", required = true, paramType = "query"),
            @ApiImplicitParam(value = "每页大小", name = "size", required = true, paramType = "query"),
            @ApiImplicitParam(value = "开始分页时间", name = "currentTime", paramType = "query")
    })
    public JSONResult footprint(int number, int size, Long currentTime) {
        return attentionService.footprint(number, size, currentTime);
    }

}
