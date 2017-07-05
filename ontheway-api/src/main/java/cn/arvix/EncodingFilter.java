package cn.arvix;

import org.springframework.web.filter.CharacterEncodingFilter;

import javax.servlet.annotation.WebFilter;
import javax.servlet.annotation.WebInitParam;

/**
 * @author Created by yangyang on 2017/3/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@WebFilter(filterName = "encodingFilter", initParams = {
        @WebInitParam(name = "encoding", value = "UTF-8")
}, urlPatterns = "*")
public class EncodingFilter extends CharacterEncodingFilter {

}
