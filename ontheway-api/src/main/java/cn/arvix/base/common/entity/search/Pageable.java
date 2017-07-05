package cn.arvix.base.common.entity.search;

/**
 * @author Created by yangyang on 2017/3/16.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface Pageable extends org.springframework.data.domain.Pageable {

    boolean getEnableToMap();

    Pageable setEnableToMap(Boolean enableToMap);

}
