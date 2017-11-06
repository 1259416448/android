package cn.arvix.ontheway.message.service;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.entity.PageResult;
import cn.arvix.base.common.entity.search.PageRequest;
import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.ontheway.message.dto.MessageTaskDetail;
import cn.arvix.ontheway.message.entity.SystemMessage;
import com.google.common.collect.Maps;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.Map;

/**
 * @author Created by yangyang on 2017/10/25.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class SystemMessageService extends BaseServiceImpl<SystemMessage, Long> {

    private NewMessageCountService newMessageCountService;

    @Autowired
    public void setNewMessageCountService(NewMessageCountService newMessageCountService) {
        this.newMessageCountService = newMessageCountService;
    }

    /**
     * 添加系统消息，并通知所有用户
     *
     * @param m 实体
     * @return 添加结果
     */
    @Transactional
    public JSONResult save_(SystemMessage m) {

        JSONResult jsonResult = super.save_(m);

        newMessageCountService.updateAllUserSystemCount(1);

        //增加系统推送

        return jsonResult;
    }


    /**
     * App 客户端获取数据
     */
    public JSONResult appSearch(int number, int size, Long currentTime, boolean clear) {
        if (clear) {
            newMessageCountService.updateNewMessageCache(MessageTaskDetail.TaskType.clearSystem);
        }
        return search(number, size, currentTime);
    }

    /**
     * 分页获取系统消息
     *
     * @return 系统消息s
     */
    public JSONResult search(int number, int size, Long currentTime) {
        if (number < 0) number = 0;
        if (size > 30) size = 15;

        Map<String, Object> params = Maps.newHashMap();

        if (currentTime == null) {
            currentTime = System.currentTimeMillis();
        }
        params.put("dateCreated_lte", new Date(currentTime));

        Searchable searchable = Searchable.newSearchable(params,
                new PageRequest(number, size), new Sort(Sort.Direction.DESC, "dateCreated"))
                .setEnableToMap(true);

        Page page = super.findAllWithNoCount(searchable);
        ((PageResult) page).setCurrentTime(currentTime);
        return JsonUtil.getSuccess(CommonContact.FETCH_SUCCESS, CommonContact.FETCH_SUCCESS, page);
    }

}
