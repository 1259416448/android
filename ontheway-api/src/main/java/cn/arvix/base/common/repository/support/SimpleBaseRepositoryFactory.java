package cn.arvix.base.common.repository.support;

import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.base.common.repository.callback.SearchCallback;
import cn.arvix.base.common.repository.support.annotation.SearchableQuery;
import org.springframework.beans.BeanUtils;
import org.springframework.core.annotation.AnnotationUtils;
import org.springframework.data.jpa.provider.PersistenceProvider;
import org.springframework.data.jpa.provider.QueryExtractor;
import org.springframework.data.jpa.repository.query.JpaQueryLookupStrategy;
import org.springframework.data.jpa.repository.support.JpaEntityInformation;
import org.springframework.data.jpa.repository.support.JpaEntityInformationSupport;
import org.springframework.data.jpa.repository.support.JpaRepositoryFactory;
import org.springframework.data.jpa.repository.support.QueryDslJpaRepository;
import org.springframework.data.repository.core.RepositoryInformation;
import org.springframework.data.repository.core.RepositoryMetadata;
import org.springframework.data.repository.core.support.RepositoryFactorySupport;
import org.springframework.data.repository.query.EvaluationContextProvider;
import org.springframework.data.repository.query.QueryLookupStrategy;
import org.springframework.util.Assert;
import org.springframework.util.StringUtils;

import javax.persistence.EntityManager;
import java.io.Serializable;

/**
 * @author Created by yangyang on 2017/3/4.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class SimpleBaseRepositoryFactory extends RepositoryFactorySupport {

    private EntityManager entityManager;
    private final QueryExtractor extractor;
    private final CrudMethodMetadataPostProcessor crudMethodMetadataPostProcessor;

    /**
     * Creates a new {@link JpaRepositoryFactory}.
     *
     * @param entityManager must not be {@literal null}
     */
    public SimpleBaseRepositoryFactory(EntityManager entityManager) {
        Assert.notNull(entityManager);

        this.entityManager = entityManager;
        this.extractor = PersistenceProvider.fromEntityManager(entityManager);
        this.crudMethodMetadataPostProcessor = new CrudMethodMetadataPostProcessor();
        addRepositoryProxyPostProcessor(crudMethodMetadataPostProcessor);

    }

    /*
         * (non-Javadoc)
    	 * @see org.springframework.data.repository.core.support.RepositoryFactorySupport#setBeanClassLoader(java.lang.ClassLoader)
    	 */
    @Override
    public void setBeanClassLoader(ClassLoader classLoader) {
        super.setBeanClassLoader(classLoader);
        this.crudMethodMetadataPostProcessor.setBeanClassLoader(classLoader);
    }

    protected Object getTargetRepository(RepositoryInformation metadata) {
        Class<?> repositoryInterface = metadata.getRepositoryInterface();
        if (isBaseRepository(repositoryInterface)) {
            JpaEntityInformation<?, ?> entityInformation = getEntityInformation(metadata.getDomainType());
            SimpleBaseRepository repository = new SimpleBaseRepository<>(entityInformation, entityManager);

            SearchableQuery searchableQuery = AnnotationUtils.findAnnotation(repositoryInterface, SearchableQuery.class);
            if (searchableQuery != null) {
                String countAllQL = searchableQuery.countAllQuery();
                if (!StringUtils.isEmpty(countAllQL)) {
                    repository.setCountAllQL(countAllQL);
                }
                String findAllQL = searchableQuery.findAllQuery();
                if (!StringUtils.isEmpty(findAllQL)) {
                    repository.setFindAllQL(findAllQL);
                }
                Class<? extends SearchCallback> callbackClass = searchableQuery.callbackClass();
                if (callbackClass != SearchCallback.class) {
                    repository.setSearchCallback(BeanUtils.instantiate(callbackClass));
                }

                repository.setJoins(searchableQuery.joins());

            }
            repository.setRepositoryMethodMetadata(crudMethodMetadataPostProcessor.getCrudMethodMetadata());
            return repository;
        }
        return null;
    }

    protected Class<?> getRepositoryBaseClass(RepositoryMetadata metadata) {
        if (isBaseRepository(metadata.getRepositoryInterface())) {
            return SimpleBaseRepository.class;
        }
        return QueryDslJpaRepository.class;
    }

    private boolean isBaseRepository(Class<?> repositoryInterface) {
        return BaseRepository.class.isAssignableFrom(repositoryInterface);
    }

    /*
     * (non-Javadoc)
     * @see org.springframework.data.repository.core.support.RepositoryFactorySupport#getQueryLookupStrategy(org.springframework.data.repository.query.QueryLookupStrategy.Key, org.springframework.data.repository.query.EvaluationContextProvider)
     */
    @Override
    protected QueryLookupStrategy getQueryLookupStrategy(QueryLookupStrategy.Key key, EvaluationContextProvider evaluationContextProvider) {
        return JpaQueryLookupStrategy.create(entityManager, key, extractor, evaluationContextProvider);
    }

    /*
         * (non-Javadoc)
    	 *
    	 * @see
    	 * org.springframework.data.repository.support.RepositoryFactorySupport#
    	 * getEntityInformation(java.lang.Class)
    	 */
    @Override
    @SuppressWarnings("unchecked")
    public <M, ID extends Serializable> JpaEntityInformation<M, ID> getEntityInformation(Class<M> domainClass) {

        return (JpaEntityInformation<M, ID>) JpaEntityInformationSupport.getEntityInformation(domainClass, entityManager);
    }

}
