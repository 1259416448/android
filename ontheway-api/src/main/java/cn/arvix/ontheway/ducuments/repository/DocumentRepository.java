package cn.arvix.ontheway.ducuments.repository;

import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.base.common.repository.support.annotation.SearchableQuery;
import cn.arvix.ontheway.ducuments.entity.Document;
import org.springframework.data.jpa.repository.Query;

/**
 * @author Created by yangyang on 2017/3/31.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@SearchableQuery(callbackClass = DocumentSearchCallback.class)
public interface DocumentRepository extends BaseRepository<Document, Long> {

    @Query("select count(id) from Document where parentId = ?1")
    Long countByParentId(Long parentId);

}
