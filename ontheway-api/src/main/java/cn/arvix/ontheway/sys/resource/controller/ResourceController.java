package cn.arvix.ontheway.sys.resource.controller;

import cn.arvix.ontheway.sys.resource.entity.Resource;
import cn.arvix.ontheway.sys.resource.service.ResourceService;
import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.web.controller.BaseCRUDController;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author Created by yangyang on 2017/3/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@Controller
@RequestMapping(value = "/api/v1/resource")
public class ResourceController extends BaseCRUDController<Resource, ResourceService, Long> {

    @Autowired
    public ResourceController(ResourceService service) {
        super(service);
    }

    @ResponseBody
    @RequestMapping(value = "/tree", method = RequestMethod.GET)
    @ApiOperation(value = "获取树 数据 ztree", notes = "支持jQuery ztree 树插件，角色界面中选择资源时，请附加在角色ID，后台会增加原始选中节点")
    @ApiImplicitParam(name = "rId", value = "角色ID", paramType = "query")
    public JSONResult tree(Long rId) {
        return service.tree(rId);
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
    @RequestMapping(value = "/admin/column", method = RequestMethod.GET)
    @ApiOperation(value = "根据当前登陆用户获取管理端栏目", notes = "根据当前登陆用户获取管理端栏目")
    public JSONResult adminColumn() {
        return service.adminColumn();
    }

    @ResponseBody
    @RequestMapping(value = "/before/column", method = RequestMethod.GET)
    @ApiOperation(value = "根据当前登陆用户获取用户端栏目", notes = "根据当前登陆用户获取用户端栏目")
    public JSONResult beforeColumn() {
        return null;
    }

    @ResponseBody
    @RequestMapping(value = "/auth", method = RequestMethod.GET)
    @ApiOperation(value = "获取资源授权信息", notes = "获取资源授权信息")
    public JSONResult auth() {
        return service.auth();
    }

}
