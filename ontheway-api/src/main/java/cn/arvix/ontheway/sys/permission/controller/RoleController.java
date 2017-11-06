package cn.arvix.ontheway.sys.permission.controller;

import cn.arvix.ontheway.sys.permission.entity.Role;
import cn.arvix.ontheway.sys.permission.service.RoleService;
import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.utils.CommonPermission;
import cn.arvix.base.common.web.controller.BaseCRUDController;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

/**
 * @author Created by yangyang on 2017/3/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@Controller
@RequestMapping(value = "/api/v1/role")
public class RoleController extends BaseCRUDController<Role, RoleService, Long> {

    @Autowired
    public RoleController(RoleService service) {
        super(service);
    }

    @ApiImplicitParams(value = {
            @ApiImplicitParam(value = "当前页", name = "number", required = true, paramType = "query"),
            @ApiImplicitParam(value = "每页大小", name = "size", required = true, paramType = "query"),
            @ApiImplicitParam(value = "排序方式", name = "direction", dataType = "String", paramType = "query"),
            @ApiImplicitParam(value = "排序字段", name = "order", dataType = "String", paramType = "query"),
            @ApiImplicitParam(value = "查询字段", name = "q", dataType = "String", paramType = "query")
    })
    @ApiOperation(value = "角色列表分页获取", notes = "q 查询条件，允许通过name role进行查询")
    @RequestMapping(value = "/search", method = RequestMethod.GET)
    @ResponseBody
    @RequiresPermissions(value = CommonPermission.SYSTEM_AUTH_AND_ROLE)
    public JSONResult search(String q, Integer number, Integer size, Sort.Direction direction, String order) {
        return service.search(q, number, size, direction, order);
    }

    @ApiOperation(value = "角色资源关联接口", notes = "根据传入的资源id 数组进行关联，自动去掉旧的关联")
    @ResponseBody
    @RequestMapping(value = "/{id}/resource/save", method = RequestMethod.POST)
    @RequiresPermissions(value = CommonPermission.SYSTEM_AUTH_AND_ROLE)
    public JSONResult roleResourceSave(@ApiParam(value = "角色ID", required = true) @PathVariable Long id,
                                       @ApiParam(value = "资源ID数组") @RequestBody Long[] resourceIds) {
        return service.roleResourceSave(id, resourceIds);
    }

}
