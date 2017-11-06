package cn.arvix.ontheway.ducuments.repository;

import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.ontheway.ducuments.entity.DocumentDir;
import cn.arvix.ontheway.ducuments.entity.DocumentDirType;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

/**
 * @author Created by yangyang on 2017/3/31.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface DocumentDirRepository extends BaseRepository<DocumentDir, Long> {

    @Query("from DocumentDir where documentDirType=?1 and show = true")
    DocumentDir findByDocumentDirTypeAndCompanyId(DocumentDirType documentDirType);

    @Query("select name,id from DocumentDir where id in (?1) ")
    List<Object[]> findInId(List<Long> ids);

}
