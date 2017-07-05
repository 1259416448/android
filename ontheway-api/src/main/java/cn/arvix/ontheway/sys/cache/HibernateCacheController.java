package cn.arvix.ontheway.sys.cache;

import cn.arvix.base.common.entity.JSONResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author Created by yangyang on 2017/3/8.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@RequestMapping(value = "/api/v1/cache")
@Controller
public class HibernateCacheController {

    private final HibernateCacheService service;

    @Autowired
    public HibernateCacheController(HibernateCacheService service) {
        this.service = service;
    }

    @RequestMapping(value = "/level2/evict", method = RequestMethod.POST)
    @ResponseBody
    public JSONResult cacheLevel2() {
        return service.removeLevel2Cache();
    }
}
