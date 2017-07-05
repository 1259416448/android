package cn.arvix.ontheway.sys.organization.entity;

import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.base.common.repository.support.annotation.EnableQueryCache;
import cn.arvix.base.common.utils.TimeMaker;
import com.google.common.collect.Maps;
import io.swagger.annotations.ApiModelProperty;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Transient;
import java.util.Map;

/**
 * saas表示一个公司，其他数据都关联当前公司，可以通过当前公司获取到数据
 *
 * @author Created by yangyang on 2017/3/27.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@Entity
@Table(name = "sys_company")
@EnableQueryCache
@org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Company extends BaseEntity<Long> {

    public static final String TABLE_NAME = "sys_company";

    /**
     * 公司名称
     */
    private String name;

    /**
     * 公司描述
     */
    private String info;

    /**
     * 公司总人数
     * 这里用于统计
     */
    private Integer sumPeople;

    /**
     * 是否显示
     */
    @Column(name = "is_show")
    private Boolean show = Boolean.FALSE;

    public String tableName() {
        return TABLE_NAME;
    }

    @ApiModelProperty(hidden = true)
    private transient Map<String, Object> objectMap;

    public Map<String, Object> getObjectMap() {
        if (objectMap == null) {
            objectMap = Maps.newHashMap();
        }
        return objectMap;
    }

    @Transient
    public Map<String, Object> toMap() {
        objectMap = Maps.newHashMap();
        objectMap.put("id", getId());
        objectMap.put("name", name);
        objectMap.put("info", info);
        objectMap.put("creater", getCreater());
        objectMap.put("dateCreated", TimeMaker.toDateTimeStr(getDateCreated()));
        objectMap.put("lastUpdated", TimeMaker.toDateTimeStr(getLastUpdated()));
        return objectMap;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getInfo() {
        return info;
    }

    public void setInfo(String info) {
        this.info = info;
    }

    public Integer getSumPeople() {
        return sumPeople;
    }

    public void setSumPeople(Integer sumPeople) {
        this.sumPeople = sumPeople;
    }

    public void setObjectMap(Map<String, Object> objectMap) {
        this.objectMap = objectMap;
    }

    public Boolean getShow() {
        return show;
    }

    public void setShow(Boolean show) {
        this.show = show;
    }
}
