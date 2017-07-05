package cn.arvix.qiniu.controller;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.qiniu.utils.QiniuUploadUtil;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
 * @author Created by yangyang on 2017/3/28.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@Controller
@RequestMapping(value = "/api/v1/qiniu")
public class QiniuController {

    private final QiniuUploadUtil qiniuUploadUtil;

    @Autowired
    public QiniuController(QiniuUploadUtil qiniuUploadUtil) {
        this.qiniuUploadUtil = qiniuUploadUtil;
    }

    /**
     * 获取七牛上传token
     *
     * @param type 类型 0 普通上传token 1 视频上传token 默认 7200s 2 覆盖上传 token
     * @param key  文件名
     * @return token
     */
    @RequestMapping(value = "/upToken", method = RequestMethod.GET)
    @ResponseBody
    @ApiOperation(value = "获取七牛上传token")
    @ApiImplicitParams(
            value = {
                    @ApiImplicitParam(value = "类型参数", name = "type", paramType = "query"),
                    @ApiImplicitParam(value = "重命名的文件名称，覆盖上传时使用", name = "key", paramType = "query")
            }
    )
    public JSONResult get_upToken(Integer type, String key) {
        Map<String, Object> jsonMap = new HashMap<>();
        if (type == null) type = 0;
        if (type == 0) { //普通上传token
            jsonMap.put("uptoken", qiniuUploadUtil.getUpToken());
        } else if (type == 1) { //视频token 有效时间 7200秒
            //jsonMap.put("uptoken", qiniuUploadUtil.getUpToken(null, 7200L));
        } else if (type == 2) { //覆盖上传
            jsonMap.put("uptoken", qiniuUploadUtil.getUpToken(key));
        }
        return JsonUtil.getSuccess("success", jsonMap);
    }

}
