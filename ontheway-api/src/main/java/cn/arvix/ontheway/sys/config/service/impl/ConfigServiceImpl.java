package cn.arvix.ontheway.sys.config.service.impl;

import cn.arvix.ontheway.sys.config.entity.Config;
import cn.arvix.ontheway.sys.config.entity.ConfigValueType;
import cn.arvix.ontheway.sys.config.repository.ConfigRepository;
import cn.arvix.ontheway.sys.config.service.ConfigService;
import cn.arvix.ontheway.sys.init.DataInitService;
import cn.arvix.ontheway.sys.utils.Email;
import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.base.common.utils.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Objects;

/**
 * @author Created by yangyang on 2017/3/14.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@Service
public class ConfigServiceImpl extends BaseServiceImpl<Config, Long> implements ConfigService {

    private final Cache cache;

    @Autowired
    public ConfigServiceImpl(CacheManager cacheManager) {
        this.cache = cacheManager.getCache("sys-config");
    }

    private ConfigRepository getCityRepository() {
        return (ConfigRepository) baseRepository;
    }

    @Override
    public JSONResult save_(Config m) {
        if (!checkMapName(m.getMapName())) {
            return JsonUtil.getFailure(MessageUtils.message(CommonContact.ADD_EXIST), CommonContact.ADD_EXIST);
        }
        JSONResult jsonResult = super.save_(m);
        addToConfigCache(m);
        return jsonResult;
    }

    public boolean checkMapName(String mapName) {
        return getCityRepository().findByMapName(mapName) == null;
    }

    @Override
    public JSONResult update_(Config m) {
        Config oldConfig = findOne(m.getId());
        if (!oldConfig.getEditable()) return JsonUtil.getFailure(MessageUtils.message(CommonContact.CONFIG_NOT_UPDATE),
                CommonContact.CONFIG_NOT_UPDATE);
        oldConfig.setMapValue(m.getMapValue());
        JSONResult jsonResult = super.update_(oldConfig);
        addToConfigCache(oldConfig);
        if (oldConfig.getMapName().contains(CommonContact.EMAIL_CONFIG_PREFIX)) {
            Email email = SpringUtils.getBean(Email.class);
            email.setJavaMailSender(SpringUtils.getBean(DataInitService.class).mailSender());
            email.setFrom(getConfigString(CommonContact.EMAIL_CONFIG_USERNAME));
            email.setPersonal(getConfigString(CommonContact.EMAIL_CONFIG_SENT_NAME));
        }
        return jsonResult;
    }

    /**
     * 添加值到Cache中
     *
     * @param config 配置
     */
    @Override
    public void addToConfigCache(Config config) {
        if (config.getValueType() == ConfigValueType.BigDecimal
                && Checks.isNum(config.getMapValue())) {
            cache.put(config.getMapName(), new BigDecimal(config.getMapValue()));
        } else if (config.getValueType() == ConfigValueType.Boolean) {
            if (Objects.equals(config.getMapValue(), "true")) {
                cache.put(config.getMapName(), true);
            } else {
                cache.put(config.getMapName(), false);
            }
        } else if (config.getValueType() == ConfigValueType.DATE) {
            cache.put(config.getMapName(), TimeMaker.parseStringToDate(config.getMapValue()));
        } else {
            cache.put(config.getMapName(), config.getMapValue());
        }
    }

    /**
     * 获取Integer类型
     *
     * @param configName 配置名称;
     * @return 配置值
     */
    @Override
    public BigDecimal getConfigBigDecimal(String configName) {
        Cache.ValueWrapper valueWrapper = cache.get(configName);
        if (valueWrapper == null || !(valueWrapper.get() instanceof BigDecimal))
            throw new IllegalArgumentException("not found configName " + configName);
        return (BigDecimal) valueWrapper.get();
    }

    /**
     * 获取Boolean类型
     *
     * @param configName 配置名称;
     * @return 配置值
     */
    @Override
    public boolean getConfigBoolean(String configName) {
        Cache.ValueWrapper valueWrapper = cache.get(configName);
        if (valueWrapper == null || !(valueWrapper.get() instanceof Boolean))
            throw new IllegalArgumentException("not found configName " + configName);
        return (Boolean) valueWrapper.get();
    }

    /**
     * 获取String类型
     *
     * @param configName 配置名称;
     * @return 配置值
     */
    @Override
    public String getConfigString(String configName) {
        Cache.ValueWrapper valueWrapper = cache.get(configName);
        if (valueWrapper == null || !(valueWrapper.get() instanceof String))
            throw new IllegalArgumentException("not found configName " + configName);
        return (String) valueWrapper.get();
    }

    /**
     * 获取Date类型
     *
     * @param configName 配置名称;
     * @return 配置值
     */
    @Override
    public Date getConfigDate(String configName) {
        Cache.ValueWrapper valueWrapper = cache.get(configName);
        if (valueWrapper == null || !(valueWrapper.get() instanceof Date))
            throw new IllegalArgumentException("not found configName " + configName);
        return (Date) valueWrapper.get();
    }

    /**
     * 获取Object类型
     *
     * @param configName 配置名称;
     * @return 配置值
     */
    @Override
    public Object getConfig(String configName) {
        Cache.ValueWrapper valueWrapper = cache.get(configName);
        if (valueWrapper == null)
            throw new IllegalArgumentException("not found configName " + configName);
        return valueWrapper.get();
    }

    /**
     * 初始化
     */
    @Override
    public void init(List<Config> list) {
        if (list != null && list.size() > 0) {
            list.forEach(this::addToConfigCache);
        }
    }

    /**
     * 获取所有配置信息
     *
     * @return config json
     */
    @Override
    public JSONResult search() {
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.FETCH_SUCCESS),
                CommonContact.FETCH_SUCCESS, findAll());
    }

    /**
     * 获取当前缓存
     *
     * @return spring cache
     */
    public Cache getCache() {
        return cache;
    }

}
