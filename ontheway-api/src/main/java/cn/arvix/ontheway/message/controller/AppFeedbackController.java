package cn.arvix.ontheway.message.controller;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.web.controller.ExceptionHandlerController;
import cn.arvix.ontheway.message.entity.Feedback;
import cn.arvix.ontheway.message.service.FeedbackService;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author Created by yangyang on 2017/10/25.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@Controller
@RequestMapping(value = "/app/feedback")
public class AppFeedbackController extends ExceptionHandlerController {

    private final FeedbackService feedbackService;

    @Autowired
    public AppFeedbackController(FeedbackService feedbackService) {
        this.feedbackService = feedbackService;
    }


    @ApiOperation(value = "提交增加意见反馈")
    @ResponseBody
    @PostMapping(value = "/create")
    public JSONResult create(@RequestBody Feedback m) {
        return feedbackService.save_(m);
    }

}
