package cn.arvix.ontheway.business.controller;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.utils.Checks;
import cn.arvix.base.common.web.controller.ExceptionHandlerController;
import cn.arvix.ontheway.business.dto.CreateAndClaimDTO;
import cn.arvix.ontheway.business.entity.Business;
import cn.arvix.ontheway.business.service.BusinessService;
import com.google.common.collect.Sets;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
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
    @GetMapping(value = "/search")
    @ApiImplicitParams(value = {
            @ApiImplicitParam(value = "查询类型", name = "type", required = true, paramType = "query"),
            @ApiImplicitParam(value = "当前页", name = "number", required = true, paramType = "query"),
            @ApiImplicitParam(value = "每页大小", name = "size", required = true, paramType = "query"),
            @ApiImplicitParam(value = "纬度", name = "latitude", required = true, paramType = "query"),
            @ApiImplicitParam(value = "经度", name = "longitude", required = true, paramType = "query"),
            @ApiImplicitParam(value = "开始分页时间", name = "currentTime", paramType = "query"),
            @ApiImplicitParam(value = "检索的半径范围 km", name = "distance", paramType = "query"),
            @ApiImplicitParam(value = "查询参数", name = "q", paramType = "query"),
            @ApiImplicitParam(value = "类型过滤参数", name = "typeIds", paramType = "query")
    })
    public JSONResult search(BusinessService.SearchType type, Integer number, Integer size,
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

}
