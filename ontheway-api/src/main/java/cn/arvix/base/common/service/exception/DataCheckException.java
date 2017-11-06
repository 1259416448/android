package cn.arvix.base.common.service.exception;

import cn.arvix.base.common.exception.BaseException;

/**
 * @author Created by yangyang on 2017/3/21.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class DataCheckException extends BaseException {
    public DataCheckException(String code, Object... args) {
        super("common", code, args, null);
    }
}
