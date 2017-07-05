package cn.arvix.ontheway.sys.permission.repository;

import cn.arvix.ontheway.sys.permission.entity.RoleResource;
import cn.arvix.base.common.repository.BaseRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.QueryHints;

import javax.persistence.QueryHint;
import java.util.List;
import java.util.Set;

/**
 * @author Created by yangyang on 2017/3/16.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface RoleResourceRepository extends BaseRepository<RoleResource, Long> {

    @Query("select resourceId from RoleResource where role.id = ?1")
    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    List<Long> findResourceIdWithRoleId(Long id);

    @Modifying
    @Query("delete from RoleResource where role.id = ?1")
    int deleteByRoleId(Long id);

    @Modifying
    @Query("delete from RoleResource where role.id in(?1) ")
    int deleteByRoleIds(Set<Long> id);

    @Modifying
    @Query("delete from RoleResource where role.id = ?1 and resourceId in (?2)")
    int deleteByRoleIdAndResourceIdIsIn(Long id, Long[] resourceIds);

}
