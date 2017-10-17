package cn.arvix.ontheway.business.service;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.entity.ScheduleJob;
import cn.arvix.base.common.utils.Checks;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.QuartzJobUtil;
import cn.arvix.base.common.utils.TimeMaker;
import cn.arvix.ontheway.business.entity.Business;
import cn.arvix.ontheway.sys.utils.LocationUtils;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.google.common.collect.Sets;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.SchedulerException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.*;

/**
 * 自动抓取百度地图poi
 *
 * @author Created by yangyang on 2017/10/16.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@Service
public class BusinessAutoFetchService {

    private static final Logger logger = LoggerFactory.getLogger(BusinessAutoFetchService.class);

    private static final String AUTO_FETCH_INFO = "auto-fetch-info";

    private static final String BAIDU_MAP_PLACE_API = "http://api.map.baidu.com/place/v2/search";

    private Cache cache;

    @Autowired
    public void setCache(CacheManager cacheManager) {
        this.cache = cacheManager.getCache(AUTO_FETCH_INFO);
    }

    private BusinessTypeService businessTypeService;

    @Autowired
    public void setBusinessTypeService(BusinessTypeService businessTypeService) {
        this.businessTypeService = businessTypeService;
    }

    private QuartzJobUtil quartzJobUtil;

    @Autowired
    public void setQuartzJobUtil(QuartzJobUtil quartzJobUtil) {
        this.quartzJobUtil = quartzJobUtil;
    }

    private BusinessService businessService;

    @Autowired
    public void setBusinessService(BusinessService businessService) {
        this.businessService = businessService;
    }

    /**
     * 自动抓取操作方式
     * 1、判断当前latitude、longitude、typeIds是否已经在缓存队列中进行抓取操作,不存在，进行抓取
     * 2、如果typeIds值传入了1级，判断是否拥有下级，拥有时，将会默认抓取排序index = 0 的类型 构建成2级类别
     * 3、如果typeIds未传入，这是默认为当前所有类型的 第一级类别 index = 0 第二级类型 index = 0
     * 4、抓取数据将实时flush到数据库，为了确保数据尽量不出现重复。
     * 5、检索关键字都以二级关键字进行检索，只有当二级不存在时，使用一级关键字检索
     *
     * @param latitude  纬度
     * @param longitude 经度
     * @param typeIds   类型
     */
    public void startAutoFetch(Double latitude, Double longitude, Set<Long> typeIds) {
        if (typeIds == null) typeIds = Sets.newHashSet();
        String queryKey = getQueryKey(typeIds);
        String redisKey = getRedisKey(latitude, longitude, queryKey);
        Cache.ValueWrapper valueWrapper = cache.get(redisKey);
        if (valueWrapper != null) {
            String value = valueWrapper.get().toString();
            String[] strs = value.split("-");
            Double locLatitude = Double.valueOf(strs[0]);
            Double locLongitude = Double.valueOf(strs[0]);
            double distance = LocationUtils.getDistance(latitude, longitude, locLatitude, locLongitude);
            if (distance < 50.0) //100米范围内不执行重复抓取
                return;
        }
        //记录redis
        cache.put(redisKey, redisKey);

        int pageSize = 20;
        int pageNum = 0;

        String result = search(pageSize, pageNum, latitude, longitude, queryKey);

        logger.info("抓取结果json：{}", result);


        //抓取的结果写入数据库中

        JSONObject jsonObject = JSON.parseObject(result);

        int total = jsonObject.getIntValue("total");

        JSONArray jsonArray = jsonObject.getJSONArray("results");

        if (jsonArray.size() > 0) {
            Set<Long> finalTypeIds = typeIds;
            jsonArray.forEach(x -> {
                JSONObject one = (JSONObject) x;
                Business business = new Business();
                business.setName(one.getString("name"));
                business.setAddress(one.getString("address"));
                business.setContactInfo(one.getString("telephone"));
                business.setPoiUid(one.getString("uid"));
                JSONObject location = one.getJSONObject("location");
                business.setLatitude(location.getDouble("lat"));
                business.setLongitude(location.getDouble("lng"));
                JSONObject detail = one.getJSONObject("detail_info");
                business.setPoiDetailUrl(detail.getString("detail_url"));
                business.setTypeIds(finalTypeIds);
                businessService.createFetchData(business);
            });
            for (int i = 1; i < total / pageSize + 1; i++) {
                pageNum = i;
                result = search(pageSize, pageNum, latitude, longitude, queryKey);
                JSONObject jsonObject1 = JSON.parseObject(result);
                JSONArray jsonArray1 = jsonObject1.getJSONArray("results");
                if (jsonArray1.size() > 0) {
                    jsonArray1.forEach(x -> {
                        JSONObject one = (JSONObject) x;
                        Business business = new Business();
                        business.setName(one.getString("name"));
                        business.setAddress(one.getString("address"));
                        business.setContactInfo(one.getString("telephone"));
                        business.setPoiUid(one.getString("uid"));
                        JSONObject location = one.getJSONObject("location");
                        business.setLatitude(location.getDouble("lat"));
                        business.setLongitude(location.getDouble("lng"));
                        JSONObject detail = one.getJSONObject("detail_info");
                        business.setPoiDetailUrl(detail.getString("detail_url"));
                        business.setTypeIds(finalTypeIds);
                        businessService.createFetchData(business);
                    });
                } else {
                    break;
                }
            }
        }
        cache.evict(redisKey);
    }


    public String search(int pageSize, int pageNum, Double latitude, Double longitude, String queryKey) {

        //执行数据抓取操作
        String searchUrl = BAIDU_MAP_PLACE_API
                + "?" + "query=" + queryKey
                + "&location=" + latitude + "," + longitude
                + "&radius=1000"
                + "&output=json"
                + "&scope=2"
                + "&page_size=" + pageSize
                + "&page_num=" + pageNum
                + "&ak=" + CommonContact.BAIDU_MAP_AK;

        //创建httpclient对象
        CloseableHttpClient client = HttpClients.createDefault();

        HttpGet httpGet = new HttpGet(searchUrl);

        logger.info("抓取URL-> {}", searchUrl);

        try {
            HttpResponse response = client.execute(httpGet);
            HttpEntity resEntity = response.getEntity();
            if (resEntity != null) {
                return EntityUtils.toString(resEntity);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    private String getRedisKey(Double latitude, Double longitude, String queryKey) {
        return latitude + "-" + longitude + "-" + queryKey;
    }

    private String getQueryKey(Set<Long> typeIds) {
        String key = null;
        if (typeIds.size() == 0) {
            JSONResult jsonResult = businessTypeService.all();
            List<Map<String, Object>> body = jsonResult.getBody();
            if (body != null && body.size() > 0) {
                Map<String, Object> one = body.get(0);
                typeIds.add(Checks.toLong(one.get("id").toString()));
                if (one.get("children") != null) {
                    List<Map<String, Object>> two = (List<Map<String, Object>>) one.get("children");
                    if (two.size() > 0) {
                        key = two.get(0).get("name").toString();
                        typeIds.add(Checks.toLong(two.get(0).get("id").toString()));
                    } else {
                        key = one.get("name").toString();
                    }
                } else {
                    key = one.get("name").toString();
                }
            }
        } else {
            key = businessTypeService.findTypeByTypeIds_(typeIds);
        }
        logger.info("queryKey is {}", key);
        return key;
    }

    //定时任务执行接口
    public void startJob(JobExecutionContext context) {
        JobDataMap jobDataMap = context.getJobDetail().getJobDataMap();
        Double latitude = (Double) jobDataMap.get("data_0");
        Double longitude = (Double) jobDataMap.get("data_1");
        Set<Long> typeIds = (Set<Long>) jobDataMap.get("data_2");
        logger.info("自动抓取定时任务执行 latitude:{},longitude:{},typeIds:{}", latitude, longitude, typeIds != null ? Arrays.asList(typeIds.toArray()) : null);
        startAutoFetch(latitude, longitude, typeIds);
    }

    /**
     * 添加自动抓取任务
     *
     * @param latitude  纬度
     * @param longitude 经度
     * @param typeIds   类型
     */
    public void addJob(Double latitude, Double longitude, Set<Long> typeIds) {
        logger.info("添加自动抓取定时任务 latitude:{},longitude:{},typeIds:{}", latitude, longitude, typeIds != null ? Arrays.asList(typeIds.toArray()) : null);
        UUID uuid = UUID.randomUUID();
        //创建一个基础定时任务
        ScheduleJob scheduleJob = new ScheduleJob();
        scheduleJob.setJobName(uuid.toString());
        scheduleJob.setJobId("autoFetchBusinessData");
        scheduleJob.setJobGroup("business");
        scheduleJob.setJobStatus("1");
        scheduleJob.setDesc("定时任务，1秒后执行，执行1次");
        Long time = System.currentTimeMillis() + 1500;
        scheduleJob.setCronExpression(TimeMaker.getCron(time));
        scheduleJob.setTargetObject("businessAutoFetchService");
        scheduleJob.setTargetMethod("startJob");
        try {
            quartzJobUtil.addJob(scheduleJob, latitude, longitude, typeIds);
        } catch (SchedulerException e) {
            e.printStackTrace();
            logger.error("自动抓取定时任务添加失败", e);
        }
    }

}
