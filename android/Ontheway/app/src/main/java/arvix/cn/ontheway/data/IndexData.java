package arvix.cn.ontheway.data;

import java.util.ArrayList;
import java.util.List;

import arvix.cn.ontheway.App;
import arvix.cn.ontheway.MainCardBean;
import arvix.cn.ontheway.MenuBean;
import arvix.cn.ontheway.R;
import arvix.cn.ontheway.async.ExceptionHandler;
import arvix.cn.ontheway.async.Result;

/**
 * Created by yd on 2017/7/18.
 */

public class IndexData {
    public static Result<List<MainCardBean>> getMainCard() {
        Result<List<MainCardBean>> ret = new Result<>();
        try {
            List<MainCardBean> beans = new ArrayList<>();
            MainCardBean b = new MainCardBean();
            b.setTitle("餐饮");
            b.setBg(R.drawable.faxian);
            List<MenuBean> menus = new ArrayList<>();
            MenuBean mb = new MenuBean();
            mb.setTitle("自助餐");
            ;
            mb.setImgSrc(R.drawable.bashi);
            menus.add(mb);
            mb = new MenuBean();
            mb.setTitle("咖啡");
            mb.setImgSrc(R.drawable.bashi);
            menus.add(mb);
            mb = new MenuBean();
            mb.setTitle("火锅");
            mb.setImgSrc(R.drawable.bashi);
            menus.add(mb);
            //
            b.setMenus(menus);
            beans.add(b);
            b = new MainCardBean();
            b.setTitle("Title1");
            b.setBg(R.drawable.faxian);
            menus = new ArrayList<>();
            mb = new MenuBean();
            mb.setTitle("t1");
            mb.setImgSrc(R.drawable.bashi);
            menus.add(mb);
            mb = new MenuBean();
            mb.setTitle("t1");
            mb.setImgSrc(R.drawable.bashi);
            menus.add(mb);
            b.setMenus(menus);
            beans.add(b);
            b = new MainCardBean();
            b.setTitle("Title1");
            b.setBg(R.drawable.faxian);
            menus = new ArrayList<>();
            mb = new MenuBean();
            mb.setTitle("t1");
            mb.setImgSrc(R.drawable.bashi);
            menus.add(mb);
            mb = new MenuBean();
            mb.setTitle("t1");
            mb.setImgSrc(R.drawable.bashi);
            menus.add(mb);
            b.setMenus(menus);
            beans.add(b);
            b = new MainCardBean();
            b.setTitle("Title1");
            b.setBg(R.drawable.faxian);
            menus = new ArrayList<>();
            mb = new MenuBean();
            mb.setTitle("t1");
            mb.setImgSrc(R.drawable.bashi);
            menus.add(mb);
            mb = new MenuBean();
            mb.setTitle("t1");
            mb.setImgSrc(R.drawable.bashi);
            menus.add(mb);
            b.setMenus(menus);
            beans.add(b);
            ret.setData(beans);
        } catch (Throwable e) {
            e.printStackTrace();
            ret.setThrowable(e);
            ExceptionHandler.handleException(App.self, ret);
        }
        return ret;
    }
}
