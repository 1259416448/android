package arvix.cn.ontheway.http;

import org.xutils.http.RequestParams;
import org.xutils.http.request.UriRequest;

/**
 * Created by asdtiang on 2017/8/3 0003.
 * asdtiangxia@163.com
 */

public interface HttpFilterInterface {

    void beforeRequest(RequestParams entity);
    <T> void afterRequest(UriRequest request, T result);
}
