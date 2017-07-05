package cn.arvix.ontheway.ducuments.controller;

import cn.arvix.ontheway.ducuments.dto.QiniuImgEditDTO;
import cn.arvix.ontheway.ducuments.entity.Document;
import cn.arvix.ontheway.ducuments.service.DocumentService;
import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.utils.Checks;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.base.common.web.controller.ExceptionHandlerController;
import com.google.common.collect.Lists;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * @author Created by yangyang on 2017/3/31.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@Controller
@RequestMapping(value = "/api/v1/web/document")
public class DocumentController extends ExceptionHandlerController {

    private DocumentService service;

    @Autowired
    public void setService(DocumentService service) {
        this.service = service;
    }

    @ApiOperation(value = "文件移动", notes = "把id 文件 移动 到 moveId 文件夹下，moveId = -1 表示把id 文件 移动到根节点")
    @RequestMapping(value = "/move/{id}/to/{moveId}", method = RequestMethod.PUT)
    @ResponseBody
    public JSONResult move(@PathVariable Long id,
                           @PathVariable Long moveId) {
        return service.move(id, moveId);
    }

    /**
     * 获取当前用户可以查看的文件与文件夹，如果上传到根目录的文件是可以
     * 所有用户访问的
     */
    @ApiOperation(value = "获取用户的文件与文件夹", notes = "根节点下的文件可以所有用户访问 <br/> " +
            "这里所有用户指当前saas用户组织下的所有用户 <br/> " +
            "当前页number=-1时，获取所有数据，number可以根据正常分页形式文件数据（文件夹不分页，如果请求number>0,不会再次获取文件夹数据）" +
            "order 排序字段  默认按创建时间ASC排序 创建时间：dateCreated <br/> " +
            "数据说明 <br/> " +
            "body中包含documents 和 documentDirs 数据 <br/> " +
            "`documents` 文档数据 <br/> " +
            "`documentDirs` 文件夹数据 `hasChildren` 是否拥有下级  `parentId` 上级节点ID `lastUpdated` 最近更新时间 `dateCreated` 创建时间 " +
            "`IfDelete` true允许删除 false 不允许 `name` 文件夹名称 `ifCreate` true允许创建下级文件夹 false不允许创建 <br/> " +
            "其他说明：默认情况下，公共文件夹(documentDirType=common)、附件文件夹(documentDirType=attachment)不允许删除，附件文件夹不允许添加下级，" +
            "公共文件夹文件夹下所有文件对当前公司下的所有用户共享，用户可上传文件与下载文件")
    @ResponseBody
    @RequestMapping(value = "/user", method = RequestMethod.GET)
    @ApiImplicitParams(value = {
            @ApiImplicitParam(value = "当前页", name = "number", required = true, paramType = "query"),
            @ApiImplicitParam(value = "每页大小", name = "size", paramType = "query"),
            @ApiImplicitParam(value = "排序方式", name = "direction", dataType = "String", paramType = "query"),
            @ApiImplicitParam(value = "排序字段", name = "order", dataType = "String", paramType = "query"),
            @ApiImplicitParam(value = "当前页父节点", name = "pId", paramType = "query")
    })
    public JSONResult user(Integer number, Integer size, Sort.Direction direction, String order, Long pId) {
        return service.user(number, size, direction, order, pId);
    }

    /**
     * 通过ID获取文件下载路径
     *
     * @return 下载路径
     */
    @ResponseBody
    @RequestMapping(value = "/url/{id}", method = RequestMethod.GET)
    @ApiOperation(value = "获取某个Id的文件下载路径", notes = "fix会对文件路径进行修饰，例如图片增加 imageView2/2/w/200/h/200 ")
    @ApiImplicitParam(value = "文件修饰", name = "fix", paramType = "query")
    public JSONResult documentUrlById(@PathVariable Long id, String fix) {
        return service.documentUrlById(id, fix);
    }

