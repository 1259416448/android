package cn.arvix.ontheway.sys.utils;

import org.apache.shiro.util.SimpleByteSource;

import java.io.Serializable;

/**
 * @author Created by yangyang on 2017/1/7.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class MySimpleByteSource extends SimpleByteSource implements Serializable {

    public MySimpleByteSource(byte[] bytes) {
        super(bytes);
    }

    public MySimpleByteSource(String string) {
        super(string);
    }
}
