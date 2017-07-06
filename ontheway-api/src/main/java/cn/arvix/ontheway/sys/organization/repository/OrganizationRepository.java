package cn.arvix.ontheway.sys.organization.repository;

import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.ontheway.sys.organization.entity.Organization;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.QueryHints;

import javax.persistence.QueryHint;
import java.util.List;

/**
 * @author Created by yangyang on 2017/3/8.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface OrganizationRepository extends BaseRepository<Organization, Long> {

    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    List<Organization> findByParentId(Long pId);

    @Query("select count(*) from UserOrganizationJob where organization.id =?1 ")
    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    Long findUserCountByOrganizationId(Long id);

}
