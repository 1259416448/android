package cn.arvix.ontheway.sys.organization.controller;

import cn.arvix.ontheway.sys.organization.entity.Organization;
import cn.arvix.ontheway.sys.organization.service.OrganizationService;
import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.web.controller.BaseCRUDController;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author Created by yangyang on 2017/3/8.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 * @version 1.0
 */
@Controller
@RequestMapping(value = "/api/v1/organization")
public class OrganizationController extends BaseCRUDController<Organization, OrganizationService, Long> {

    @Autowired
    public OrganizationController(OrganizationService service) {
        super(service);
    }

    @ResponseBody
    @RequestMapping(value = "/tree", method = RequestMethod.GET)
    @ApiOperation(value = "获取树 数据 ztree", notes = "支持jQuery ztree 树插件")
    public JSONResult tree() {
        return service.tree();
    }

    @ResponseBody
    @RequestMapping(value = "/select", method = RequestMethod.GET)
    @ApiOperation(value = "获取下拉框选择数据", notes = "如果添加id数据，返回数据或过滤掉id节点及下级所有数据")
    @ApiImplicitParam(value = "需要过滤的节点ID", name = "id",
            paramType = "query", dataType = "java.lang.Long")
    public JSONResult select(Long id) {
        return service.select(id);
    }

    @ResponseBody
    @RequestMapping(value = "/sorter", method = RequestMethod.PUT)
    @ApiOperation(value = "部门排序", notes = "部门排序，当前排序部门ID，id顺序和排序顺序相同")
    public JSONResult sorter(@RequestBody Long[] ids) {
        return service.sorter(ids);
    }

}
