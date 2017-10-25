package cn.arvix.ontheway.business.controller;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.utils.Checks;
import cn.arvix.base.common.web.controller.ExceptionHandlerController;
import cn.arvix.ontheway.business.dto.CreateAndClaimDTO;
import cn.arvix.ontheway.business.entity.Business;
import cn.arvix.ontheway.business.service.BusinessCheckInService;
import cn.arvix.ontheway.business.service.BusinessService;
import com.google.common.collect.Sets;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.Set;

/**
 * @author Created by yangyang on 2017/8/16.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Controller
@RequestMapping(value = "/app/business")
public class AppBusinessController extends ExceptionHandlerController {

    private BusinessService businessService;

    @Autowired
    public void setBusinessService(BusinessService businessService) {
        this.businessService = businessService;
    }

    private BusinessCheckInService businessCheckInService;

    @Autowired
    public void setBusinessCheckInService(BusinessCheckInService businessCheckInService) {
        this.businessCheckInService = businessCheckInService;
    }

    @ApiOperation(value = "用户添加并认领商家")
    @ResponseBody
    @PostMapping(value = "/create")
    public JSONResult create(@RequestBody CreateAndClaimDTO dto) {
        return businessService.createAndClaim(dto);
    }

    @ApiOperation(value = "app端抓取百度POI数据保存接口，当前接口必须指定类型")
    @ResponseBody
    @PostMapping(value = "/fetch/create")
    public JSONResult createFetchData(@RequestBody Business dto) {
        return businessService.createFetchData(dto);
    }


    @ApiOperation(value = "获取商家数据，分页获取", notes = "type 查询类型  ar list map <br/>" +
            "number 当前页 <br/>" +
            "size 每页大小 <br/>" +
            "latitude 当前地址纬度 <br/>" +
            "longitude 当前地址经度 <br/>" +
            "distance 范围距离 <br/>" +
            "currentTime 请求时间 <br/>" +
            "q 查询参数 <br/>" +
            "typeIds 类型过滤参数，多个类型请使用 英文 分号 ',' 隔开")
    @ResponseBody
    @GetMapping(value = "/search/{type}")
    @ApiImplicitParams(value = {
            @ApiImplicitParam(value = "当前页", name = "number", required = true, paramType = "query"),
            @ApiImplicitParam(value = "每页大小", name = "size", required = true, paramType = "query"),
            @ApiImplicitParam(value = "纬度", name = "latitude", required = true, paramType = "query"),
            @ApiImplicitParam(value = "经度", name = "longitude", required = true, paramType = "query"),
            @ApiImplicitParam(value = "开始分页时间", name = "currentTime", paramType = "query"),
            @ApiImplicitParam(value = "检索的半径范围 km", name = "distance", paramType = "query"),
            @ApiImplicitParam(value = "查询参数", name = "q", paramType = "query"),
            @ApiImplicitParam(value = "类型过滤参数", name = "typeIds", paramType = "query")
    })
    public JSONResult search(@PathVariable BusinessService.SearchType type, Integer number, Integer size,
                             Double latitude, Double longitude, Double distance, Long currentTime,
                             String q, String typeIds) {
        Set<Long> typeIdSet = null;
        if (StringUtils.isNotEmpty(typeIds)) {
            //把,分割的类型数据转换为 Set
            typeIdSet = Sets.newHashSet(Checks.toLongs(typeIds));
        }
        return businessService.search(type, number, size,
                latitude, longitude, distance, currentTime,
                q, typeIdSet);
    }

    @GetMapping(value = "/view/{id}")
    @ResponseBody
    @ApiOperation(value = "获取商家详情", notes = "商家信息 优惠信息 最近10条足迹信息 如果用户登陆 能获取当用户的收藏情况、签到情况、足迹中点赞情况")
    public JSONResult view(@PathVariable Long id) {
        return businessService.view(id);
    }

    @ApiOperation(value = "加载更多商家足迹信息", notes = "加载更多商家足迹信息")
    @ResponseBody
    @GetMapping(value = "/footprint/search/{id}")
    @ApiImplicitParams(value = {
            @ApiImplicitParam(value = "开始分页时间", name = "currentTime", paramType = "query"),
            @ApiImplicitParam(value = "当前页", name = "number", required = true, paramType = "query"),
            @ApiImplicitParam(value = "每页大小", name = "size", required = true, paramType = "query")
    })
    public JSONResult searchFootprint(@PathVariable Long id, Integer number, Integer size, Long currentTime) {
        return businessService.searchFootprint(id, number, size, currentTime);
    }

    @ApiOperation(value = "收藏接口", notes = "收藏状态下请求为删除 反之 收藏 id 商家ID")
    @PostMapping(value = "/like/{id}")
    @ResponseBody
    public JSONResult like(@ApiParam(value = "商家ID") @PathVariable Long id) {
        return businessService.like(id);
    }

    @ApiOperation(value = "用户收藏列表", notes = "分页获取用户收藏数据")
    @ApiImplicitParams(value = {
            @ApiImplicitParam(value = "当前页", name = "number", required = true, paramType = "query"),
            @ApiImplicitParam(value = "每页大小", name = "size", required = true, paramType = "query")
    })
    @ResponseBody
    @GetMapping(value = "/user/likes")
    public JSONResult userLike(int number, int size) {
        return businessService.userLike(number, size);
    }

    @ApiOperation(value = "商家的用户相册", notes = "用户相册数据，用户相册数据来至用户发布的足迹 " +
            "按dateCreated desc 顺序排列 id 商家ID，分页获取数据")
    @ResponseBody
    @GetMapping(value = "/user/photos/{id}")
    @ApiImplicitParams(value = {
            @ApiImplicitParam(value = "开始分页时间", name = "currentTime", paramType = "query"),
            @ApiImplicitParam(value = "当前页", name = "number", required = true, paramType = "query"),
            @ApiImplicitParam(value = "每页大小", name = "size", required = true, paramType = "query")
    })
    public JSONResult userPhotos(@PathVariable Long id, int number, int size, Long currentTime) {
        return businessService.userPhotos(id, number, size, currentTime);
    }

    @ApiOperation(value = "获取商家认领搜索数据", notes = "获取商家认领搜索数据 必须有查询关键字 q")
    @ResponseBody
    @GetMapping(value = "/claim/search")
    @ApiImplicitParams(value = {
            @ApiImplicitParam(value = "查询参数", name = "q", paramType = "query"),
            @ApiImplicitParam(value = "纬度", name = "latitude", paramType = "query"),
            @ApiImplicitParam(value = "经度", name = "longitude", paramType = "query"),
            @ApiImplicitParam(value = "当前页", name = "number", required = true, paramType = "query"),
            @ApiImplicitParam(value = "每页大小", name = "size", required = true, paramType = "query"),
            @ApiImplicitParam(value = "开始分页时间", name = "currentTime", paramType = "query")
    })
    public JSONResult searchClaim(String q,
                                  Integer number, Integer size,
                                  Double latitude, Double longitude,
                                  Long currentTime) {
        return businessService.searchClaim(number, size, latitude, longitude, currentTime, q);
    }

    @ApiOperation(value = "认领商家接口", notes = "认领商家")
    @ResponseBody
    @PostMapping(value = "/claim")
    public JSONResult claim(@RequestBody CreateAndClaimDTO dto) {
        return businessService.claim(dto);
    }

    @ApiOperation(value = "签到")
    @ResponseBody
    @PostMapping(value = "/checkIn/{businessId}")
    public JSONResult checkIn(@PathVariable Long businessId) {
        return businessCheckInService.checkIn(businessId);
    }

    @ApiOperation(value = "取消关注")
    @ResponseBody
    @PostMapping(value = "/cancel/{businessId}")
    public JSONResult cancel(@PathVariable Long businessId) {
        return businessCheckInService.cancel(businessId);
    }

}
