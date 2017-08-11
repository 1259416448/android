package arvix.cn.ontheway.service.impl;

import android.content.Context;
import android.util.Log;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.TypeReference;
import com.alibaba.fastjson.util.TypeUtils;
import org.xutils.common.Callback;
import org.xutils.http.RequestParams;
import org.xutils.x;

import java.util.ArrayList;
import java.util.List;

import arvix.cn.ontheway.bean.BaseResponse;
import arvix.cn.ontheway.bean.FootPrintBean;
import arvix.cn.ontheway.bean.Pagination;
import arvix.cn.ontheway.bean.FootPrintSearchVo;
import arvix.cn.ontheway.http.ServerUrl;
import arvix.cn.ontheway.service.inter.FootPrintSearchService;
import arvix.cn.ontheway.service.inter.FootPrintSearchNotify;
import arvix.cn.ontheway.ui.msg.SystemMsgActivity;
import arvix.cn.ontheway.utils.StaticMethod;
import arvix.cn.ontheway.utils.StaticVar;

/**
 * Created by asdtiang on 2017/8/9 0009.
 * asdtiangxia@163.com
 */

public class FootPrintSearchServiceImpl implements FootPrintSearchService {

    private static long lastRequest = 0;

    /**
     *
     * @param context
     * @param trackSearchVo
     * @return
     */
    @Override
    public void search(final Context context, final FootPrintSearchVo trackSearchVo, final FootPrintSearchNotify<FootPrintBean> trackSearchNotify) {
        if((System.currentTimeMillis()-lastRequest)<200){
            return;
        }
        lastRequest = System.currentTimeMillis();
        RequestParams requestParams = new RequestParams();
        String url = ServerUrl.FOOTPRINT_SEARCH;
        if(FootPrintSearchVo.SearchType.ar == trackSearchVo.getSearchType()){
            url = url + "/ar";
        }else if(FootPrintSearchVo.SearchType.map == trackSearchVo.getSearchType()){
            url = url + "/map";
        }else{
            url = url + "/list";
        }
        requestParams.setUri(url);
        requestParams.setCacheMaxAge(60000);
        requestParams.addParameter("number", trackSearchVo.getNumber());
        requestParams.addParameter("size", trackSearchVo.getSize());
        requestParams.addParameter("latitude", trackSearchVo.getLatitude());
        requestParams.addParameter("longitude", trackSearchVo.getLongitude());
        if(trackSearchVo.getSearchDistance()!=null){
            requestParams.addParameter("searchDistance", trackSearchVo.getSearchDistance());
        }
        if(trackSearchVo.getSearchTime()!=null){
            requestParams.addParameter("searchTime", trackSearchVo.getSearchTime());
        }
        x.http().get(requestParams, new Callback.CommonCallback<String>() {
            @Override
            public void onSuccess(String result) {
                try {
                    Log.i("onSuccess-->", "result->" + result.toString());
                    BaseResponse<Pagination<FootPrintBean>> response =  JSON.parseObject(result,new TypeReference<BaseResponse<Pagination<FootPrintBean>>>(){});
                    if (response.getCode() == StaticVar.SUCCESS) {
                        JSONObject jsonObject = response.getBody();
                        Pagination paginationReturn = TypeUtils.castToJavaBean(jsonObject,Pagination.class);
                        if(paginationReturn!=null&&paginationReturn.getContent()!=null){
                            List<JSONObject> jsonArray =  (List<JSONObject>) paginationReturn.getContent();
                            List<FootPrintBean> footPrintBeanList = new ArrayList<FootPrintBean>();
                            for(JSONObject object :jsonArray){
                                footPrintBeanList.add(TypeUtils.castToJavaBean(object,FootPrintBean.class));
                            }
                            paginationReturn.setContent(footPrintBeanList);
                        }
                        Log.i("trackSearchNotify-->", "trackSearchNotify------------------------->" );
                        trackSearchNotify.trackSearchDataFetchSuccess(trackSearchVo , paginationReturn);
                    } else if (response.getCode() == StaticVar.ERROR) {
                        StaticMethod.showToast("获取数据失败", context);
                    } else {
                        StaticMethod.showToast("获取数据失败" + response.getCode(), context);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

            }
            @Override
            public void onError(Throwable throwable, boolean b) {
            }
            @Override
            public void onCancelled(CancelledException e) {
            }
            @Override
            public void onFinished() {
            }
        });
    }
}
