package cn.arvix.ontheway.message.repository;

import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.ontheway.message.entity.NewMessageCount;

/**
 * @author Created by yangyang on 2017/8/11.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface NewMessageCountRepository extends BaseRepository<NewMessageCount,Long> {

    NewMessageCount findByUserId(Long userId);

}
