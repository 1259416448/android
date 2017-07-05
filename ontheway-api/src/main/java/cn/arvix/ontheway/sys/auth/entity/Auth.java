package cn.arvix.ontheway.sys.auth.entity;

import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.base.common.repository.hibernate.type.CollectionToStringUserType;
import cn.arvix.base.common.repository.support.annotation.EnableQueryCache;
import com.google.common.collect.Sets;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Parameter;
import org.hibernate.annotations.Type;
import org.hibernate.annotations.TypeDef;

import javax.persistence.*;
import java.util.Set;

/**
 * 组织机构 工作职位  用户  角色 关系表
 * 1、授权的五种情况
 * 只给组织机构授权 (orgnizationId=? and jobId=0)
 * 只给工作职务授权 (orgnizationId=0 and jobId=?)
 * 给组织机构和工作职务都授权 (orgnizationId=? and jobId=?)
 * 给用户授权  (userId=?)
 * 给组授权 (groupId=?)
 * <p/>
 * 因此查询用户有没有权限 就是
 * where ( (orgnizationId=? and jobId=0) or (organizationId = 0 and jobId=?) or (orgnizationId=? and jobId=?) or (userId=?) or (groupId=?) ) and companyId=?
 * <p/>
 * <p/>
 * 2、为了提高性能
 * 放到一张表
 * 此处不做关系映射（这样需要配合缓存）
 * <p/>
 * 3、如果另一方是可选的（如只选组织机构 或 只选工作职务） 那么默认0 使用0的目的是为了也让走索引
 * <p>
 * 4、单条数据授权不写入默认角色获取方法中
 * 5、目前单条数据分权不支持对应到角色上，只支持指定 到 用户或者组织机构
 *
 * @author Created by yangyang on 2017/3/19.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@TypeDef(
        name = "SetToStringUserType",
        typeClass = CollectionToStringUserType.class,
        parameters = {
                @Parameter(name = "separator", value = ","),
                @Parameter(name = "collectionType", value = "java.util.HashSet"),
                @Parameter(name = "elementType", value = "java.lang.Long")
        }
)
@Entity
@Table(name = "sys_auth")
@EnableQueryCache
@org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Auth extends BaseEntity<Long> {

    /**
     * 组织机构
     */
    @Column
    private Long organizationId = 0L;

    /**
     * 工作职务
     */
    @Column
    private Long jobId = 0L;

    /**
     * 用户
     */
    @Column
    private Long userId = 0L;

    /**
     * 组
     */
    @Column
    private Long groupId = 0L;

    @Type(type = "SetToStringUserType")
    @Column
    private Set<Long> roleIds;

    @Enumerated(EnumType.STRING)
    private AuthType type;

    //单条数据授权 0 表示 NULL 为了走索引 设置为 0
    private Long opId = 0L;

    //操作类型 规定 1 可查 2 可改
    private Integer opType = 2;

    //数据类型 0 表示默认系统授权 其他根据情况自定义
    private Integer opModule = 0;


    public Long getOrganizationId() {
        return organizationId;
    }

    public void setOrganizationId(Long organizationId) {
        this.organizationId = organizationId;
    }

    public Long getJobId() {
        return jobId;
    }

    public void setJobId(Long jobId) {
        this.jobId = jobId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getGroupId() {
        return groupId;
    }

    public void setGroupId(Long groupId) {
        this.groupId = groupId;
    }

    public Set<Long> getRoleIds() {
        if (roleIds == null) {
            roleIds = Sets.newHashSet();
        }
        return roleIds;
    }

    public void setRoleIds(Set<Long> roleIds) {
        this.roleIds = roleIds;
    }

    public AuthType getType() {
        return type;
    }

    public void setType(AuthType type) {
        this.type = type;
    }

    public Long getOpId() {
        return opId;
    }

    public void setOpId(Long opId) {
        this.opId = opId;
    }

    public Integer getOpType() {
        return opType;
    }

    public void setOpType(Integer opType) {
        this.opType = opType;
    }

    public Integer getOpModule() {
        return opModule;
    }

    public void setOpModule(Integer opModule) {
        this.opModule = opModule;
    }
}
