package cn.arvix.ontheway.footprint.controller;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.web.controller.ExceptionHandlerController;
import cn.arvix.ontheway.footprint.dto.CommentCreateDTO;
import cn.arvix.ontheway.footprint.service.CommentService;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

/**
 * 足迹评论相关接口
 *
 * @author Created by yangyang on 2017/7/31.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Controller
@RequestMapping(value = "/app/footprint/comment")
public class CommentController extends ExceptionHandlerController {

    private CommentService service;

    @Autowired
    public void setService(CommentService service) {
        this.service = service;
    }

    @ApiOperation(value = "创建评论", notes = "创建评论，需要登陆访问")
    @ResponseBody
    @PostMapping(value = "/create")
    public JSONResult create(@RequestBody CommentCreateDTO dto) {
        return service.create(dto);
    }

    @ApiOperation(value = "删除评论", notes = "删除评论，只能删除自己的评论")
    @ResponseBody
    @PostMapping(value = "/delete/{id}")
    public JSONResult delete(@PathVariable Long id) {
        return service.delete_(id);
    }

    @ApiImplicitParams(value = {
            @ApiImplicitParam(value = "当前页", name = "number", required = true, paramType = "query"),
            @ApiImplicitParam(value = "每页大小", name = "size", required = true, paramType = "query"),
            @ApiImplicitParam(value = "足迹ID", name = "footprintId", required = true, paramType = "query")
    })
    @ApiOperation(value = "获取评论数据", notes = "分页获取评论数据")
    @ResponseBody
    @GetMapping(value = "/search")
    public JSONResult search(Integer number, Integer size, Long footprintId) {
        return service.search(number,size,footprintId);
    }

}
