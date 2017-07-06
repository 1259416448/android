package cn.arvix.ontheway.sys.config.service;

import cn.arvix.ontheway.sys.config.entity.Config;
import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.service.BaseService;
import org.springframework.cache.Cache;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * @author Created by yangyang on 2017/3/14.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

public interface ConfigService extends BaseService<Config, Long> {

    boolean checkMapName(String mapName);

    /**
     * 获取Integer类型
     *
     * @param configName 配置名称;
     * @return 配置值
     */
    BigDecimal getConfigBigDecimal(String configName);

    /**
     * 获取Boolean类型
     *
     * @param configName 配置名称;
     * @return 配置值
     */
    boolean getConfigBoolean(String configName);

    /**
     * 获取String类型
     *
     * @param configName 配置名称;
     * @return 配置值
     */
    String getConfigString(String configName);

    /**
     * 获取Date类型
     *
     * @param configName 配置名称;
     * @return 配置值
     */
    Date getConfigDate(String configName);

    /**
     * 获取Object类型
     *
     * @param configName 配置名称;
     * @return 配置值
     */
    Object getConfig(String configName);

    /**
     * 初始化
     */
    void init(List<Config> list);

    /**
     * 添加值到Cache中
     *
     * @param config 配置
     */
    void addToConfigCache(Config config);

    /**
     * 获取所有配置信息
     *
     * @return config json
     */
    JSONResult search();

    Cache getCache();

}
