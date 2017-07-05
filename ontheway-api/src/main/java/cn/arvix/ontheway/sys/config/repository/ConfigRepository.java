package cn.arvix.ontheway.sys.config.repository;

import cn.arvix.ontheway.sys.config.entity.Config;
import cn.arvix.base.common.repository.BaseRepository;
import org.springframework.data.jpa.repository.QueryHints;

import javax.persistence.QueryHint;

/**
 * @author Created by yangyang on 2017/3/8.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface ConfigRepository extends BaseRepository<Config, Long> {

    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    Config findByMapName(String mapName);

}
