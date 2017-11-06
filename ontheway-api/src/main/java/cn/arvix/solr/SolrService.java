package cn.arvix.solr;

import org.apache.solr.client.solrj.SolrClient;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.common.SolrInputDocument;

import java.io.IOException;
import java.util.Collection;
import java.util.List;

/**
 * @author Created by yangyang on 2017/8/28.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface SolrService {
    //添加对象到全文检索
    void add(SolrInputDocument doc) throws IOException, SolrServerException;

    void add(Collection<SolrInputDocument> docs) throws IOException, SolrServerException;

    //全文检索中移除对象
    void delete(List<String> ids) throws IOException, SolrServerException;

    void delete(String id) throws IOException, SolrServerException;

    SolrClient getSolrClient();
}
