package cn.arvix.ontheway.message.service;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.entity.PageResult;
import cn.arvix.base.common.entity.search.PageRequest;
import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.ontheway.message.entity.Feedback;
import cn.arvix.ontheway.sys.user.entity.User;
import com.google.common.collect.Maps;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.Map;

/**
 * @author Created by yangyang on 2017/10/25.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class FeedbackService extends BaseServiceImpl<Feedback, Long> {

    /**
     * 保存用户反馈
     *
     * @param m 实体
     * @return 操作结果
     */
    public JSONResult save_(Feedback m) {
        User user = webContextUtils.getCheckCurrentUser();
        m.setUserId(user.getId());
        return super.save_(m);
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

        Page page = super.findAll(searchable);
        ((PageResult) page).setCurrentTime(currentTime);
        return JsonUtil.getSuccess(CommonContact.FETCH_SUCCESS, CommonContact.FETCH_SUCCESS, page);
    }

}
