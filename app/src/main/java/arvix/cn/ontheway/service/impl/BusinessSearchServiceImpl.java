package arvix.cn.ontheway.service.impl;

import android.content.Context;
import android.util.Log;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.TypeReference;
import com.alibaba.fastjson.util.TypeUtils;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import org.xutils.common.Callback;
import org.xutils.http.RequestParams;
import org.xutils.x;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import arvix.cn.ontheway.bean.BaseResponse;
import arvix.cn.ontheway.bean.BusinessBean;
import arvix.cn.ontheway.bean.FootPrintBean;
import arvix.cn.ontheway.bean.FootPrintSearchVo;
import arvix.cn.ontheway.bean.Pagination;
import arvix.cn.ontheway.http.ServerUrl;
import arvix.cn.ontheway.service.inter.FootPrintSearchNotify;
import arvix.cn.ontheway.service.inter.FootPrintSearchService;
import arvix.cn.ontheway.test.ARViewTest;
import arvix.cn.ontheway.utils.StaticMethod;
import arvix.cn.ontheway.utils.StaticVar;

/**
 * Created by asdtiang on 2017/8/9 0009.
 * asdtiangxia@163.com
 */
//
public class BusinessSearchServiceImpl implements FootPrintSearchService<BusinessBean> {

    private static long lastRequest = 0;

    /**
     *
     * @param context
     * @param trackSearchVo
     * @return
     */
//    @Override
//    public void search(final Context context, final FootPrintSearchVo trackSearchVo, final FootPrintSearchNotify<FootPrintBean, F> trackSearchNotify) {
//        if((System.currentTimeMillis()-lastRequest)<200){
//            return;
//        }
//        lastRequest = System.currentTimeMillis();
//        RequestParams requestParams = new RequestParams();
//        String url = ServerUrl.FOOTPRINT_SEARCH;
//        if(SearchType.ar == trackSearchVo.getSearchType()){
//            url = url + "/ar";
//        }else if(SearchType.map == trackSearchVo.getSearchType()){
//            url = url + "/map";
//        }else{
//            url = url + "/list";
//        }
//        requestParams.setUri(url);
//        requestParams.setCacheMaxAge(60000);
//        requestParams.addParameter("number", trackSearchVo.getNumber());
//        requestParams.addParameter("size", trackSearchVo.getSize());
//        requestParams.addParameter("latitude", trackSearchVo.getLatitude());
//        requestParams.addParameter("longitude", trackSearchVo.getLongitude());
//        if (trackSearchVo.getCurrentTime()>0) {
//            requestParams.addParameter("currentTime", trackSearchVo.getCurrentTime());
//        }
//        if(trackSearchVo.getSearchDistance()!=null){
//            requestParams.addParameter("searchDistance", trackSearchVo.getSearchDistance());
//        }
//        if(trackSearchVo.getSearchTime()!=null){
//            requestParams.addParameter("time", trackSearchVo.getSearchTime());
//        }
//        requestParams.addParameter("typeIds","咖啡");
//        x.http().get(requestParams, new Callback.CommonCallback<String>() {
//            @Override
//            public void onSuccess(String result) {
//                try {
//                    Log.i("onSuccess-->", "result->" + result.toString());
//                    BaseResponse<Pagination<FootPrintBean>> response =  JSON.parseObject(result,new TypeReference<BaseResponse<Pagination<FootPrintBean>>>(){});
//                    if (response.getCode() == StaticVar.SUCCESS) {
//                        JSONObject jsonObject = response.getBody();
//                        Pagination paginationReturn = TypeUtils.castToJavaBean(jsonObject,Pagination.class);
//                        if(paginationReturn!=null&&paginationReturn.getContent()!=null){
//                            List<JSONObject> jsonArray =  (List<JSONObject>) paginationReturn.getContent();
//                            List<FootPrintBean> footPrintBeanList = new ArrayList<FootPrintBean>();
//                            for(JSONObject object :jsonArray){
//                                footPrintBeanList.add(TypeUtils.castToJavaBean(object,FootPrintBean.class));
//                            }
//                            paginationReturn.setContent(footPrintBeanList);
//                        }
//                        Log.i("trackSearchNotify-->", "trackSearchNotify------------------------->" );
//                        trackSearchVo.setCurrentTime(paginationReturn.getCurrentTime());
//                        trackSearchNotify.trackSearchDataFetchSuccess(trackSearchVo , paginationReturn);
//                    } else if (response.getCode() == StaticVar.ERROR) {
//                        StaticMethod.showToast("获取数据失败", context);
//                    } else {
//                        StaticMethod.showToast("获取数据失败" + response.getCode(), context);
//                    }
//                } catch (Exception e) {
//                    e.printStackTrace();
//                }
//
//            }
//            @Override
//            public void onError(Throwable throwable, boolean b) {
//            }
//            @Override
//            public void onCancelled(CancelledException e) {
//            }
//            @Override
//            public void onFinished() {
//            }
//        });
//    }



//    @Override
//    public void fetchByUser(final Context context,final FootPrintSearchVo searchVo, Long userId,final FootPrintSearchNotify<FootPrintBean, F> searchNotify) {
//        if((System.currentTimeMillis()-lastRequest)<200){
//            return;
//        }
//        lastRequest = System.currentTimeMillis();
//        RequestParams requestParams = new RequestParams();
//        String url = ServerUrl.FOOTPRINT_USER +"/" +userId;
//        requestParams.setUri(url);
//        requestParams.setCacheMaxAge(60000);
//        requestParams.addParameter("number", searchVo.getNumber());
//        requestParams.addParameter("size", searchVo.getSize());
//        if (searchVo.getCurrentTime()>0) {
//            requestParams.addParameter("currentTime", searchVo.getCurrentTime());
//        }
//        x.http().get(requestParams, new Callback.CommonCallback<String>() {
//            @Override
//            public void onSuccess(String result) {
//                try {
//                    Log.i("onSuccess-->", "result->" + result.toString());
//                    BaseResponse<Pagination<JSONObject>> response =  JSON.parseObject(result,new TypeReference<BaseResponse<Pagination<JSONObject>>>(){});
//                    if (response.getCode() == StaticVar.SUCCESS) {
//                        JSONObject jsonObject = response.getBody();
//                        Pagination paginationReturn = TypeUtils.castToJavaBean(jsonObject,Pagination.class);
//                        if(paginationReturn!=null&&paginationReturn.getContent()!=null){
//                            List<JSONObject> jsonArray =  (List<JSONObject>) paginationReturn.getContent();
//                            List<FootPrintBean> footPrintBeanList = new ArrayList<FootPrintBean>();
//                            FootPrintBean tempBean = null;
//                            JSONArray monthData;
//                            for(JSONObject object :jsonArray){
//                                int month = object.getInteger("month");
//                                monthData = object.getJSONArray("monthData");
//                                for(Object footBean : monthData){
//                                    tempBean = TypeUtils.castToJavaBean(footBean,FootPrintBean.class);
//                                    tempBean.setMonth(month);
//                                    if(tempBean.getDay()!=null){
//                                        if(tempBean.getDay().equals("今天")){
//                                            tempBean.setDayInt(Calendar.getInstance().get(Calendar.DAY_OF_MONTH));
//                                        }else{
//                                            tempBean.setDayInt(Integer.parseInt(tempBean.getDay().replace("日","")));
//                                        }
//                                    }
//                                    footPrintBeanList.add(tempBean);
//                                }
//                            }
//                            paginationReturn.setContent(footPrintBeanList);
//                        }
//                        Log.i("trackSearchNotify-->", "trackSearchNotify------------------------->" );
//                        searchVo.setCurrentTime(paginationReturn.getCurrentTime());
//                        searchNotify.trackSearchDataFetchSuccess(searchVo , paginationReturn);
//                    } else if (response.getCode() == StaticVar.ERROR) {
//                        StaticMethod.showToast("获取数据失败", context);
//                    } else {
//                        StaticMethod.showToast("获取数据失败" + response.getCode(), context);
//                    }
//                } catch (Exception e) {
//                    e.printStackTrace();
//                }
//
//            }
//            @Override
//            public void onError(Throwable throwable, boolean b) {
//            }
//            @Override
//            public void onCancelled(CancelledException e) {
//            }
//            @Override
//            public void onFinished() {
//            }
//        });
//    }


