package arvix.cn.ontheway.data;

import java.util.ArrayList;
import java.util.List;

import arvix.cn.ontheway.bean.ReplyBean;

/**
 * Created by asdtiang on 2017/7/27 0027.
 * asdtiangxia@163.com
 */

public class NewReplyData {


    public static List<ReplyBean> genData(){
        List<ReplyBean> resultList = new ArrayList<>();
        for(int i=0;i<10;i++){
            resultList.add(genBean());
        }
        return resultList;
    }

    private static ReplyBean  genBean(){
        ReplyBean replyBean = new ReplyBean();
        replyBean.setContent(GenTestData.genContent());
        replyBean.setSourceContent(GenTestData.genContent());
        replyBean.setSourceMsgUserHeader(GenTestData.genRandomUserHeader());
        replyBean.setSourceMsgUserName(GenTestData.genNickname());
        replyBean.setDateCreated(System.currentTimeMillis());
        replyBean.setMainPhoto(GenTestData.genRandomUserHeader());
        replyBean.setReplayUserName(GenTestData.genNickname());
        replyBean.setReplyUserHeader(GenTestData.genRandomUserHeader());
        return replyBean;
    }


}
