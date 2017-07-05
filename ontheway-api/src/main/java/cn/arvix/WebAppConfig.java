package cn.arvix;

import cn.arvix.base.common.entity.search.utils.SearchableConvertUtils;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.alibaba.fastjson.support.config.FastJsonConfig;
import com.alibaba.fastjson.support.spring.FastJsonHttpMessageConverter;
import org.redisson.Redisson;
import org.redisson.api.RedissonClient;
import org.redisson.config.Config;
import org.redisson.spring.cache.RedissonSpringCacheManager;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ResourceBundleMessageSource;
import org.springframework.core.io.Resource;
import org.springframework.data.repository.support.DomainClassConverter;
import org.springframework.format.support.DefaultFormattingConversionService;
import org.springframework.http.MediaType;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.service.Contact;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

import java.io.IOException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;

@Configuration
@EnableWebMvc
@EnableSwagger2
@ComponentScan(basePackages = {"cn.arvix.agilemaster.sys.*.controller," +
        "cn.arvix.agilemaster.blog.*.controller," +
        "cn.arvix.qiniu.controller"})
@EnableCaching
//@Import(value = ShiroConfig.class)
public class WebAppConfig extends WebMvcConfigurerAdapter {
    private static final Logger log = LoggerFactory
            .getLogger(WebAppConfig.class);

    @Bean
    public Docket customDocket() {
        return new Docket(DocumentationType.SWAGGER_2).apiInfo(apiInfo());
    }

    private ApiInfo apiInfo() {
        Contact contact = new Contact("唯幻", "http://www.arvix.cn", "zfy@arvix.cn");
        return new ApiInfo("Agilemaster接口文档",//大标题
                "Agilemaster接口文档",//小标题
                "0.0.1",//版本
                "http://www.arvix.cn",
                contact,//作者
                "",//链接显示文字
                ""//网站链接
        );
    }

    // Maps resources path to webapp/resources
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        /*
         * 设置js css文件路径
         */
        registry.addResourceHandler("/resources/**").addResourceLocations("classpath:/static/");
    }

    // Provides internationalization of messages
    @Bean(name = "messageSource")
    public ResourceBundleMessageSource messageSource() {
        ResourceBundleMessageSource source = new ResourceBundleMessageSource();
        source.setBasename("messages");
        source.setUseCodeAsDefaultMessage(false);
        source.setCacheMillis(60);
        source.setDefaultEncoding("UTF-8");
        return source;
    }

    //使用fastjson
    @Override
    public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {
        StringHttpMessageConverter httpMessageConverter = new StringHttpMessageConverter(Charset.forName("UTF-8"));
        List<MediaType> mediaTypes0 = new ArrayList<>();
        mediaTypes0.add(MediaType.ALL);
        httpMessageConverter.setSupportedMediaTypes(mediaTypes0);
        FastJsonHttpMessageConverter fastConverter = new FastJsonHttpMessageConverter();
        FastJsonConfig fastJsonConfig = new FastJsonConfig();
        fastJsonConfig.setSerializerFeatures(SerializerFeature.WriteMapNullValue);
        fastConverter.setFastJsonConfig(fastJsonConfig);
        List<MediaType> mediaTypes = new ArrayList<>();
        mediaTypes.add(MediaType.APPLICATION_JSON_UTF8);
        fastConverter.setSupportedMediaTypes(mediaTypes);
        converters.add(httpMessageConverter);
        converters.add(fastConverter);
        super.configureMessageConverters(converters);
    }

    @Bean(destroyMethod = "shutdown")
    public RedissonClient redisson(@Value("classpath:config/spring-redisson.yaml") Resource configFile) throws IOException {
        Config config = Config.fromYAML(configFile.getInputStream());
        return Redisson.create(config);
    }

    @Bean
    public CacheManager cacheManager(RedissonClient redissonClient) throws IOException {
        return new RedissonSpringCacheManager(redissonClient, "classpath:config/spring-cache-config.yaml");
    }

    @Bean
    public DomainClassConverter domainClassConverter() {
        DomainClassConverter domainClassConverter = new DomainClassConverter(new DefaultFormattingConversionService());
        SearchableConvertUtils.setConversionService(new DefaultFormattingConversionService());
        return domainClassConverter;
    }


}


