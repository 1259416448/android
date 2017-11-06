package cn.arvix.ontheway.sys.user.exception;

import cn.arvix.base.common.exception.BaseException;

/**
 * @author Created by yangyang on 2017/3/21.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class UserException extends BaseException {
    public UserException(String code, Object... args) {
        super("user", code, args, null);
    }
}
