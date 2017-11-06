package cn.arvix.base.common.entity;

import io.swagger.annotations.ApiModelProperty;
import org.apache.commons.lang3.builder.ReflectionToStringBuilder;
import org.springframework.data.domain.Persistable;

import javax.persistence.MappedSuperclass;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import java.io.Serializable;
import java.util.Date;
import java.util.Map;

/**
 * 抽象的公共entity类
 *
 * @author Created by yangyang on 2017/3/1.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@MappedSuperclass
public abstract class AbstractEntity<ID extends Serializable> implements Persistable<ID> {

    public abstract ID getId();

    public abstract void setId(final ID id);

    /**
     * 创建人 用户数据库ID采用Long类型
     */
    @ApiModelProperty(hidden = true)
    private String creater;

    /**
     * 数据创建时间
     */
    @Temporal(TemporalType.TIMESTAMP)
    @ApiModelProperty(hidden = true)
    private Date dateCreated;

    /**
     * 数据最近修改时间
     */
    @Temporal(TemporalType.TIMESTAMP)
    @ApiModelProperty(hidden = true)
    private Date lastUpdated;

    public String getCreater() {
        return creater;
    }

    public void setCreater(String creater) {
        this.creater = creater;
    }

    public Date getDateCreated() {
        return dateCreated;
    }

    public void setDateCreated(Date dateCreated) {
        this.dateCreated = dateCreated;
    }

    public Date getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(Date lastUpdated) {
        this.lastUpdated = lastUpdated;
    }

    /**
     * 获取实体对应的数据库真实表名
     *
     * @return 数据库表明真实表名
     */
    public String tableName() {
        return null;
    }

    /**
     * 获取实体的Map数据格式
     *
     * @return 一个Map集合, key = 属性名 value = 值
     */
    public Map<String, Object> toMap() {
        return null;
    }

    /**
     * 获取当前类类名
     *
     * @return 类名
     */
    public String mySimpleName() {
        return this.getClass().getSimpleName();
    }

    /**
     * 确认必填属性是否完整
     *
     * @return Boolean
     */
    public String checkLack() {
        return "";
    }

    public boolean isNew() {
        return null == getId();
    }

    /*
     * (non-Javadoc)
     *  这里比较两个实体是否相等，直接比较id是否相等
     * @see java.lang.Object#equals(java.lang.Object)
     */
    @Override
    public boolean equals(Object obj) {

        if (null == obj) {
            return false;
        }

        if (this == obj) {
            return true;
        }

        if (!getClass().equals(obj.getClass())) {
            return false;
        }

        AbstractEntity<?> that = (AbstractEntity<?>) obj;

        return null != this.getId() && this.getId().equals(that.getId());
    }

    /*
     * (non-Javadoc)
     *
     * @see java.lang.Object#hashCode()
     */
    @Override
    public int hashCode() {

        int hashCode = 17;

        hashCode += null == getId() ? 0 : getId().hashCode() * 31;

        return hashCode;
    }

    @Override
    public String toString() {
        return ReflectionToStringBuilder.toString(this);
    }

}
