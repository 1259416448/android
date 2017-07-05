package cn.arvix.ontheway.sys.organization.controller;

import cn.arvix.ontheway.sys.dto.CompanyCreateDTO;
import cn.arvix.ontheway.sys.organization.entity.Company;
import cn.arvix.ontheway.sys.organization.service.CompanyService;
import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.web.controller.BaseCRUDController;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

/**
 * @author Created by yangyang on 2017/3/30.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@Controller
@RequestMapping(value = "/api/v1/company")
public class CompanyController extends BaseCRUDController<Company, CompanyService, Long> {

    @Autowired
    public CompanyController(CompanyService service) {
        super(service);
    }

    @RequestMapping(value = "/join", method = RequestMethod.POST)
    @ResponseBody
    @ApiOperation(value = "申请加入某个团队", notes = "申请加入团队功能暂未开发")
    public JSONResult join() {
        return null;
    }

    @RequestMapping(value = "/create/{username}", method = RequestMethod.POST)
    @ResponseBody
    @ApiOperation(value = "创建一个团队", notes = "saas用户创建团队，创建团队时需要添加 用户姓名，团队名称，<br>" +
            "以后需添加：如果未使用手机号注册，需要添加手机号")
    public JSONResult create(@PathVariable String username,
                             @RequestBody CompanyCreateDTO dto) {
        return service.create(username, dto);
    }

    @RequestMapping(value = "/view", method = RequestMethod.GET)
    @ResponseBody
    @ApiOperation(value = "直接获取当前登陆用户公司信息", notes = "获取公司的详细信息")
    public JSONResult view() {
        return service.view();
    }

}
