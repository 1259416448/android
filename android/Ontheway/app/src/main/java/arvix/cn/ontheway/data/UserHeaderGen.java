package arvix.cn.ontheway.data;

/**
 * Created by asdtiang on 2017/7/27 0027.
 * asdtiangxia@163.com
 */

public class UserHeaderGen {

    public static String genRandomUserHeader(){
        String[] headers = new String[]{"http://img2.woyaogexing.com/2017/07/25/66bb846e361108ad!400x400_big.jpg"
                ,"http://img2.woyaogexing.com/2017/07/25/ec46c28ec4fe2296!400x400_big.jpg"
        ,"http://img2.woyaogexing.com/2017/07/25/317e2f60b66c7225!400x400_big.jpg"
        ,"http://img2.woyaogexing.com/2017/07/25/569413f0bdfdd451!400x400_big.jpg"
        ,"http://img2.woyaogexing.com/2017/07/24/098045a13f6c08f9!400x400_big.jpg"
        ,"http://img2.woyaogexing.com/2017/07/24/c31c7b15b296f73b!400x400_big.jpg"
        ,"http://img2.woyaogexing.com/2017/07/24/13ff9b7f57a285d2!400x400_big.jpg"};
        int maxLength = headers.length-1;
        int index = (int) (Math.random()*maxLength);
        return headers[index];
    }
}
