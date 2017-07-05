package cn.arvix.ontheway.sys.auth.repository;

import cn.arvix.ontheway.sys.auth.entity.Auth;
import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.base.common.repository.support.annotation.SearchableQuery;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.QueryHints;

import javax.persistence.QueryHint;
import java.util.List;
import java.util.Set;

/**
 * @author Created by yangyang on 2017/3/19.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@SearchableQuery(callbackClass = AuthSearchCallback.class)
public interface AuthRepository extends BaseRepository<Auth, Long> {

    //这里获取的都是非实例分权信息
    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    @Query("from Auth where userId = ?1 and companyId=?2 and opModule = 0 ")
    Auth findByUserIdAndCompanyId(Long uId, Long companyId);

    @Query("from Auth where organizationId = ?1 and companyId=?2 and opModule = 0 ")
    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    Auth findByOrganizationIdAndCompanyId(Long oId, Long companyId);

    @Modifying
    @Query("delete from Auth where userId= ?1 and companyId = ?2 and opModule = 0 ")
    int deleteByUserIdAndCompanyId(Long uId, Long companyId);

    @Query("from Auth where opModule = ?1 and opId=?2 and companyId=?3")
    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    List<Auth> fromByOpModuleAndOpId(Integer opModule, Long opId, Long cid);

    @Modifying
    @Query("delete from Auth where opModule= ?1 and opId=?2 and companyId = ?3")
    int deleteByOpModuleAndOpId(Integer opModule, Long opId, Long cid);

    @Query("select opId , opType from Auth where opId in(?1) and opModule=?2 and companyId=?3")
    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    List<Object[]> findByOpTypeByOpIds(Set<Long> opIds, Integer opModule, Long companyId);

    @Query("from Auth where ((userId=?1 ) or (organizationId in (?2) and jobId = 0 ) ) and opId=?3 and opModule=?4 and companyId=?5")
    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    List<Auth> findByOpTypeByOpId(Long userId, Set<Long> oids, Long opId, Integer opModule, Long companyId);

    //获取角色 委托给AuthRepositoryImpl实现 这里不会获取当单条数据权限
    Set<Long> findRoleIds(Long userId, Set<Long> groupIds, Set<Long> organizationIds, Set<Long> jobIds, Set<Long[]> organizationJobIds);


}
