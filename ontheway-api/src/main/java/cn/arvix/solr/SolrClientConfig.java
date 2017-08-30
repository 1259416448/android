package cn.arvix.solr;

import org.apache.commons.lang3.StringUtils;
import org.apache.solr.client.solrj.SolrClient;
import org.apache.solr.client.solrj.impl.HttpSolrClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.annotation.PreDestroy;
import java.io.IOException;

/**
 * @author Created by yangyang on 2017/8/28.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Configuration
@EnableConfigurationProperties(SolrConfig.class)
public class SolrClientConfig {

    private final SolrConfig solrConfig;

    @Autowired
    public SolrClientConfig(SolrConfig solrConfig) {
        this.solrConfig = solrConfig;
    }

    private SolrClient solrClient;

    @PreDestroy
    public void  close(){
        if(this.solrClient != null){
            try {
                this.solrClient.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    @Bean(name = "defaultSolrClient")
    public SolrClient DefaultSolrClient(){
        if(!StringUtils.isEmpty(this.solrConfig.getHost())){
            solrClient =new HttpSolrClient.Builder(this.solrConfig.getHost()).build();
        }
        return solrClient;
    }

}
