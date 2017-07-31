package cn.arvix.ontheway.footprint.repository;

import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.ontheway.footprint.entity.Comment;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

/**
 * @author Created by yangyang on 2017/7/30.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface CommentRepository extends BaseRepository<Comment, Long> {

    @Modifying
    @Query("delete from Comment where footprint.id in (?1)")
    int deleteInFootprintId(List footprintIds);

    @Modifying
    @Query("update Comment set replyCommentId = null where replyCommentId = ?1")
    int updateReplyCommentId(Long replyCommentId);

}
