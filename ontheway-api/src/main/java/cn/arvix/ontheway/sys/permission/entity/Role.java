package cn.arvix.ontheway.sys.permission.entity;

import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.base.common.repository.support.annotation.EnableQueryCache;
import cn.arvix.base.common.utils.HibernateValidationUtil;
import cn.arvix.base.common.utils.TimeMaker;
import com.google.common.collect.Maps;
import io.swagger.annotations.ApiModelProperty;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.*;
import java.util.Map;

/**
 * @author Created by yangyang on 2017/3/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@Entity
@Table(name = "sys_role")
@EnableQueryCache
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Role extends BaseEntity<Long> {

    public static final String TABLE_NAME = "sys_role";

    /**
     * 前端显示名称
     */
    private String name;
    /**
     * 系统中验证时使用的角色标识
     */
    private String role;

    /**
     * 角色类型 saas类型用户系统动态授权 normal允许saas用户创建
     */
    @Enumerated(EnumType.STRING)
    private RoleType roleType;

    /**
     * 详细描述
     */
    private String description;

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

    public void setObjectMap(Map<String, Object> objectMap) {
        this.objectMap = objectMap;
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
        objectMap.put("name", name);
        objectMap.put("role", role);
        objectMap.put("roleType", roleType);
        objectMap.put("description", description);
        objectMap.put("show", show);
        objectMap.put("creater", getCreater());
        objectMap.put("dateCreated", TimeMaker.toDateTimeStr(getDateCreated()));
        objectMap.put("lastUpdated", TimeMaker.toDateTimeStr(getLastUpdated()));
        return objectMap;
    }

    public RoleType getRoleType() {
        return roleType;
    }

    public void setRoleType(RoleType roleType) {
        this.roleType = roleType;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Boolean getShow() {
        return show;
    }

    public void setShow(Boolean show) {
        this.show = show;
    }
}
