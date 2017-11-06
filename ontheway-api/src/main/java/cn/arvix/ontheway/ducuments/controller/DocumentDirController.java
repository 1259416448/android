package cn.arvix.ontheway.ducuments.controller;

import cn.arvix.ontheway.ducuments.entity.DocumentDir;
import cn.arvix.ontheway.ducuments.service.DocumentDirService;
import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.web.controller.BaseCRUDController;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author Created by yangyang on 2017/3/31.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@Controller
@RequestMapping(value = "/api/v1/web/document/dir")
public class DocumentDirController extends BaseCRUDController<DocumentDir, DocumentDirService, Long> {

    @Autowired
    public DocumentDirController(DocumentDirService service) {
        super(service);
    }

    @ApiOperation(value = "文件夹移动", notes = "把id 文件夹 移动 到 moveId 文件夹下，moveId = -1 表示把id 文件夹 移动到根节点" +
            "特定的公共文件夹、附件文件夹不允许移动<br/>" +
            "不能移动到当前文件夹的子文件夹下")
    @RequestMapping(value = "/move/{id}/to/{moveId}", method = RequestMethod.PUT)
    @ResponseBody
    public JSONResult move(@PathVariable Long id,
                           @PathVariable Long moveId) {
        return service.move(id, moveId);
    }

    @ApiOperation(value = "通过ID获取面包屑内容", notes = "{name:'',id:''}")
    @ResponseBody
    @RequestMapping(value = "/{id}/breadcrumb", method = RequestMethod.GET)
    public JSONResult breadcrumb(@PathVariable Long id) {
        return service.getParentInfoByChildId(id);
    }

}
