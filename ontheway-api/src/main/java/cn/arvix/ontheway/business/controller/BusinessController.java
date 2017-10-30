package cn.arvix.ontheway.business.controller;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.web.controller.ExceptionHandlerController;
import cn.arvix.ontheway.business.entity.BusinessExpand;
import cn.arvix.ontheway.business.service.BusinessService;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

/**
 * @author Created by yangyang on 2017/8/28.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@RequestMapping(value = "/api/v1/business")
@Controller
public class BusinessController extends ExceptionHandlerController {

    private BusinessService service;

    @Autowired
    public void setService(BusinessService service) {
        this.service = service;
    }

    @ApiOperation(value = "导入商家数据到solr中")
    @GetMapping(value = "/import")
    @ResponseBody
    public JSONResult importToSolr() {
        return service.importDataToSolr();
    }

    @ApiOperation(value = "审核认领商家")
    @ResponseBody
    @PostMapping(value = "/approve/{businessId}/{status}")
    public JSONResult approveClaim(@PathVariable Long businessId,
                                   @PathVariable BusinessExpand.ClaimStatus status) {
        return service.approveClaim(businessId, status);
    }

}
