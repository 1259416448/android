package cn.arvix.ontheway.sys.user.repository;

import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.base.common.repository.support.annotation.SearchableQuery;
import cn.arvix.ontheway.sys.user.entity.User;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.QueryHints;

import javax.persistence.QueryHint;

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

    /**
     * 修改密码
     */
    @Modifying
    @Query("update User set password=?1,salt=?2 where id=?3")
    int updatePasswordAndSaleById(String password, String salt, Long uid);


}