    /**
     * 通过ID获取文件下载路径
     *
     * @return 下载路径
     */
    @ResponseBody
    @RequestMapping(value = "/url", method = RequestMethod.GET)
    @ApiOperation(value = "获取某个Id的文件下载路径", notes = "fix会对文件路径进行修饰，例如图片增加 imageView2/2/w/200/h/200, ids 多个文件Id 使用  ")
    @ApiImplicitParams(value = {
            @ApiImplicitParam(value = "文件修饰", name = "fix", paramType = "query"),
            @ApiImplicitParam(value = "文件Ids", name = "ids", required = true, paramType = "query")
    })
    public JSONResult documentUrlByIds(String ids, String fix) {
        if (StringUtils.isEmpty(ids)) return JsonUtil.getFailure(CommonContact.NOT_FUND, CommonContact.NOT_FUND_CODE);
        String[] strings = ids.split(",");
        List<Long> longList = Lists.newArrayList();
        for (String str : strings) {
            Long l = Checks.toLong(str);
            if (l != null) {
                longList.add(l);
            }
        }
        return service.documentUrlByIds(longList, fix);
    }

    @ResponseBody
    @RequestMapping(value = "/{id}/update/{property}", method = RequestMethod.PUT)
    @ApiOperation(value = "修改文件信息", notes = "property 属性    name 修改文件名   content 修改详细描述")
    public JSONResult update(@PathVariable Long id,
                             @PathVariable String property,
                             @RequestBody Document m) {
        m.setId(id);
        return service.updateDocument(m, property);
    }


    @RequestMapping(value = "/{id}/view", method = RequestMethod.GET)
    @ResponseBody
    @ApiOperation(value = "获取一个对象详情")
    public JSONResult view(@PathVariable Long id) {
        //        SecurityUtils.getSubject().checkPermission(service.getEntityName() + ":tab:view");
        return service.findOneDocument(id);
    }

    /**
     * 创建
     *
     * @param m 实体对象
     * @return 处理结果
     */
    @ResponseBody
    @RequestMapping(value = "/create", method = RequestMethod.POST)
    @ApiOperation(value = "创建")
    public JSONResult create(@RequestBody Document m) {
        return service.save_(m);
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
    public JSONResult del(@PathVariable(value = "id") Long id) {
        //SecurityUtils.getSubject().checkPermission(service.getEntityName() + ":tab:del");
        return service.delete_(id);
    }

    @RequestMapping(value = "/delMore", method = RequestMethod.DELETE)
    @ResponseBody
    @ApiOperation(value = "多项删除")
    public JSONResult deLMore(@RequestBody Long[] idList) {
        //SecurityUtils.getSubject().checkPermission(service.getEntityName() + ":tab:del");
        if (idList != null && idList.length > 0) {
            if (Checks.empty(Checks.toLong(idList[0].toString()) == null)) {
                return service.delete_(idList);
            } else {
                Long[] ids = new Long[idList.length];
                for (int i = 0, n = idList.length; i < n; i++) {
                    ids[i] = Long.parseLong(idList[i].toString());
                }
                return service.delete_(ids);
            }
        }
        return JsonUtil.getFailure(CommonContact.NOT_FUND_CODE, CommonContact.NOT_FUND_CODE);
    }

    //图片旋转
    @RequestMapping(value = "/qiniu/rotate", method = RequestMethod.PUT)
    @ResponseBody
    @ApiOperation(value = "七牛图片旋转")
    public JSONResult qiniuRotate(@RequestBody QiniuImgEditDTO dto) {
        return service.qiniuRotate(dto);
    }

    //图片裁剪
    @RequestMapping(value = "/qiniu/cut", method = RequestMethod.PUT)
    @ResponseBody
    @ApiOperation(value = "七牛图片裁剪")
    public JSONResult qiniuCut(@RequestBody QiniuImgEditDTO dto) {
        return service.qiniuCut(dto);
    }

}
