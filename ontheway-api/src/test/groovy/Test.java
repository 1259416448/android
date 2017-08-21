import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.ontheway.sys.utils.HmacSHA256Utils;

import java.util.Objects;
import java.util.Random;
import java.util.UUID;

/**
 * @author Created by yangyang on 2017/7/6.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class Test {

    @org.junit.Test
    public void uuidKey() {
        System.out.println(UUID.randomUUID().toString().replace("-", ""));
    }

    @org.junit.Test
    public void mobileDigest() {
        System.out.println(HmacSHA256Utils.digest(CommonContact.HMAC256_KEY, "mobile:18402847183"));
    }

    @org.junit.Test
    public void mobilePass() {
        System.out.println("18580128658".substring("18580128658".length() - 6, "18580128658".length()));
        System.out.println("18580128658".substring(0, 3) + "****" + "18580128658".substring("18580128658".length() - 4, "18580128658".length()));
    }

    @org.junit.Test
    public void headImg() {
        Random random = new Random();
        int i = 0;
        while (i < 100) {
            System.out.println(random.nextInt(14));
            i++;
        }
    }

    @org.junit.Test
    public void test() {
        System.out.println(Objects.equals(null, null));
    }
}