    @Override
    public void search(final Context context, final FootPrintSearchVo trackSearchVo, final FootPrintSearchNotify<BusinessBean> trackSearchNotify) {
        if((System.currentTimeMillis()-lastRequest)<200){
            return;
        }
        lastRequest = System.currentTimeMillis();
        RequestParams requestParams = new RequestParams();
        String url = ServerUrl.BUSINESS;
        if(FootPrintSearchVo.SearchType.ar == trackSearchVo.getSearchType()){
            url = url + "/ar";
        }else if(FootPrintSearchVo.SearchType.map == trackSearchVo.getSearchType()){
            url = url + "/map";
        }else{
            url = url + "/list";
        }
        requestParams.setUri(url);
        requestParams.setCacheMaxAge(60000);
        trackSearchVo.setNumber(1);
        requestParams.addParameter("number", trackSearchVo.getNumber());
        requestParams.addParameter("size", trackSearchVo.getSize());
//        trackSearchVo.setLatitude(39.991489);
//        trackSearchVo.setLongitude(116.336025);
        requestParams.addParameter("latitude", trackSearchVo.getLatitude());
        requestParams.addParameter("longitude", trackSearchVo.getLongitude());
        if (trackSearchVo.getCurrentTime()>0) {
            requestParams.addParameter("currentTime", trackSearchVo.getCurrentTime());
        }
//        if(trackSearchVo.getSearchDistance()!=null){
//           // requestParams.addParameter("searchDistance", trackSearchVo.getSearchDistance());
//        }
//        if(trackSearchVo.getSearchTime()!=null){
//            requestParams.addParameter("time", trackSearchVo.getSearchTime());
//        }
        trackSearchVo.setDistance(1000.0);
        requestParams.addParameter("distance",trackSearchVo.getDistance());
//        requestParams.addParameter("q",trackSearchVo.getQ());
        requestParams.addParameter("typeIds",trackSearchVo.getTypeIds());
//        requestParams.addParameter("typeIds","咖啡");
        x.http().get(requestParams, new Callback.CommonCallback<String>() {
            @Override
            public void onSuccess(String result) {
                try {
                    Log.i("onSuccess-->", "result->" + result.toString());
                    BaseResponse<Pagination<BusinessBean>> response =  JSON.parseObject(result,new TypeReference<BaseResponse<Pagination<BusinessBean>>>(){});
                    if (response.getCode() == StaticVar.SUCCESS) {
                        JSONObject jsonObject = response.getBody();
                        Type type = new TypeToken<Pagination<BusinessBean>>(){}.getType();
                        Pagination paginationReturn = new Gson().fromJson(jsonObject.toJSONString(),type);
                        Log.i("trackSearchNotify-->", "trackSearchNotify------------------------->" );
                        trackSearchVo.setCurrentTime(paginationReturn.getCurrentTime());
                        trackSearchNotify.trackSearchDataFetchSuccess(trackSearchVo,paginationReturn, ARViewTest.handler);
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

    @Override
    public void fetchByUser(final Context context, final FootPrintSearchVo searchVo, Long userId, final FootPrintSearchNotify<BusinessBean> searchNotify) {
        if((System.currentTimeMillis()-lastRequest)<200){
            return;
        }
        lastRequest = System.currentTimeMillis();
        RequestParams requestParams = new RequestParams();
        String url = ServerUrl. BUSINESS +"/" +userId;
        requestParams.setUri(url);
        requestParams.setCacheMaxAge(60000);
        requestParams.addParameter("number", searchVo.getNumber());
        requestParams.addParameter("size", searchVo.getSize());
        requestParams.addParameter("latitude", searchVo.getLatitude());
        requestParams.addParameter("longitude", searchVo.getLongitude());
        if (searchVo.getCurrentTime()>0) {
            requestParams.addParameter("currentTime", searchVo.getCurrentTime());
        }
        if(searchVo.getSearchDistance()!=null){
            requestParams.addParameter("distance", searchVo.getDistance());
        }
//        if(searchVo.getSearchTime()!=null){
//            requestParams.addParameter("time", searchVo.getSearchTime());
//        }
//        requestParams.addParameter("q",searchVo.getQ());
        requestParams.addParameter("typeIds",searchVo.getTypeIds());
        x.http().get(requestParams, new Callback.CommonCallback<String>() {
            @Override
            public void onSuccess(String result) {
                try {
                    Log.i("onSuccess-->", "result->" + result.toString());
                    BaseResponse<Pagination<JSONObject>> response =  JSON.parseObject(result,new TypeReference<BaseResponse<Pagination<JSONObject>>>(){});
                    if (response.getCode() == StaticVar.SUCCESS) {
                        JSONObject jsonObject = response.getBody();
                        Pagination paginationReturn = TypeUtils.castToJavaBean(jsonObject,Pagination.class);
                        if(paginationReturn!=null&&paginationReturn.getContent()!=null){
                            List<JSONObject> jsonArray =  (List<JSONObject>) paginationReturn.getContent();
                            List<FootPrintBean> footPrintBeanList = new ArrayList<FootPrintBean>();
                            FootPrintBean tempBean = null;
                            JSONArray monthData;
                            for(JSONObject object :jsonArray){
                                int month = object.getInteger("month");
                                monthData = object.getJSONArray("monthData");
                                for(Object footBean : monthData){
                                    tempBean = TypeUtils.castToJavaBean(footBean,FootPrintBean.class);
                                    tempBean.setMonth(month);
                                    if(tempBean.getDay()!=null){
                                        if(tempBean.getDay().equals("今天")){
                                            tempBean.setDayInt(Calendar.getInstance().get(Calendar.DAY_OF_MONTH));
                                        }else{
                                            tempBean.setDayInt(Integer.parseInt(tempBean.getDay().replace("日","")));
                                        }
                                    }
                                    footPrintBeanList.add(tempBean);
                                }
                            }
                            paginationReturn.setContent(footPrintBeanList);
                        }
                        Log.i("trackSearchNotify-->", "trackSearchNotify------------------------->" );
                        searchVo.setCurrentTime(paginationReturn.getCurrentTime());
                        searchNotify.trackSearchDataFetchSuccess(searchVo , paginationReturn, ARViewTest.handler);
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
