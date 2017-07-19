package arvix.cn.ontheway;

import java.io.Serializable;
import java.util.List;

/**
 * Created by yd on 2017/7/18.
 */

public class MainCardBean implements Serializable {
    private String title;
    private int bg;
    private List<MenuBean> menus;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getBg() {
        return bg;
    }

    public void setBg(int bg) {
        this.bg = bg;
    }

    public List<MenuBean> getMenus() {
        return menus;
    }

    public void setMenus(List<MenuBean> menus) {
        this.menus = menus;
    }
}
