package arvix.cn.ontheway.http;

import android.util.Log;

import org.xutils.http.HttpMethod;
import org.xutils.http.RequestParams;
import org.xutils.http.request.UriRequest;

import java.util.List;
import java.util.Map;

import arvix.cn.ontheway.service.inter.CacheService;
import arvix.cn.ontheway.utils.OnthewayApplication;
import arvix.cn.ontheway.utils.StaticVar;

/**
 * Created by asdtiang on 2017/8/3 0003.
 * asdtiangxia@163.com
 */

public class HttpFilterDefaultImpl implements   HttpFilterInterface{

    CacheService cache;

    public HttpFilterDefaultImpl(){
        cache = OnthewayApplication.getInstahce(CacheService.class);
    }

    @Override
    public void beforeRequest(RequestParams entity) {
        if(entity.getUri().startsWith(ServerUrl.BASE_URL)){
            String token = cache.get(StaticVar.AUTH_TOKEN);
            if(token!=null){
                entity.addHeader(StaticVar.AUTH_TOKEN,token);
            }
            String rememberMe = cache.get(StaticVar.AUTH_REMEMBER_ME);
            if(rememberMe!=null){
                entity.addHeader(StaticVar.AUTH_REMEMBER_ME,token);
            }
            // Content-Type: application/json
            if(entity.getMethod()== HttpMethod.POST){
                entity.addHeader("Content-Type","application/json");
            }
            //  Accept: application/json
            entity.addHeader("Accept","application/json");
        }
    }

    @Override
    public <T> void afterRequest(UriRequest request, T result) {
        if(request!=null){
            Map<String,List<String>>  responseHeaderMap = request.getResponseHeaders();
            if(responseHeaderMap!=null){
                for(Map.Entry<String,List<String>> entry : responseHeaderMap.entrySet()){
                    for(String v : entry.getValue()){
                        Log.i(entry.getKey()," value-->"+v);
                    }
                }
            }

            String xAuthToken = request.getResponseHeader(StaticVar.AUTH_TOKEN);
            if(xAuthToken != null){
                Log.i("put cache",StaticVar.AUTH_TOKEN +":" + xAuthToken);
                cache.put(StaticVar.AUTH_TOKEN,xAuthToken);
            }
            String rememberMe = request.getResponseHeader(StaticVar.AUTH_REMEMBER_ME);
            if(rememberMe != null){
                Log.i("put cache",StaticVar.AUTH_REMEMBER_ME +":" + rememberMe);
                cache.put(StaticVar.AUTH_REMEMBER_ME,rememberMe);
            }
        }
    }
}
