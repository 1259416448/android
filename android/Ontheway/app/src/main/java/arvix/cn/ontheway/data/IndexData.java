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
            //item one
            b.setTitle("餐饮");
            b.setBg(R.drawable.faxian);
            List<MenuBean> menus = new ArrayList<>();
            MenuBean mb = new MenuBean();
            mb.setTitle("自助餐");
            mb.setImgSrc(R.drawable.zizhucan);
            menus.add(mb);
            mb = new MenuBean();
            mb.setTitle("咖啡");
            mb.setImgSrc(R.drawable.kafei);
            menus.add(mb);
            mb = new MenuBean();
            mb.setTitle("火锅");
            mb.setImgSrc(R.drawable.huoguo);
            menus.add(mb);
            //
            b.setMenus(menus);
            beans.add(b);
            //item two
            b = new MainCardBean();
            b.setTitle("商店");
            b.setBg(R.drawable.faxian);
            menus = new ArrayList<>();
            mb = new MenuBean();
            mb.setTitle("购物");
            mb.setImgSrc(R.drawable.gouwu);
            menus.add(mb);
            mb = new MenuBean();
            mb.setTitle("书店");
            mb.setImgSrc(R.drawable.shudian);
            menus.add(mb);
            mb = new MenuBean();
            mb.setTitle("便利店");
            mb.setImgSrc(R.drawable.bianlidian);
            menus.add(mb);

            b.setMenus(menus);
            beans.add(b);

            //item three
            b = new MainCardBean();
            b.setTitle("文娱");
            b.setBg(R.drawable.faxian);
            menus = new ArrayList<>();
            mb = new MenuBean();
            mb.setTitle("电影院");
            mb.setImgSrc(R.drawable.dianyingyuan);
            menus.add(mb);
            mb = new MenuBean();
            mb.setTitle("博物馆");
            mb.setImgSrc(R.drawable.bowuguan);
            menus.add(mb);
            b.setMenus(menus);
            beans.add(b);

            //item four
            b = new MainCardBean();
            b.setTitle("交通");
            b.setBg(R.drawable.faxian);
            menus = new ArrayList<>();
            mb = new MenuBean();
            mb.setTitle("巴士");
            mb.setImgSrc(R.drawable.bashi);
            menus.add(mb);
            mb = new MenuBean();
            mb.setTitle("地铁");
            mb.setImgSrc(R.drawable.ditie);
            menus.add(mb);
            mb = new MenuBean();
            mb.setTitle("出租");
            mb.setImgSrc(R.drawable.chuzu);
            menus.add(mb);
            mb = new MenuBean();
            mb.setTitle("飞机");
            mb.setImgSrc(R.drawable.feiji);
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
