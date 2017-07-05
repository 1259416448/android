package cn.arvix.ontheway.sys.user.entity;

import cn.arvix.ontheway.sys.organization.entity.Organization;
import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.base.common.repository.support.annotation.EnableQueryCache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import javax.persistence.Entity;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;

/**
 * 保存用户所属saas团队信息，允许一个用户加入多个saas团队
 * 团队切换就相当于直接切换保存在User中的company信息
 * 用户退出某个saas团队 需要移除当前表中的记录和删除组织机构关联信息，不移除用户所在团队里的工作记录信息，
 * 如果用户没有加入任何一个团队，不允许直接登录
 *
 * @author Created by yangyang on 2017/6/5.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@Entity
@Table(name = "sys_user_organization_records")
@EnableQueryCache
@org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class UserOrganizationRecords extends BaseEntity<Long> {

    @ManyToOne
    @NotNull(message = "user is not null")
    private User user;

    @ManyToOne
    @NotNull(message = "organization is not null")
    private Organization organization;

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Organization getOrganization() {
        return organization;
    }

    public void setOrganization(Organization organization) {
        this.organization = organization;
    }
}
