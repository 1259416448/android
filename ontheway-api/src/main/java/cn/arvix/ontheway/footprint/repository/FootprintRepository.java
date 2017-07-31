package cn.arvix.ontheway.footprint.repository;

import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.base.common.repository.support.annotation.SearchableQuery;
import cn.arvix.ontheway.footprint.entity.Footprint;

/**
 * @author Created by yangyang on 2017/7/26.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@SearchableQuery(callbackClass = FootprintSearchCallback.class)
public interface FootprintRepository extends BaseRepository<Footprint,Long> {

}
