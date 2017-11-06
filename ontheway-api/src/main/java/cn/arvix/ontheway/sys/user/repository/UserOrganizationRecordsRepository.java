package cn.arvix.ontheway.sys.user.repository;

import cn.arvix.ontheway.sys.user.entity.UserOrganizationRecords;
import cn.arvix.base.common.repository.BaseRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.QueryHints;

import javax.persistence.QueryHint;
import java.util.List;

/**
 * @author Created by yangyang on 2017/6/5.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface UserOrganizationRecordsRepository extends BaseRepository<UserOrganizationRecords, Long> {

    @Query("from UserOrganizationRecords where user.id = ?1 and organization.id=?2")
    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    UserOrganizationRecords findByUserIdAndOrganizationId(Long uid, Long oId);

    @Query("from UserOrganizationRecords where user.id = ?1 ")
    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    List<UserOrganizationRecords> findByUserId(Long uid);

}
