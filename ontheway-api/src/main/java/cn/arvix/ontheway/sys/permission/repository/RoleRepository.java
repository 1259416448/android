package cn.arvix.ontheway.sys.permission.repository;

import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.ontheway.sys.permission.entity.Role;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.QueryHints;

import javax.persistence.QueryHint;
import java.util.List;
import java.util.Set;

/**
 * @author Created by yangyang on 2017/3/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface RoleRepository extends BaseRepository<Role, Long> {

    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    Role findByRole(String role);

    @Query("select role from Role where id in (?1) and show = true")
    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    List<String> findRoleByIds(Set<Long> ids);

    @Query("from Role where role = ?1 and id <> ?2")
    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    Role findByRoleNotEqId(String role, Long id);

    @Query("select role from Role where show = true")
    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    List<String> findRole();

}
