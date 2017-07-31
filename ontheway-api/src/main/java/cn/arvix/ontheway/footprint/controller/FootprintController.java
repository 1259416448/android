package cn.arvix.ontheway.footprint.controller;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.web.controller.ExceptionHandlerController;
import cn.arvix.ontheway.footprint.dto.FootprintCreateDTO;
import cn.arvix.ontheway.footprint.service.FootprintService;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

/**
 * @author Created by yangyang on 2017/7/26.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Controller
@RequestMapping(value = "/app/footprint")
public class FootprintController extends ExceptionHandlerController {

    private FootprintService service;

    @Autowired
    public void setService(FootprintService service) {
        this.service = service;
    }

    @RequestMapping(value = "/create", method = RequestMethod.POST)
    @ResponseBody
    @ApiOperation(value = "足迹发布", notes = "足迹发布接口，dto数据说明 ")
    public JSONResult create(@RequestBody FootprintCreateDTO dto) {
        return service.save(dto);
    }

    @RequestMapping(value = "/view/{id}", method = RequestMethod.POST)
    @ResponseBody
    @ApiOperation(value = "足迹详情", notes = "获取足迹详情")
    public JSONResult view(@PathVariable Long id) {
        return service.view(id);
    }

    @ResponseBody
    @ApiOperation(value = "点赞",notes = "点赞接口，如果已经点赞，再次请求取消点赞")
    @RequestMapping(value = "/like/{id}")
    public JSONResult like(@PathVariable Long id){
        return service.like(id);
    }

    @ApiOperation(value = "获取足迹列表数据", notes = "请求足迹时，需要所在位置信息，默认以时间（DESC）、距离(ASC)为条件进行排序展示<br>" +
            "筛选条件<br>" +
            "时间、距离，AR模式下，默认获取100m内数据 列表模式下时间参数和距离参数默认都不限制，" +
            "分页条件 列表模式下 每次返回15条数据  AR模式下 每次请求30条 平面地图模式 每次加载中心点到屏幕范围的数据 每次默认加载30条")
    @ResponseBody
    @RequestMapping(value = "/search/{type}", method = RequestMethod.GET)
    @ApiImplicitParams(value = {
            @ApiImplicitParam(value = "当前页", name = "number", required = true, paramType = "query"),
            @ApiImplicitParam(value = "每页大小", name = "size", required = true, paramType = "query"),
            @ApiImplicitParam(value = "纬度", name = "latitude", required = true, paramType = "query"),
            @ApiImplicitParam(value = "经度", name = "longitude", required = true, paramType = "query"),
            @ApiImplicitParam(value = "范围", name = "distance", required = false, paramType = "query"),
            @ApiImplicitParam(value = "时间", name = "time", required = false, paramType = "query")
    })
    public JSONResult search(@PathVariable FootprintService.SearchType type,
                             Integer number, Integer size,
                             Double latitude, Double longitude,
                             FootprintService.SearchDistance distance,
                             FootprintService.SearchTime time
    ) {
        return service.search(type, number, size, latitude, longitude, distance, time);
    }

}
