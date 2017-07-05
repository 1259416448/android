package cn.arvix.ontheway.sys.config.controller;

import cn.arvix.ontheway.sys.config.entity.Config;
import cn.arvix.ontheway.sys.config.service.ConfigService;
import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.web.controller.ExceptionHandlerController;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

/**
 * @author Created by yangyang on 2017/3/8.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Controller
@RequestMapping(value = "/api/v1/config")
public class ConfigController extends ExceptionHandlerController {

    private final ConfigService service;

    @Autowired
    public ConfigController(ConfigService configService) {
        this.service = configService;
    }

    @RequestMapping(value = "/search", method = RequestMethod.GET)
    @ResponseBody
    @ApiOperation(value = "获取网站配置数据")
    public JSONResult search() {
        return service.search();
    }

    @RequestMapping(value = "/{id}/update", method = RequestMethod.PUT)
    @ResponseBody
    @ApiOperation(value = "修改网站配置")
    public JSONResult update(@RequestBody Config m, @PathVariable Long id) {
        m.setId(id);
        return service.update_(m);
    }

}
