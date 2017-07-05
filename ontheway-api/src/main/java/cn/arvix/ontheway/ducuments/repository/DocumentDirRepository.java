package cn.arvix.ontheway.ducuments.repository;

import cn.arvix.ontheway.ducuments.entity.DocumentDir;
import cn.arvix.ontheway.ducuments.entity.DocumentDirType;
import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.base.common.repository.support.annotation.SearchableQuery;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

/**
 * @author Created by yangyang on 2017/3/31.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@SearchableQuery(callbackClass = DocumentDirSearchCallback.class)
public interface DocumentDirRepository extends BaseRepository<DocumentDir, Long> {

    @Query("from DocumentDir where documentDirType=?1 and companyId = ?2 and show = true")
    DocumentDir findByDocumentDirTypeAndCompanyId(DocumentDirType documentDirType, Long companyId);

    @Query("select name,id from DocumentDir where id in (?1) ")
    List<Object[]> findInId(List<Long> ids);

}
