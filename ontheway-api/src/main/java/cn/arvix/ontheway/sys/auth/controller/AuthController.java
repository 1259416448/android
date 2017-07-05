package cn.arvix.ontheway.sys.auth.controller;

import cn.arvix.ontheway.sys.auth.service.AuthService;
import cn.arvix.ontheway.sys.dto.AuthDataOneDTO;
import cn.arvix.ontheway.sys.dto.AuthUserOrganizationDTO;
import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.CommonPermission;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.base.common.web.controller.ExceptionHandlerController;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * @author Created by yangyang on 2017/3/19.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Controller
@RequestMapping(value = "/api/v1/auth")
public class AuthController extends ExceptionHandlerController {

    private final AuthService service;

    @Autowired
    public AuthController(AuthService service) {
        this.service = service;
    }

    @ResponseBody
    @RequestMapping(value = "/create", method = RequestMethod.POST)
    @ApiOperation(value = "授权", notes = "授权")
    @RequiresPermissions(value = CommonPermission.SYSTEM_AUTH_AND_ROLE)
    public JSONResult create(@RequestBody AuthUserOrganizationDTO dto) throws Exception {
        return service.saveAuth(dto);
    }

    @ResponseBody
    @RequestMapping(value = "/create/{opModule}/{opId}", method = RequestMethod.POST)
    @ApiOperation(value = "授权（单条实例数据授权）", notes = "授权 opModule 0 系统默认授权，请不要使用 1 documentDir ")
    public JSONResult createOne(@PathVariable Integer opModule, @PathVariable Long opId,
                                @RequestBody AuthDataOneDTO dto) throws Exception {
        return service.saveAuth(dto, opModule, opId);
    }

    @ResponseBody
    @RequestMapping(value = "/create/more/{opModule}/{opId}", method = RequestMethod.POST)
    @ApiOperation(value = "授权（单条实例数据授权）", notes = "授权 opModule 0 系统默认授权，请不要使用 1 documentDir，可以传多个")
    public JSONResult createMore(@PathVariable Integer opModule, @PathVariable Long opId,
                                 @RequestBody List<AuthDataOneDTO> dto) throws Exception {
        return service.saveAuth(dto, opModule, opId);
    }

    @ResponseBody
    @RequestMapping(value = "/create/init", method = RequestMethod.GET)
    @ApiOperation(value = "授权初始化", notes = "授权初始化")
    public JSONResult createInit() {
        return service.createInit();
    }

    @ResponseBody
    @RequestMapping(value = "/create/init/{opModule}/{opId}", method = RequestMethod.GET)
    @ApiOperation(value = "授权初始化(获取某条数据分权初始化数据)", notes = "授权初始化")
    public JSONResult createInitOne(@PathVariable Integer opModule, @PathVariable Long opId) {
        return service.createInit(opModule, opId);
    }

    /**
     * 删除
     *
     * @param id 删除ID
     * @return 删除结果
     */
    @RequestMapping(value = "/{id}/del", method = RequestMethod.DELETE)
    @ResponseBody
    @ApiOperation(value = "删除")
    @RequiresPermissions(value = CommonPermission.SYSTEM_AUTH_AND_ROLE)
    public JSONResult del(@PathVariable(value = "id") Long id) {
        return service.delete_(id);
    }

    @RequestMapping(value = "/{id}/update/{rId}", method = RequestMethod.PUT)
    @ResponseBody
    @ApiOperation(value = "更新角色")
    @RequiresPermissions(value = CommonPermission.SYSTEM_AUTH_AND_ROLE)
    public JSONResult updateRole(@PathVariable Long id, @PathVariable Long rId) {
        return service.updateRole(id, rId);
    }

    @RequestMapping(value = "/delMore", method = RequestMethod.DELETE)
    @ResponseBody
    @ApiOperation(value = "多项删除")
    @RequiresPermissions(value = CommonPermission.SYSTEM_AUTH_AND_ROLE)
    public JSONResult deLMore(@RequestBody Long[] idList) {
        //SecurityUtils.getSubject().checkPermission(service.getEntityName() + ":tab:del");
        if (idList != null && idList.length > 0) {
            return service.delete_(idList);
        }
        return JsonUtil.getFailure(CommonContact.NOT_FUND_CODE, CommonContact.NOT_FUND_CODE);
    }

    @ApiOperation(value = "获取所有的角色分派列表", notes = "目前只提供按用户登录名（username、email、mobilePhoneNumber）和组织机构名称进行检索，查询参数q")
    @ApiImplicitParams(value = {
            @ApiImplicitParam(value = "当前页", name = "number", required = true, paramType = "query"),
            @ApiImplicitParam(value = "每页大小", name = "size", required = true, paramType = "query"),
            @ApiImplicitParam(value = "排序方式", name = "direction", dataType = "String", paramType = "query"),
            @ApiImplicitParam(value = "排序字段", name = "order", dataType = "String", paramType = "query"),
            @ApiImplicitParam(value = "查询字段", name = "q", dataType = "String", paramType = "query")
    })
    @ResponseBody
    @RequestMapping(value = "/search", method = RequestMethod.GET)
    @RequiresPermissions(value = CommonPermission.SYSTEM_AUTH_AND_ROLE)
    public JSONResult search(String q, Integer number, Integer size, Sort.Direction direction, String order) {
        return service.search(q, number, size, direction, order);
    }
}
