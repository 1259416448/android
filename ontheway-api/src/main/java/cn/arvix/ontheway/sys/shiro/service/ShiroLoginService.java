package cn.arvix.ontheway.sys.shiro.service;

import cn.arvix.ontheway.sys.config.service.ConfigService;
import cn.arvix.ontheway.sys.user.entity.User;
import cn.arvix.ontheway.sys.user.entity.UserStatus;
import cn.arvix.ontheway.sys.user.entity.UserType;
import cn.arvix.ontheway.sys.user.repository.UserRepository;
import cn.arvix.ontheway.sys.utils.EndecryptUtils;
import cn.arvix.base.common.utils.CommonContact;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Objects;

/**
 * @author Created by yangyang on 2017/3/13.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class ShiroLoginService {

    private final UserRepository userRepository;

    private final ConfigService configService;


    @Autowired
    public ShiroLoginService(UserRepository userRepository,
                             ConfigService configService) {
        this.userRepository = userRepository;
        this.configService = configService;
    }

    /**
     * 登陆操作
     *
     * @param usernamePasswordToken 登陆token
     * @return 结果
     */
    public User login(UsernamePasswordToken usernamePasswordToken) {
        String rootName = configService.getConfigString(CommonContact.ROOT_NAME);
        if (Objects.equals(EndecryptUtils.encrytBase64(usernamePasswordToken.getUsername()), rootName)) {
            User user = new User();
            user.setUsername(rootName);
            user.setSalt("cn/arvix");
            user.setUserType(UserType.dev);
            user.setId(configService.getConfigBigDecimal(CommonContact.ROOT_ID).longValue());
            user.setPassword(configService.getConfigString(CommonContact.ROOT_PASSWORD));
            user.setStatus(UserStatus.normal);
            return user;
        }
        return userRepository.findByUserNameOrEmailAndOrMobilePhoneNumber(usernamePasswordToken.getUsername());
    }

}
