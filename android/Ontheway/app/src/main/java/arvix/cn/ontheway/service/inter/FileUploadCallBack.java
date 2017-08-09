package arvix.cn.ontheway.service.inter;

import arvix.cn.ontheway.bean.BaseResponse;

/**
 * Created by asdtiang on 2017/8/7 0007.
 * asdtiangxia@163.com
 */

public interface FileUploadCallBack {
    /**
     * 如果上传图片指定uploadUrl，则返回服务器response。
     * uploadUrl为空时，返回 new BaseResponse();bodyBean设置为 QiniuBean
     * @param baseResponse
     */
    void uploadBack(BaseResponse baseResponse);
}
