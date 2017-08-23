package cn.arvix.ontheway.business.controller;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.web.controller.ExceptionHandlerController;
import cn.arvix.ontheway.business.service.BusinessTypeService;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author Created by yangyang on 2017/8/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Controller
@RequestMapping(value = "/app/business/type")
public class AppBusinessTypeController extends ExceptionHandlerController {

    private BusinessTypeService service;

    @Autowired
    public void setService(BusinessTypeService service) {
        this.service = service;
    }

    @ResponseBody
    @ApiOperation(value = "获取所有的类型")
    @GetMapping(value = "/all")
    public JSONResult all() {
        return service.all();
    }

}
