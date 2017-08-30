package cn.arvix.ontheway.business.dto;

import cn.arvix.base.common.service.exception.DataCheckException;
import cn.arvix.base.common.utils.HibernateValidationUtil;
import org.apache.commons.lang3.StringUtils;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.util.ClientUtils;

import javax.validation.constraints.NotNull;
import java.util.Iterator;
import java.util.Set;

/**
 * Solr查询DTO
 * @author Created by yangyang on 2017/8/29.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class SolrSearchDTO {

    //查询条件
    private String q;

    //当前页
    @NotNull(message = "number is not null")
    private Integer number;

    //每页大小
    @NotNull(message = "size is not null")
    private Integer size;

    //纬度
    @NotNull(message = "latitude is not null")
    private Double latitude;

    //经度
    @NotNull(message = "longitude is not null")
    private Double longitude;

    //检索距离
    @NotNull(message = "distance is not null")
    private Double distance;

    //当前检索截止时间
    @NotNull(message = "currentTime is not null")
    private Long currentTime;

    //过滤类型
    private Set<Long> typeIds;

    public static SolrSearchDTO getInstance(String q, Integer number, Integer size,
                             Double latitude, Double longitude, Double distance,
                             Long currentTime, Set<Long> typeIds){
        return new SolrSearchDTO(q, number, size, latitude, longitude, distance, currentTime, typeIds);
    }

    public SolrSearchDTO(String q, Integer number, Integer size,
                         Double latitude, Double longitude, Double distance,
                         Long currentTime, Set<Long> typeIds) {
        this.q = q;
        this.number = number;
        this.size = size;
        this.latitude = latitude;
        this.longitude = longitude;
        this.distance = distance;
        this.currentTime = currentTime;
        this.typeIds = typeIds;
    }

    /**
     * 获取 SolrQuery 对象
     * @return 获取查询对象
     */
    public SolrQuery getQuery() {

        //验证查询条件是否全部满足
        StringBuilder builder = HibernateValidationUtil.validateModel(this);
        if(StringUtils.isNotEmpty(builder.toString())){
            throw new DataCheckException(builder.toString());
        }
        SolrQuery query = new SolrQuery();
        if (StringUtils.isNotEmpty(q)) {
            query.set("q", "text:" + ClientUtils.escapeQueryChars(q));
        } else {
            query.set("q", "*:*");
        }
        //设置默认排序方式 距离最近 weight
        query.addSort("weight", SolrQuery.ORDER.desc); //权重排名最靠前
        query.addSort("geodist()", SolrQuery.ORDER.asc);

        //设置过滤条件
        if (typeIds != null && typeIds.size() > 0) {
            builder = new StringBuilder();
            builder.append("(");
            Iterator<Long> iterator = typeIds.iterator();
            while (iterator.hasNext()) {
                builder.append(iterator.next());
                if (iterator.hasNext()) {
                    builder.append(" AND ");
                }
            }
            builder.append(")");
            builder.insert(0, "type_ids:");
            query.add("fq", builder.toString());
        }
        query.add("fq", "{!geofilt}");
        query.add("fq", "date_created:[* TO " + currentTime + "]");

        //设置当前分页
        if (number < 0) number = 0;
        if (size < 1 || size > 30) size = 30;
        query.setStart(number * size);
        query.setRows(size);

        //设置数据格式
        query.add("wt", "json");

        //设置空间检索信息
        query.add("pt", latitude + "," + longitude);
        query.add("sfield", "poi_location_p");
        query.add("d", distance.toString());

        //设置fl
        query.add("fl","*,_dist_:geodist(),score");

        return query;

    }


    public String getQ() {
        return q;
    }

    public void setQ(String q) {
        this.q = q;
    }

    public Integer getNumber() {
        return number;
    }

    public void setNumber(Integer number) {
        this.number = number;
    }

    public Integer getSize() {
        return size;
    }

    public void setSize(Integer size) {
        this.size = size;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public Double getDistance() {
        return distance;
    }

    public void setDistance(Double distance) {
        this.distance = distance;
    }

    public Long getCurrentTime() {
        return currentTime;
    }

    public void setCurrentTime(Long currentTime) {
        this.currentTime = currentTime;
    }

    public Set<Long> getTypeIds() {
        return typeIds;
    }

    public void setTypeIds(Set<Long> typeIds) {
        this.typeIds = typeIds;
    }
}
