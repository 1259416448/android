package arvix.cn.ontheway.data;

import java.util.ArrayList;
import java.util.List;

import arvix.cn.ontheway.been.MyTrackBean;
import arvix.cn.ontheway.been.ReplyBean;

/**
 * Created by asdtiang on 2017/7/27 0027.
 * asdtiangxia@163.com
 */

public class NewReplyData {


    public static List<ReplyBean> genData(){
        List<ReplyBean> resultList = new ArrayList<>();
        for(int i=0;i<10;i++){
            resultList.add(genData(UserHeaderGen.genRandomUserHeader(),"陈立"+i,UserHeaderGen.genRandomUserHeader(),
                    UserHeaderGen.genRandomUserHeader(),"高迪"+i,
                    "content"+i,"sContent"+i));
        }
        return resultList;
    }

    private static ReplyBean  genData(String sUserHeader,String sUserName,String mainPhoto,String replyHeader,String replyName,
                                      String content,String sContent){
        ReplyBean replyBean = new ReplyBean();
        replyBean.setContent(content);
        replyBean.setSourceContent(sContent);
        replyBean.setSourceMsgUserHeader(sUserHeader);
        replyBean.setSourceMsgUserName(sUserName);
        replyBean.setDateCreated(System.currentTimeMillis());
        replyBean.setMainPhoto(mainPhoto);
        replyBean.setReplayUserName(replyName);
        replyBean.setReplyUserHeader(replyHeader);
        return replyBean;
    }


}
