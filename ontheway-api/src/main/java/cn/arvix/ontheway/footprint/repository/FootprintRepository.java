package cn.arvix.ontheway.footprint.repository;

import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.base.common.repository.support.annotation.SearchableQuery;
import cn.arvix.ontheway.footprint.entity.Footprint;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

/**
 * @author Created by yangyang on 2017/7/26.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@SearchableQuery(callbackClass = FootprintSearchCallback.class)
public interface FootprintRepository extends BaseRepository<Footprint,Long> {

    @SuppressWarnings({"JpaQlInspection", "SpringDataJpaMethodInconsistencyInspection"})
    @Query(nativeQuery = true,value = " select file_url from agile_document agiled " +
                "where agiled.system_module = 'footprint' " +
                "and  exists ( select 1 from otw_footprint otwf " +
                "where otwf.if_business_comment = 1 " +
                "and if_delete = 0 " +
                "and otwf.business = ?1 " +
                "and otwf.id = agiled.parent_id ) order by date_created desc limit ?2")
    List<String> findPhotoUrlByBusinessId(Long businessId,int number);

}
