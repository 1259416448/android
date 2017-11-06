package arvix.cn.ontheway.ui.ar_draw;

import java.util.List;

/**
 * Created by asdtiang on 2017/8/28 0028.
 * asdtiangxia@163.com
 * ar item draw  重叠时修正draw位置算法
 */
class OverlapFilter {

    static double overlapDis;
    static float diffY;

    static void filter(List<DrawFootPrintItemInfo> pointList){
        if(pointList==null || pointList.size()<=1){
            return;
        }
        int size = pointList.size();
        int sizeLessOne = size -1;
        DrawFootPrintItemInfo tempPointOne = null;
        DrawFootPrintItemInfo tempPointTwo = null;
        float xDiff = 0;
        float yDiff = 0;
        for(int i=0;i< sizeLessOne ; i++){
            for(int j=i+1;j < size;j++){
                tempPointOne = pointList.get(i);
                tempPointTwo = pointList.get(j);
                xDiff = Math.abs(tempPointOne.drawX - tempPointTwo.drawX);
                yDiff = Math.abs(tempPointOne.drawY - tempPointTwo.drawY);
                if( xDiff < tempPointOne.rectWidth && yDiff <tempPointOne.rectHeight){
                    tempPointTwo.drawY = tempPointTwo.drawY - (tempPointOne.rectHeight - yDiff);
                    i=0;
                    j=i+1;
                }
            }
        }
    }
}
