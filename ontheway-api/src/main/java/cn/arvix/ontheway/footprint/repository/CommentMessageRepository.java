package cn.arvix.ontheway.footprint.repository;

import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.ontheway.footprint.entity.CommentMessage;
import org.springframework.data.jpa.repository.Query;

/**
 * @author Created by yangyang on 2017/8/10.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface CommentMessageRepository extends BaseRepository<CommentMessage,Long> {

    @Query("from CommentMessage where comment.id = ?1")
    CommentMessage findByCommentId(Long commentId);

}
