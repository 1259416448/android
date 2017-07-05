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

    /**
     * 判断当前名称是否存在，带上当前saas公司信息
     * redis中配置名为 mapName_companyId
     * @param mapName   名称
     * @param companyId 公司ID
     */
    boolean checkMapName(String mapName, Long companyId);

    /**
     * 获取Integer类型
     *
     * @param configName 配置名称;
     * @param companyId  公司ID
     * @return 配置值
     */
    BigDecimal getConfigBigDecimal(String configName, Long companyId);

    /**
     * 获取Boolean类型
     *
     * @param configName 配置名称;
     * @param companyId  公司ID
     * @return 配置值
     */
    boolean getConfigBoolean(String configName, Long companyId);

    /**
     * 获取String类型
     *
     * @param configName 配置名称;
     * @param companyId  公司ID
     * @return 配置值
     */
    String getConfigString(String configName, Long companyId);

    /**
     * 获取Date类型
     *
     * @param configName 配置名称;
     * @param companyId  公司ID
     * @return 配置值
     */
    Date getConfigDate(String configName, Long companyId);

    /**
     * 获取Object类型
     *
     * @param configName 配置名称;
     * @param companyId  公司ID
     * @return 配置值
     */
    Object getConfig(String configName, Long companyId);

    /**
     * 获取所有配置信息
     *
     * @return config json
     */
    JSONResult search(Long companyId);


}
