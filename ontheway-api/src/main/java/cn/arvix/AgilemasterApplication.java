package cn.arvix;

import cn.arvix.base.common.repository.support.SimpleBaseRepositoryFactoryBean;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.boot.web.support.SpringBootServletInitializer;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

/**
 * @author Created by yangyang on 2017/3/1.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@SpringBootApplication
@ServletComponentScan
@EnableAutoConfiguration
@EnableAspectJAutoProxy
@EnableJpaRepositories(
        repositoryFactoryBeanClass = SimpleBaseRepositoryFactoryBean.class)
public class AgilemasterApplication extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        application.sources(AgilemasterApplication.class);
        return application;
    }

    public static void main(String[] args) {
        SpringApplication.run(AgilemasterApplication.class, args);
    }

}
