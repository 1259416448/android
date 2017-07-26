package cn.arvix.ontheway.footprint.controller;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.web.controller.ExceptionHandlerController;
import cn.arvix.ontheway.footprint.dto.FootprintCreateDTO;
import cn.arvix.ontheway.footprint.service.FootprintService;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

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

    @RequestMapping(value = "/create",method = RequestMethod.POST)
    @ResponseBody
    @ApiOperation(value = "足迹发布",notes = "足迹发布接口，dto数据说明 ")
    public JSONResult create(@RequestBody FootprintCreateDTO dto){
        return service.save(dto);
    }

}
