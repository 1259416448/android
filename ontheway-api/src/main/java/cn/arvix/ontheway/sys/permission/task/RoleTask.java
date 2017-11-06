package cn.arvix.ontheway.sys.permission.task;

import org.springframework.beans.factory.annotation.Configurable;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.stereotype.Component;

/**
 * 异步定时任务
 *
 * @author Created by yangyang on 2017/4/24.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Component
@Configurable
@EnableScheduling
public class RoleTask {

    /**
     * 1小时执行一次 ,清理一些遗留的授权信息
     */
    //@Scheduled(fixedRate = 3600000)
    public void clearAuth() {

    }

}
