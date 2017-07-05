package cn.arvix.ontheway.ducuments.repository;

import cn.arvix.ontheway.ducuments.entity.Document;
import cn.arvix.base.common.repository.BaseRepository;
import org.springframework.data.jpa.repository.Query;

/**
 * @author Created by yangyang on 2017/3/31.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface DocumentRepository extends BaseRepository<Document, Long> {

    @Query("select count(id) from Document where parentId = ?1")
    Long countByParentId(Long parentId);

}
