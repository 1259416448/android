package cn.arvix.solr;

import org.apache.solr.client.solrj.SolrClient;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.response.UpdateResponse;
import org.apache.solr.common.SolrInputDocument;

import java.io.IOException;
import java.util.Collection;
import java.util.List;

/**
 * @author Created by yangyang on 2017/8/28.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class SolrServiceImpl implements SolrService {

    private final SolrClient solrClient;

    public SolrServiceImpl(SolrClient solrClient) {
        this.solrClient = solrClient;
    }

    @Override
    public void add(SolrInputDocument doc) throws IOException, SolrServerException {
        UpdateResponse response = getSolrClient().add(doc);
        if (response.getStatus() == 0) {
            solrClient.commit();
        }
    }

    @Override
    public void add(Collection<SolrInputDocument> docs) throws IOException, SolrServerException {
        if (docs != null && docs.size() > 0) {
            UpdateResponse response = getSolrClient().add(docs);
            if (response.getStatus() == 0) {
                solrClient.commit();
            }
        }
    }

    @Override
    public void delete(List<String> ids) throws IOException, SolrServerException {
        if (ids != null && ids.size() > 0) {
            UpdateResponse response = getSolrClient().deleteById(ids);
            if (response.getStatus() == 0) {
                solrClient.commit();
            }
        }
    }

    @Override
    public void delete(String id) throws IOException, SolrServerException {
        UpdateResponse response = getSolrClient().deleteById(id);
        if (response.getStatus() == 0) {
            solrClient.commit();
        }
    }

    @Override
    public SolrClient getSolrClient() {
        return this.solrClient;
    }
}
