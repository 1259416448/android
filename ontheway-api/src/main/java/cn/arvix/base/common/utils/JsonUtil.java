package cn.arvix.base.common.utils;

import cn.arvix.base.common.entity.AbstractEntity;
import cn.arvix.base.common.entity.JSONResult;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Company ：FsPhoto
 * 获取JSONResult JSONResult数据:
 * message 消息
 * code 0 成功 -1 失败
 * messageCode 消息代码
 * body 数据
 *
 * @author Created by yangyang on 16/7/24.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class JsonUtil {

    private static final int CODE_SUCCESS = 0;

    private static final int CODE_FAILURE = -1;

    /**
     * 返回成功的JSONResult
     *
     * @param msg 信息
     * @return JSONResult
     */
    public static JSONResult getSuccess(String msg) {
        return getJSONResult(msg, null, CODE_SUCCESS, null);
    }

    /**
     * 返回成功的JSONResult
     *
     * @param msg     消息
     * @param msgCode 消息代码
     * @return JSONResult
     */
    public static JSONResult getSuccess(String msg, String msgCode) {
        return getJSONResult(msg, msgCode, CODE_SUCCESS, null);
    }

    /**
     * 获取操作成功数据。
     *
     * @param msg     消息
     * @param msgCode 消息代码
     * @param body    数据
     * @return JSONResult
     */
    public static JSONResult getSuccess(String msg, String msgCode, Object body) {
        return getJSONResult(msg, msgCode, CODE_SUCCESS, body);
    }

    /**
     * 获取成功数据操作
     *
     * @param msg  消息
     * @param body 数据
     * @return JSONResult
     */
    public static JSONResult getSuccess(String msg, Object body) {
        return getSuccess(msg, null, body);
    }

    /**
     * 返回失败的JSONResult
     *
     * @param msg 信息
     * @return JSONResult
     */
    public static JSONResult getFailure(String msg) {
        return getJSONResult(msg, null, CODE_FAILURE, null);
    }

    /**
     * 返回失败的JSONResult
     *
     * @param msg     消息
     * @param msgCode 消息代码
     * @return JSONResult
     */
    public static JSONResult getFailure(String msg, String msgCode) {
        return getJSONResult(msg, msgCode, CODE_FAILURE, null);
    }

    /**
     * 返回失败的JSONResult
     *
     * @param msg     消息
     * @param msgCode 消息代码
     * @param body    数据
     * @return JSONResult
     */
    public static JSONResult getFailure(String msg, String msgCode, Object body) {
        return getJSONResult(msg, msgCode, CODE_FAILURE, body);
    }

    /**
     * 返回失败的JSONResult
     *
     * @param msg  消息
     * @param body 数据
     * @return JSONResult
     */
    public static JSONResult getFailure(String msg, Object body) {
        return getFailure(msg, null, body);
    }

    /**
     * 获取JSONResult
     *
     * @param msg     消息
     * @param msgCode 消息代码
     * @param code    操作代码 0 成功 -1 失败
     * @param body    数据
     * @return JSONResult
     */
    private static JSONResult getJSONResult(String msg, String msgCode, int code, Object body) {
        JSONResult jsonResult = new JSONResult();
        jsonResult.setMessage(msg);
        jsonResult.setMessageCode(msgCode);
        jsonResult.setCode(code);
        jsonResult.setBody(body);
        jsonResult.setServerTime(System.currentTimeMillis());
        return jsonResult;
    }

    /**
     * 获取平台实体的toMap list.
     *
     * @param entityList 平台实体
     * @return List
     */
    public static List<Map<String,Object>> getBaseEntityMapList(List<?> entityList) {
        if (entityList != null && entityList.size() > 0) {
            List<Map<String, Object>> list = new ArrayList<>();
            entityList.forEach(x -> {
                if (x instanceof AbstractEntity) {
                    AbstractEntity c = (AbstractEntity) x;
                    @SuppressWarnings("unchecked") Map<String, Object> map = c.toMap();
                    if (map != null) {
                        list.add(map);
                    }
                }
            });
            return list;
        }
        return null;
    }

}
