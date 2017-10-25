package cn.arvix.ontheway.attention.repository;

import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.ontheway.attention.entity.Attention;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

/**
 * @author Created by yangyang on 2017/10/25.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface AttentionRepository extends BaseRepository<Attention, Long> {

    @Query("select count(*) from Attention where user.id = ?1 and attentionUser.id = ?2")
    int countUserAndAttentionUser(Long userId, Long attentionUserId);

    @Modifying
    @Query("delete from Attention where user.id = ?1 and attentionUser.id = ?2")
    int deleteUserAndAttentionUser(Long userId, Long attentionUserId);

}
