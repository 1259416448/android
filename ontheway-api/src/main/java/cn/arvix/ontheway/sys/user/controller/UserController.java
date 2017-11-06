package cn.arvix.ontheway.sys.user.controller;

import cn.arvix.ontheway.sys.dto.UserDTO;
import cn.arvix.ontheway.sys.dto.UserIdOrganizationIdDTO;
import cn.arvix.ontheway.sys.user.entity.User;
import cn.arvix.ontheway.sys.user.service.UserService;
import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.utils.Checks;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.base.common.web.controller.BaseCRUDController;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.*;
import springfox.documentation.annotations.ApiIgnore;

/**
 * @author Created by yangyang on 2017/3/8.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Controller
@RequestMapping(value = "/api/v1/user")
public class UserController extends BaseCRUDController<User, UserService, Long> {

    @Autowired
    public UserController(UserService service) {
        super(service);
    }

    @ResponseBody
    @RequestMapping(value = "/create", method = RequestMethod.POST)
    @ApiOperation(value = "创建", notes = "organizationIds 用户所属的组织机构数组")
    public JSONResult create(@RequestBody UserDTO userDTO) {
        return service.save_(userDTO);
    }

    /**
     * 去掉公共方法中 create 保证重写的方法请求url正确 此方法并没有什么实质性作用
     */
    @ApiIgnore
    @RequestMapping(value = "/override/create", method = RequestMethod.POST)
    public JSONResult create(@RequestBody User m) {
        return JsonUtil.getFailure(CommonContact.SERVICE_ERROR_CODE);
    }

    @ResponseBody
    @RequestMapping(value = "/{id}/update/all", method = RequestMethod.PUT)
    @ApiOperation(value = "修改", notes = "organizationIds 用户所属的组织机构数组")
    public JSONResult update(@RequestBody UserDTO userDTO, @PathVariable Long id) {
        Assert.notNull(userDTO.getUser(), "user is not null");
        userDTO.getUser().setId(id);
        return service.update_(userDTO);
    }

    @ResponseBody
    @RequestMapping(value = "/update/organization", method = RequestMethod.POST)
    @ApiOperation(value = "添加获取删除某个用户的某个团队")
    public JSONResult updateUserOrganization(@RequestBody UserIdOrganizationIdDTO userIdOrganizationIdDTO) {
        return service.removeOrAddOrganization(userIdOrganizationIdDTO.getUserId(),
                userIdOrganizationIdDTO.getOrganizationId());
    }

    @ApiImplicitParams(value = {
            @ApiImplicitParam(value = "当前页", name = "number", required = true, paramType = "query"),
            @ApiImplicitParam(value = "每页大小", name = "size", required = true, paramType = "query"),
            @ApiImplicitParam(value = "排序方式", name = "direction", dataType = "String", paramType = "query"),
            @ApiImplicitParam(value = "排序字段", name = "order", dataType = "String", paramType = "query"),
            @ApiImplicitParam(value = "查询字段", name = "q", dataType = "String", paramType = "query"),
            @ApiImplicitParam(value = "用户名称", name = "name", dataType = "String", paramType = "query"),
            @ApiImplicitParam(value = "组织机构（团队）ID", name = "oId", required = true, paramType = "query"),
    })
    @ApiOperation(value = "用户列表获取", notes = "q 查询条件，" +
            "允许通过q : username email mobilePhoneNumber进行检索，不支持模糊搜索<br/>" +
            "name : 通过name字段模糊检索<br/>" +
            "oId : 组织机构（团队）ID 如果当前值==0，默认获取当前用户所属组织机构（团队）下的所有用户 <br/>" +
            "如果 number（当前页传入数据为-1，查询时不分页按条件排序检索）")
    @RequestMapping(value = "/search", method = RequestMethod.GET)
    @ResponseBody
    public JSONResult search(String q, String name, Long oId,
                             Integer number, Integer size, Sort.Direction direction, String order) {
        Checks.assertSortProperty(order);
        return service.search(q, name, oId, number, size, direction, order);
    }

    @ApiOperation(value = "更新用户姓名", notes = "这里只提供用户姓名的更改，其他参数设置无效")
    @RequestMapping(value = "/update/name", method = RequestMethod.PUT)
    @ResponseBody
    public JSONResult updateName(@RequestBody User user) {
        return service.updateUserName(user);
    }

    @ApiOperation(value = "更新用户头像", notes = "这里只提供用户头像的更改，其他参数设置无效")
    @RequestMapping(value = "/update/headimg", method = RequestMethod.PUT)
    @ResponseBody
    public JSONResult updateHeadImg(@RequestBody User user) {
        return service.updateUserImg(user);
    }

    @ApiOperation(value = "把用户由某个部门移动到某个部门下", notes = "需要原部门ID 移动到的部门ID 用户ID")
    @RequestMapping(value = "/{uId}/move/{oId}/to/{mId}", method = RequestMethod.PUT)
    @ResponseBody
    public JSONResult move(@PathVariable Long uId,
                           @PathVariable Long oId,
                           @PathVariable Long mId) {
        return service.move(uId, oId, mId);
    }

}
