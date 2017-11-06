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


    // ----- business类型错误代码 ------

    /**
     * 类型不存在
     */
    String BUSINESS_TYPE_PARENT_MISS = "000401";

    /**
     * 当前类型不允许变更parentId
     */
    String BUSINESS_TYPE_NOT_ALLOW_UPDATE_PARENT_ID = "000402";

    /**
     * 当前类型包含子类型，不允许删除
     */
    String BUSINESS_TYPE_HAS_CHILDREN = "000403";

    /**
     * 获取全文检索数据失败
     */
    String AR_SEARCH_SOLR_ERROR = "000404";

    /**
     * 商家数据不存在或ifShow = false
     */
    String BUSINESS_IS_NOT_FUND = "000405";

    /**
     * 当前商家有被认领或已提交过认领资料
     */

    String BUSINESS_CLAIM_FAILED = "000406";


}
