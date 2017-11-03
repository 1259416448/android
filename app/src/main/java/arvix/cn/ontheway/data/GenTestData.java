package arvix.cn.ontheway.data;

/**
 * Created by asdtiang on 2017/7/27 0027.
 * asdtiangxia@163.com
 */

public class GenTestData {

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

    public static String genContent(){

        String[] coutents = new String[]{"香甜的桂花馅料里裹着核桃仁，用井水来淘洗像珍珠一样的江"
                ,"万点灯光，羞照舞钿歌箔。玉梅消瘦，恨东皇命薄"
                ,"一片风流，今夕与谁同乐。月台花馆，慨尘埃漠漠。豪华荡尽"
                ,"香甜的桂花馅料里裹着核桃仁，用井水来淘洗像珍珠一样的江米."
                ,"香甜的桂花馅料里裹着核桃仁，用井水来淘洗像珍珠一样的江米，听说马思远家的滴粉汤圆做得好，趁着试灯的光亮在风里卖元宵。"
                ,"你在哪？没上班吗？我还在搬砖呢！有空召集一下人马大家聚一下！"
                ,"童年的纸飞机 现在终於飞回我手里，所谓的那快乐 赤脚在田里追蜻蜓追到累了"
        ,"玩的很嗨啊，你是修了多长时间的图，树都变形了，大家都知道你长啥样，哈哈！"
        ,"对这个世界如果你有太多的抱怨 跌倒了 就不敢继续往前走 为什麼"
        ,"自从认识你那一天开始,我的生活就变了模样。心里装的一切全都是你,已经不能"};
        int maxLength = coutents.length-1;
        int index = (int) (Math.random()*maxLength);
        return coutents[index];

    }

    public static String genNickname(){

        String[] coutents = new String[]{"陈立"
                ,"许小北"
                ,"李雪"
                ,"王强"
                ,"姚国平"
                ,"李世康"
                ,"孙江"
                ,"苏玉扬"
                ,"林星"};
        int maxLength = coutents.length-1;
        int index = (int) (Math.random()*maxLength);
        return coutents[index];

    }
}
