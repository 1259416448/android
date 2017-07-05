package cn.arvix.ontheway.sys.user.repository;

import cn.arvix.ontheway.sys.user.entity.User;
import cn.arvix.ontheway.sys.user.entity.UserType;
import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.base.common.repository.support.annotation.SearchableQuery;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.QueryHints;

import javax.persistence.QueryHint;
import java.util.List;

/**
 * @author Created by yangyang on 2017/3/8.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@SearchableQuery(callbackClass = UserSearchCallback.class)
public interface UserRepository extends BaseRepository<User, Long> {

    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    User findByUsername(String username);

    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    User findByEmail(String email);

    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    User findByMobilePhoneNumber(String mobilePhoneNumber);

    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    User findByUsernameAndIdIsNot(String username, Long id);

    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    User findByEmailAndIdIsNot(String username, Long id);

    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    User findByMobilePhoneNumberAndIdIsNot(String username, Long id);

    @Query("from User where ( username = ?1 or email = ?1 or mobilePhoneNumber = ?1 ) and deleted = false ")
    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    User findByUserNameOrEmailAndOrMobilePhoneNumber(String username);

    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    @Query("from User where companyId=?1 and userType = ?2 and deleted = false ")
    User findByCompanyIdAndUserType(Long companyId, UserType userType);

    /**
     * 获取当前公司下的所有用户id（不包含自己）
     */
    @Query("select id from User where companyId=?1 and id <>?2")
    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    Long[] findIdByCompanyId(Long companyId, Long uid);

    /**
     * 获取当前公司下的所有用户（不包含自己）
     */
    @Query("from User where companyId=?1 and id <>?2")
    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    List<User> findByCompanyId(Long companyId, Long uid);

    /**
     * 修改密码
     */
    @Modifying
    @Query("update User set password=?1,salt=?2 where id=?3")
    int updatePasswordAndSaleById(String password, String salt, Long uid);


}
