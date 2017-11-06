package arvix.cn.ontheway.data;

import java.util.ArrayList;
import java.util.List;

import arvix.cn.ontheway.bean.CommentBean;

/**
 * Created by asdtiang on 2017/7/27 0027.
 * asdtiangxia@163.com
 */

public class NewReplyData {


    public static List<CommentBean> genData(){
        List<CommentBean> resultList = new ArrayList<>();
        for(int i=0;i<10;i++){
            resultList.add(genBean());
        }
        return resultList;
    }

    private static CommentBean genBean(){
        CommentBean commentBean = new CommentBean();
        commentBean.setCommentContent(GenTestData.genContent());
        commentBean.setSourceContent(GenTestData.genContent());
        commentBean.setSourceMsgUserHeader(GenTestData.genRandomUserHeader());
        commentBean.setSourceMsgUserName(GenTestData.genNickname());
        commentBean.setDateCreate(System.currentTimeMillis());
        commentBean.setMainPhoto(GenTestData.genRandomUserHeader());
        commentBean.setUserNickname(GenTestData.genNickname());
        commentBean.setUserHeadImg(GenTestData.genRandomUserHeader());
        return commentBean;
    }


}
