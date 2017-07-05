package cn.arvix.ontheway.sys.config.entity;

import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.base.common.utils.HibernateValidationUtil;
import cn.arvix.base.common.utils.TimeMaker;
import com.google.common.collect.Maps;
import io.swagger.annotations.ApiModelProperty;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.util.Map;

/**
 * @author Created by yangyang on 2017/3/14.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Entity
@Table(name = "sys_config")
public class Config extends BaseEntity<Long> {

    public static final String TABLE_NAME = "sys_config";

    @Column(unique = true, nullable = false)
    @NotNull(message = "值KEY填写错误,不能为空!")
    @ApiModelProperty(hidden = true)
    private String mapName;
    @Column(columnDefinition = "longtext", nullable = false)
    @NotNull(message = "值填写错误,不能为空!")
    private String mapValue;
    @Column
    @ApiModelProperty(hidden = true)
    private String description;
    @Column(nullable = false)
    @NotNull(message = "值类型填写错误,不能为空!")
    @Enumerated(EnumType.STRING)
    @ApiModelProperty(hidden = true)
    private ConfigValueType valueType;
    @Column(nullable = false)
    @ApiModelProperty(hidden = true)
    private Boolean editable = false; //允许修改

    @ApiModelProperty(hidden = true)
    private transient Map<String, Object> objectMap;

    public Map<String, Object> getObjectMap() {
        if (objectMap == null) {
            objectMap = Maps.newHashMap();
        }
        return objectMap;
    }

    public void setObjectMap(Map<String, Object> objectMap) {
        this.objectMap = objectMap;
    }

    public String tableName() {
                return TABLE_NAME;
            }

    /**
     * checkLack
     */
    public String checkLack() {
        StringBuilder builder = HibernateValidationUtil.validateModel(this);
        return builder.toString();
    }

    @Transient
    public Map<String, Object> toMap() {
        objectMap = Maps.newHashMap();
        objectMap.put("id", getId());
        objectMap.put("mapName", mapName);
        objectMap.put("mapValue", mapValue);
        objectMap.put("description", description);
        objectMap.put("valueType", valueType);
        objectMap.put("editable", editable);
        objectMap.put("dateCreated", TimeMaker.toDateTimeStr(getDateCreated()));
        objectMap.put("lastUpdated", TimeMaker.toDateTimeStr(getLastUpdated()));
        objectMap.put("creater", getCreater());
        return objectMap;
    }

    public String getMapName() {
        return mapName;
    }

    public Config setMapName(String mapName) {
        this.mapName = mapName;
        return this;
    }

    public String getMapValue() {
        return mapValue;
    }

    public Config setMapValue(String mapValue) {
        this.mapValue = mapValue;
        return this;
    }

    public String getDescription() {
        return description;
    }

    public Config setDescription(String description) {
        this.description = description;
        return this;
    }

    public ConfigValueType getValueType() {
        return valueType;
    }

    public Config setValueType(ConfigValueType valueType) {
        this.valueType = valueType;
        return this;
    }

    public Boolean getEditable() {
        return editable;
    }

    public Config setEditable(Boolean editable) {
        this.editable = editable;
        return this;
    }
}
