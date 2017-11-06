package cn.arvix.base.common.web.controller;

import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.service.BaseService;
import cn.arvix.base.common.utils.Checks;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.JsonUtil;
import com.alibaba.fastjson.JSON;
import io.swagger.annotations.ApiOperation;
import org.springframework.web.bind.annotation.*;

import java.io.Serializable;

/**
 * 基础数据操作类中未加入权限判断，如果需要验证权限，需自行在service方法中判断
 *
 * @author Created by yangyang on 2017/3/2.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@SuppressWarnings("unchecked")
public abstract class BaseCRUDController<M, S extends BaseService, ID extends Serializable>
        extends ExceptionHandlerController {

    protected final S service;

    public BaseCRUDController(S service) {
        this.service = service;
    }

    @RequestMapping(value = "/{id}/view", method = RequestMethod.GET)
    @ResponseBody
    @ApiOperation(value = "获取一个对象详情")
    public JSONResult view(@PathVariable ID id) {
        return service.findOne_(id);
    }

//    /**
//     * 列表数据获取
//     */
//    @RequestMapping(value = "/search", method = RequestMethod.GET)
//    @ResponseBody
//    public JSONResult search(PageInfo myPage, String[] orderbys, String[] orderbysDirection, M tempVo)
//            throws ChecksException {
//        SecurityUtils.getSubject().checkPermission(service.getEntityName() + ":tab:view");
//        checkCastToBaseEntity(tempVo);
//        return service.fixSearch(myPage, orderbys, orderbysDirection, (BaseEntity) tempVo);
//    }

    /**
     * 创建
     *
     * @param m 实体对象
     * @return 处理结果
     */
    @ResponseBody
    @RequestMapping(value = "/create", method = RequestMethod.POST)
    @ApiOperation(value = "创建")
    public JSONResult create(@RequestBody M m) {
        BaseEntity baseEntity = (BaseEntity) (JSON.parseObject(m.toString(), service.getEntityClass()));
        return service.save_(baseEntity);
    }

    /**
     * 修改
     *
     * @param id     数据ID
     * @param tempVo 待修改对象
     * @return 处理结果
     */
    @ResponseBody
    @RequestMapping(value = "/{id}/update", method = RequestMethod.PUT)
    @ApiOperation(value = "更新")
    public JSONResult update(@PathVariable(value = "id") ID id, @RequestBody M tempVo) {
        BaseEntity baseEntity = (BaseEntity) (JSON.parseObject(tempVo.toString(), service.getEntityClass()));
        baseEntity.setId(id);
        return service.update_(baseEntity);
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
    public JSONResult del(@PathVariable(value = "id") ID id) {
        return service.delete_(id);
    }

    @RequestMapping(value = "/delMore", method = RequestMethod.DELETE)
    @ResponseBody
    @ApiOperation(value = "多项删除")
    public JSONResult deLMore(@RequestBody ID[] idList) {
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
}
