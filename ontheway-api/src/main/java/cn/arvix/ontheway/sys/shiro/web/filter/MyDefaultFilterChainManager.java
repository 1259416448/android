package cn.arvix.ontheway.sys.shiro.web.filter;

import org.apache.shiro.web.filter.mgt.DefaultFilterChainManager;

/**
 * @author Created by yangyang on 2017/3/23.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class MyDefaultFilterChainManager extends DefaultFilterChainManager {

    protected void addDefaultFilters(boolean init) {

        MyDefaultFilter[] var2 = MyDefaultFilter.values();
        int var3 = var2.length;

        for (int var4 = 0; var4 < var3; ++var4) {
            MyDefaultFilter defaultFilter = var2[var4];
            super.addFilter(defaultFilter.name(), defaultFilter.newInstance(), init, false);
        }

    }

}
