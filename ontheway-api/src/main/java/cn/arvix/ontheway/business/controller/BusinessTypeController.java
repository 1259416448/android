package cn.arvix.ontheway.business.controller;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.web.controller.ExceptionHandlerController;
import cn.arvix.ontheway.business.entity.BusinessType;
import cn.arvix.ontheway.business.service.BusinessTypeService;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

/**
 * @author Created by yangyang on 2017/8/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Controller
@RequestMapping(value = "/api/v1/business/type")
public class BusinessTypeController extends ExceptionHandlerController {

    private BusinessTypeService service;

    @Autowired
    public void setService(BusinessTypeService service) {
        this.service = service;
    }

    @ResponseBody
    @ApiOperation(value = "创建类型")
    @PostMapping(value = "/create")
    public JSONResult create(@RequestBody BusinessType m) {
        return service.save_(m);
    }

    @ResponseBody
    @ApiOperation(value = "修改类型")
    @PutMapping(value = "/update/{id}")
    public JSONResult update(@PathVariable Long id, @RequestBody BusinessType m) {
        m.setId(id);
        return service.update_(m);
    }

    @ResponseBody
    @ApiOperation(value = "删除类型 不能删除已经关联过的商家的类型")
    @DeleteMapping(value = "/delete/{id}")
    public JSONResult delete(@PathVariable Long id) {
        return service.delete_(id);
    }


}
