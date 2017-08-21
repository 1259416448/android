package cn.arvix.ontheway.business.controller;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.web.controller.ExceptionHandlerController;
import cn.arvix.ontheway.business.dto.CreateAndClaimDTO;
import cn.arvix.ontheway.business.service.BusinessService;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

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

}
