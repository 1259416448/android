package cn.arvix.base.common.web.controller;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.exception.BaseException;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.base.common.utils.MessageUtils;
import org.apache.shiro.authz.UnauthorizedException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author Created by yangyang on 16/8/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

//@ControllerAdvice 为了打印日志 使用extends。
public class ExceptionHandlerController {

    protected final Logger log = LoggerFactory.getLogger(this.getClass());

    /**
     * 全局处理Exception
     *
     * @param e 异常信息
     * @return 异常信息
     */
    @ExceptionHandler(value = {Exception.class})
    @ResponseBody
    public JSONResult handleOtherExceptions(final Exception e) {
        log.error("creat checks exception , messageCode: system.error , message: " + e, e);
        if (e instanceof BaseException) {
            return JsonUtil.getFailure(e.getMessage(), ((BaseException) e).getCode());
        } else if (e instanceof UnauthorizedException) {
            return JsonUtil.getFailure(MessageUtils.message(CommonContact.NO_PERMISSION), CommonContact.NO_PERMISSION);
        } else {
            return JsonUtil.getFailure(e.toString(), CommonContact.SERVICE_ERROR_CODE);
        }
    }
}
