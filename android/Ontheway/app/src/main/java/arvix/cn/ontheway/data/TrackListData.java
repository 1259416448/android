package arvix.cn.ontheway.data;

import java.util.ArrayList;
import java.util.List;

import arvix.cn.ontheway.bean.FootPrintBean;

/**
 * Created by asdtiang on 2017/7/25 0025.
 * asdtiangxia@163.com
 */

public class TrackListData {

    public static List<FootPrintBean> genData(){

        List<FootPrintBean> resultList = new ArrayList<>();
        long id = 1;
        resultList.add(genData(7,13,id++,1));
        resultList.add(genData(7,9,id++,2));
        resultList.add(genData(7,8,id++,3));
        resultList.add(genData(7,5,id++,4));
        resultList.add(genData(7,3,id++,5));
        resultList.add(genData(6,13,id++,1));
        resultList.add(genData(6,13,id++,3));
        return resultList;
    }

    public static FootPrintBean genData(int month, int day, long id, int photoCount){
        FootPrintBean footPrintBean = new FootPrintBean();
        footPrintBean.setUserHeadImg(GenTestData.genRandomUserHeader());
        footPrintBean.setFootprintContent(GenTestData.genContent());
        footPrintBean.setDateCreated(System.currentTimeMillis());
        footPrintBean.setFootprintAddress("成都市菁蓉国际广场A1栋");
        footPrintBean.setUserNickname(GenTestData.genNickname());
        footPrintBean.setFootprintId(id);
        footPrintBean.setMonth(month);
        footPrintBean.setDay(""+day);
        footPrintBean.setDayInt(day);
        List<String> photoList = new ArrayList<>();
        if(photoCount==1){
            photoList.add("http://osx4pwgde.bkt.clouddn.com/c47c40d45342467e3f62acb873f296c0.jpg");
        }
        if(photoCount==2){
            photoList.add("http://osx4pwgde.bkt.clouddn.com/c47c40d45342467e3f62acb873f296c0.jpg");
            photoList.add("http://osx4pwgde.bkt.clouddn.com/c7be059cc8634d94c9f9049f8cce2dc4.jpg");
        }
        if(photoCount==3){
            photoList.add("http://osx4pwgde.bkt.clouddn.com/c47c40d45342467e3f62acb873f296c0.jpg");
            photoList.add("http://osx4pwgde.bkt.clouddn.com/c7be059cc8634d94c9f9049f8cce2dc4.jpg");
            photoList.add("http://osx4pwgde.bkt.clouddn.com/bcd6eaf66c9cfa0fd5d8315f705c1552.jpg");
        }
        if(photoCount==4){
            photoList.add("http://osx4pwgde.bkt.clouddn.com/c47c40d45342467e3f62acb873f296c0.jpg");
            photoList.add("http://osx4pwgde.bkt.clouddn.com/c7be059cc8634d94c9f9049f8cce2dc4.jpg");
            photoList.add("http://osx4pwgde.bkt.clouddn.com/bcd6eaf66c9cfa0fd5d8315f705c1552.jpg");
            photoList.add("http://osx4pwgde.bkt.clouddn.com/c0ab21ab26b4694769b6e904788b3590630777.jpg");

        }

        if(photoCount>4){
            for(int i=0;i<photoCount;i++){
                photoList.add("http://osx4pwgde.bkt.clouddn.com/c47c40d45342467e3f62acb873f296c0.jpg");
            }
        }
        footPrintBean.setFootprintPhotoArray(photoList);
        return footPrintBean;
    }

}
