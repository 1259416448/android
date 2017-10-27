package cn.arvix.ontheway.message.repository;

import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.ontheway.message.entity.NewMessageCount;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

/**
 * @author Created by yangyang on 2017/8/11.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface NewMessageCountRepository extends BaseRepository<NewMessageCount, Long> {

    NewMessageCount findByUserId(Long userId);

    @Query("update NewMessageCount set systemNum = systemNum + ?1")
    @Modifying
    int updateSystemCount(int value);

}
