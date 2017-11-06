package cn.arvix.ontheway.sys.user.repository;

import cn.arvix.ontheway.sys.user.entity.UserOrganizationJob;
import cn.arvix.base.common.repository.BaseRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.QueryHints;

import javax.persistence.QueryHint;
import java.util.List;

/**
 * @author Created by yangyang on 2017/3/17.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface UserOrganizationJobRepository extends BaseRepository<UserOrganizationJob, Long> {

    @Query("select organization.id from UserOrganizationJob where user.id=?1")
    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    List<Long> findOrganizationIdByUserId(Long uId);

    @Modifying
    @Query("delete from UserOrganizationJob where user.id=?1 and organization.id in (?2)")
    int deleteByUserIdAndOrganizationIdIn(Long uId, Long[] organizationIds);

    @Query("from UserOrganizationJob where user.id=?1 and organization.id = ?2")
    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    UserOrganizationJob findByUserIdAndOrganizationId(Long uId, Long oId);

    @Modifying
    @Query("delete from UserOrganizationJob where user.id=?1")
    int deleteByUserId(Long uid);

}
