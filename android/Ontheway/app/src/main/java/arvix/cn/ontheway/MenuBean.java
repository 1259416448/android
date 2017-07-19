package arvix.cn.ontheway;

import java.io.Serializable;

/**
 * Created by yd on 2017/7/18.
 */

public class MenuBean implements Serializable {
    private String title;
    private int imgSrc;
    private String key;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getImgSrc() {
        return imgSrc;
    }

    public void setImgSrc(int imgSrc) {
        this.imgSrc = imgSrc;
    }

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }
}
