package arvix.cn.ontheway.data;

import java.util.ArrayList;
import java.util.List;

import arvix.cn.ontheway.App;
import arvix.cn.ontheway.R;
import arvix.cn.ontheway.bean.MainCardBean;
import arvix.cn.ontheway.bean.MenuBean;
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
            b.setBg(R.drawable.fx_cy_bg);
            List<MenuBean> menus = new ArrayList<>();
            MenuBean mb = new MenuBean();
            mb.setTitle("自助餐");
            mb.setImgSrc(R.drawable.fx_zizhucan);
            menus.add(mb);
            mb = new MenuBean();
            mb.setTitle("咖啡");
            mb.setImgSrc(R.drawable.fx_kafei);
            menus.add(mb);
            mb = new MenuBean();
            mb.setTitle("火锅");
            mb.setImgSrc(R.drawable.fx_huoguo);
            menus.add(mb);
            //
            b.setMenus(menus);
            beans.add(b);
            //item two
            b = new MainCardBean();
            b.setTitle("商店");
            b.setBg(R.drawable.fx_sd_bg);
            menus = new ArrayList<>();
            mb = new MenuBean();
            mb.setTitle("购物");
            mb.setImgSrc(R.drawable.fx_gouwu);
            menus.add(mb);
            mb = new MenuBean();
            mb.setTitle("书店");
            mb.setImgSrc(R.drawable.fx_shudian);
            menus.add(mb);
            mb = new MenuBean();
            mb.setTitle("便利店");
            mb.setImgSrc(R.drawable.fx_bianlidian);
            menus.add(mb);

            b.setMenus(menus);
            beans.add(b);

            //item three
            b = new MainCardBean();
            b.setTitle("文娱");
            b.setBg(R.drawable.fx_wy_bg);
            menus = new ArrayList<>();
            mb = new MenuBean();
            mb.setTitle("电影院");
            mb.setImgSrc(R.drawable.fx_dianyingyuan);
            menus.add(mb);
            mb = new MenuBean();
            mb.setTitle("博物馆");
            mb.setImgSrc(R.drawable.fx_bowuguan);
            menus.add(mb);
            b.setMenus(menus);
            beans.add(b);

            //item four
            b = new MainCardBean();
            b.setTitle("交通");
            b.setBg(R.drawable.fx_jt_bg);
            menus = new ArrayList<>();
            mb = new MenuBean();
            mb.setTitle("巴士");
            mb.setImgSrc(R.drawable.fx_bashi);
            menus.add(mb);
            mb = new MenuBean();
            mb.setTitle("地铁");
            mb.setImgSrc(R.drawable.fx_ditie);
            menus.add(mb);
            mb = new MenuBean();
            mb.setTitle("出租");
            mb.setImgSrc(R.drawable.fx_chuzu);
            menus.add(mb);
            mb = new MenuBean();
            mb.setTitle("飞机");
            mb.setImgSrc(R.drawable.fx_feiji);
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
