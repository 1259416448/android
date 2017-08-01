package cn.arvix.base.common.utils;

/**
 * @author Created by yangyang on 2017/7/6.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface CommonErrorCode {

    /**
     * 摘要信息错误
     */
    String DIGEST_ERROR = "000201";

    /**
     * 验证码发送操作频繁，请稍后再试
     */
    String FREQUENT_OPERATION = "000101";

    /**
     * 短信验证码发送错误
     */
    String SMS_CODE_SENT_ERROR = "000102";

    /**
     * 短信验证码过期
     */
    String SMS_CODE_TIMEOUT = "000103";

    /**
     * 短信验证码错误
     */
    String SMS_CODE_ERROR = "000104";

    /**
     * 注册手机号已被使用
     */
    String REGISTER_MOBILE_USED = "000105";

    /**
     * 足迹操作错误代码
     * 操作的不是自己的足迹
     */
    String FOOTPRINT_DELETE_NO_PERMISSION = "000201";

    /**
     * 足迹已被删除
     */
    String FOOTPRINT_ALREADY_DELETE = "000202";

    /**
     * 评论信息删除错误代码
     * 不能操作别人的评论
     */
    String COMMENT_DELETE_NO_PERMISSION = "000301";

}
