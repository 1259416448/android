import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.ontheway.sys.utils.HmacSHA256Utils;
import com.google.common.collect.Lists;

import java.util.List;
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

    @org.junit.Test
    public void test1() {
        int[] values = new int[0];
        try {
            values = test2(31);
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
        for (int value : values) {
            System.out.println(value);
        }
    }

    public int[] test2(int n) throws IllegalAccessException {
        if(n>31 || n < 1) throw new IllegalAccessException("0 < n <= 31");
        int[] a = new int[n];
        List<Integer> list = Lists.newArrayListWithCapacity(n);
        for (int i = 2; i <= 32; i++) {
            list.add(i);
        }
        for (int i = 0; i < n; i++) {
            Random random = new Random();
            int index = random.nextInt(list.size());
            int value = list.get(index);
            list.remove(index);
            a[i] = value;
        }
        return a;
    }
}
