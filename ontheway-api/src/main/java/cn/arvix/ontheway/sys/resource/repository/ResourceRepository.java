package cn.arvix.ontheway.sys.resource.repository;

import cn.arvix.ontheway.sys.resource.entity.Resource;
import cn.arvix.ontheway.sys.resource.entity.ResourceType;
import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.base.common.repository.support.annotation.SearchableQuery;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.QueryHints;

import javax.persistence.QueryHint;
import java.util.List;
import java.util.Set;

/**
 * @author Created by yangyang on 2017/3/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@SearchableQuery(callbackClass = ResourceSearchCallback.class)
public interface ResourceRepository extends BaseRepository<Resource, Long> {

    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    List<Resource> findByParentId(Long pId);

    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    List<Resource> findByShowAndBeforeShowAndResourceType(Boolean show, Boolean beforeShow, ResourceType resourceType);

    @Query("select distinct identity from Resource where id in(select resourceId  from RoleResource where role.id in(?1)) and resourceType = 'button' ")
    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    List<String> findIdentityByRoleIds(Set<Long> roleIds);

    @Query("select distinct identity from Resource where resourceType = 'button'")
    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    List<String> findIdentity();


}
