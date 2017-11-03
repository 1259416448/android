package arvix.cn.ontheway.ui.ar_draw;

/**
 * Created by asdtiang on 2017/8/23 0023.
 * asdtiangxia@163.com
 * draw：表示在相机视图中绘制足迹信息view。
 * 实现足迹draw频率变化，当手机移动快时，减小draw检测频率值，使draw的频率加快，当手机基本不动时，增加draw检测频率值，使draw的频率变慢以至不再draw;
 * draw的检测频率值，即手机位置变化后，各个方向参数差值绝对值和，draw的频率和这个值成反比关系。
 *
 */

public class DrawMoveCheck {
    public static boolean isMoving = false;
    private int checkArraySize = 5;
    //这个值越小，移动手机时draw频率会加快。
    float moveDiffAbsMin = 0.01f;
    float moveDiffAbsMax = 0.3f;
    float moveDiffAbs = moveDiffAbsMin;
    float[] diffAbsArray = new float[checkArraySize+1];

    public void addMoveDiffAbs(float diffAbs){
        for(int i=0;i<checkArraySize;i++){
            diffAbsArray[i+1] = diffAbsArray[i];
        }
        diffAbsArray[0] = diffAbs;
    }
    public void computeMoveDiffAbs(){
        isMoving = false;
        for(int i=0;i<=checkArraySize;i++){
            if(diffAbsArray[i]>moveDiffAbsMax){
                moveDiffAbs = moveDiffAbsMin;
                isMoving = true;
                break;
            }
        }
        if(isMoving==false){
            moveDiffAbs = moveDiffAbsMax;
        }
    }

}
