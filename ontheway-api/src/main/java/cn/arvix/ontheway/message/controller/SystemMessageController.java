package cn.arvix.ontheway.message.controller;

import cn.arvix.base.common.web.controller.BaseCRUDController;
import cn.arvix.ontheway.message.entity.SystemMessage;
import cn.arvix.ontheway.message.service.SystemMessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author Created by yangyang on 2017/10/25.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Controller
@RequestMapping(value = "/api/v1/message")
public class SystemMessageController extends BaseCRUDController<SystemMessage, SystemMessageService, Long> {

    @Autowired
    public SystemMessageController(SystemMessageService service) {
        super(service);
    }

}
