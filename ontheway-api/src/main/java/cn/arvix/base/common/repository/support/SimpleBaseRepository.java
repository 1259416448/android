package cn.arvix.base.common.repository.support;

import cn.arvix.base.common.entity.PageResult;
import cn.arvix.base.common.entity.search.Pageable;
import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.plugin.entity.LogicDeleteable;
import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.base.common.repository.RepositoryHelper;
import cn.arvix.base.common.repository.callback.SearchCallback;
import cn.arvix.base.common.repository.support.annotation.QueryJoin;
import cn.arvix.base.common.utils.JsonUtil;
import com.google.common.collect.Sets;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang3.ArrayUtils;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.support.CrudMethodMetadata;
import org.springframework.data.jpa.repository.support.JpaEntityInformation;
import org.springframework.data.jpa.repository.support.SimpleJpaRepository;
import org.springframework.data.repository.support.PageableExecutionUtils;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import javax.persistence.*;
import javax.persistence.criteria.*;
import java.io.Serializable;
import java.util.*;

import static org.springframework.data.jpa.repository.query.QueryUtils.toOrders;

/**
 * @author Created by yangyang on 2017/3/4.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class SimpleBaseRepository<M, ID extends Serializable> extends SimpleJpaRepository<M, ID>
        implements BaseRepository<M, ID> {

    public static final String LOGIC_DELETE_ALL_QUERY_STRING = "update %s x set x.deleted=true where x in (?1)";
    public static final String DELETE_ALL_QUERY_STRING = "delete from %s x where x in (?1)";
    public static final String FIND_QUERY_STRING = "from %s x where 1=1 ";
    public static final String COUNT_QUERY_STRING = "select count(x) from %s x where 1=1 ";

    private final JpaEntityInformation<M, ID> entityInformation;
    private final EntityManager em;
    private final RepositoryHelper repositoryHelper;

    private CrudMethodMetadata metadata;

    private Class<M> entityClass;
    private String entityName;
    private String idName;


    /**
     * 查询所有的QL
     */
    private String findAllQL;
    /**
     * 统计QL
     */
    private String countAllQL;

    private QueryJoin[] joins;

    private SearchCallback searchCallback = SearchCallback.DEFAULT;

    /**
     * Creates a new {@link SimpleJpaRepository} to manage objects of the given {@link JpaEntityInformation}.
     *
     * @param entityInformation must not be {@literal null}.
     * @param entityManager     must not be {@literal null}.
     */
    public SimpleBaseRepository(JpaEntityInformation<M, ID> entityInformation, EntityManager entityManager) {
        super(entityInformation, entityManager);

        this.entityInformation = entityInformation;
        this.em = entityManager;

        this.entityClass = this.entityInformation.getJavaType();
        this.entityName = this.entityInformation.getEntityName();
        this.idName = this.entityInformation.getIdAttributeNames().iterator().next();
        findAllQL = String.format(FIND_QUERY_STRING, entityName);
        countAllQL = String.format(COUNT_QUERY_STRING, entityName);
        repositoryHelper = new RepositoryHelper(entityClass);
        repositoryHelper.setEntityManager(entityManager);
    }

    /**
     * 设置searchCallback
     *
     * @param searchCallback
     */
    public void setSearchCallback(SearchCallback searchCallback) {
        this.searchCallback = searchCallback;
    }

    /**
     * 设置查询所有的ql
     *
     * @param findAllQL
     */
    public void setFindAllQL(String findAllQL) {
        this.findAllQL = findAllQL;
    }

    /**
     * 设置统计的ql
     *
     * @param countAllQL
     */
    public void setCountAllQL(String countAllQL) {
        this.countAllQL = countAllQL;
    }

    public void setJoins(QueryJoin[] joins) {
        this.joins = joins;
    }


    /**
     * Configures a custom {@link CrudMethodMetadata} to be used to detect {@link LockModeType}s and query hints to be
     * applied to queries.
     *
     * @param crudMethodMetadata
     */
    public void setRepositoryMethodMetadata(CrudMethodMetadata crudMethodMetadata) {
        super.setRepositoryMethodMetadata(crudMethodMetadata);
        this.metadata = crudMethodMetadata;
    }

    protected CrudMethodMetadata getRepositoryMethodMetadata() {
        return metadata;
    }

    /////////////////////////////////////////////////
    ////////覆盖默认spring data jpa的实现////////////
    /////////////////////////////////////////////////

    /**
     * 根据主键删除相应实体
     *
     * @param id 主键
     */
    @Transactional
    @Override
    public void delete(final ID id) {
        M m = findOne(id);
        delete(m);
    }

    /**
     * 删除实体
     *
     * @param m 实体
     */
    @Transactional
    @Override
    public void delete(final M m) {
        if (m == null) {
            return;
        }
        if (m instanceof LogicDeleteable) {
            ((LogicDeleteable) m).markDeleted();
            save(m);
        } else {
            super.delete(m);
        }
    }


    /**
     * 根据主键删除相应实体
     *
     * @param ids 实体
     */
    @Transactional
    @Override
    public void delete(final ID[] ids) {
        if (ArrayUtils.isEmpty(ids)) {
            return;
        }
        List<M> models = new ArrayList<M>();
        for (ID id : ids) {
            M model = null;
            try {
                model = entityClass.newInstance();
            } catch (Exception e) {
                throw new RuntimeException("batch delete " + entityClass + " error", e);
            }
            try {
                BeanUtils.setProperty(model, idName, id);
            } catch (Exception e) {
                throw new RuntimeException("batch delete " + entityClass + " error, can not set id", e);
            }
            models.add(model);
        }
        deleteInBatch(models);
    }

    @Transactional
    @Override
    public void deleteInBatch(final Iterable<M> entities) {
        Iterator<M> iter = entities.iterator();
        if (entities == null || !iter.hasNext()) {
            return;
        }

        Set models = Sets.newHashSet(iter);

        boolean logicDeleteableEntity = LogicDeleteable.class.isAssignableFrom(this.entityClass);

        if (logicDeleteableEntity) {
            String ql = String.format(LOGIC_DELETE_ALL_QUERY_STRING, entityName);
            repositoryHelper.batchUpdate(ql, models);
        } else {
            String ql = String.format(DELETE_ALL_QUERY_STRING, entityName);
            repositoryHelper.batchUpdate(ql, models);
        }
    }

    /**
     * 按照主键查询
     *
     * @param id 主键
     * @return 返回id对应的实体
     */
    @Transactional
    @Override
    public M findOne(ID id) {
        if (id == null) {
            return null;
        }
        if (id instanceof Integer && (Integer) id == 0) {
            return null;
        }
        if (id instanceof Long && (Long) id == 0L) {
            return null;
        }
        return super.findOne(id);
    }


    ////////根据Specification查询 直接从SimpleJpaRepository复制过来的///////////////////////////////////

    @Override
    public M findOne(Specification<M> spec) {
        try {
            return getQuery(spec, (Sort) null).getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }


    /*
     * (non-Javadoc)
     * @see org.springframework.data.repository.CrudRepository#findAll(ID[])
     */
    public List<M> findAll(Iterable<ID> ids) {

        return getQuery((root, query, cb) -> {
            Path<?> path = root.get(entityInformation.getIdAttribute());
            return path.in(cb.parameter(Iterable.class, "ids"));
        }, (Sort) null).setParameter("ids", ids).getResultList();
    }


    /*
     * (non-Javadoc)
     * @see org.springframework.data.jpa.repository.JpaSpecificationExecutor#findAll(org.springframework.data.jpa.domain.Specification)
     */
    public List<M> findAll(Specification<M> spec) {
        return getQuery(spec, (Sort) null).getResultList();
    }

    /*
     * (non-Javadoc)
     * @see org.springframework.data.jpa.repository.JpaSpecificationExecutor#findAll(org.springframework.data.jpa.domain.Specification, org.springframework.data.domain.Pageable)
     */
    public Page<M> findAll(Specification<M> spec, Pageable pageable) {

        TypedQuery<M> query = getQuery(spec, pageable);
        return pageable == null ? new PageImpl<M>(query.getResultList())
                : readPage(query, entityClass, pageable, spec);
    }

    /*
     * (non-Javadoc)
     * @see org.springframework.data.jpa.repository.JpaSpecificationExecutor#findAll(org.springframework.data.jpa.domain.Specification, org.springframework.data.domain.Sort)
     */
    public List<M> findAll(Specification<M> spec, Sort sort) {

        return getQuery(spec, sort).getResultList();
    }

    /*
     * (non-Javadoc)
     * @see org.springframework.data.jpa.repository.JpaSpecificationExecutor#count(org.springframework.data.jpa.domain.Specification)
     */
    public long count(Specification<M> spec) {

        return getCountQuery(spec, entityClass).getSingleResult();
    }

    ////////根据Specification查询 直接从SimpleJpaRepository复制过来的///////////////////////////////////

    /**
     * Reads the given {@link TypedQuery} into a {@link Page} applying the given {@link Pageable} and
     * {@link Specification}.
     *
     * @param query       must not be {@literal null}.
     * @param domainClass must not be {@literal null}.
     * @param spec        can be {@literal null}.
     * @param pageable    can be {@literal null}.
     * @return
     */
    protected <S extends M> Page<S> readPage(TypedQuery<S> query, final Class<S> domainClass, Pageable pageable,
                                             final Specification<S> spec) {

        query.setFirstResult(pageable.getOffset());
        query.setMaxResults(pageable.getPageSize());

        return PageableExecutionUtils.getPage(query.getResultList(), pageable, new PageableExecutionUtils.TotalSupplier() {

            @Override
            public long get() {
                return executeCountQuery(getCountQuery(spec, domainClass));
            }
        });
    }

    /**
     * Executes a count query and transparently sums up all values returned.
     *
     * @param query must not be {@literal null}.
     * @return
     */
    private static Long executeCountQuery(TypedQuery<Long> query) {

        Assert.notNull(query);

        List<Long> totals = query.getResultList();
        Long total = 0L;

        for (Long element : totals) {
            total += element == null ? 0 : element;
        }

        return total;
    }

    /**
     * Creates a new count query for the given {@link Specification}.
     *
     * @param spec        can be {@literal null}.
     * @param domainClass must not be {@literal null}.
     * @return
     */
    protected <S extends M> TypedQuery<Long> getCountQuery(Specification<S> spec, Class<S> domainClass) {

        CriteriaBuilder builder = em.getCriteriaBuilder();
        CriteriaQuery<Long> query = builder.createQuery(Long.class);

        Root<S> root = applySpecificationToCriteria(spec, domainClass, query);

        if (query.isDistinct()) {
            query.select(builder.countDistinct(root));
        } else {
            query.select(builder.count(root));
        }

        // Remove all Orders the Specifications might have applied
        query.orderBy(Collections.<Order>emptyList());

        TypedQuery<Long> q = em.createQuery(query);
        repositoryHelper.applyEnableQueryCache(q);

        return q;
    }


    /**
     * Creates a new {@link TypedQuery} from the given {@link Specification}.
     *
     * @param spec     can be {@literal null}.
     * @param pageable can be {@literal null}.
     * @return
     */
    protected TypedQuery<M> getQuery(Specification<M> spec, Pageable pageable) {

        Sort sort = pageable == null ? null : pageable.getSort();
        return getQuery(spec, sort);
    }

    /**
     * Creates a {@link TypedQuery} for the given {@link Specification} and {@link Sort}.
     *
     * @param spec can be {@literal null}.
     * @param sort can be {@literal null}.
     * @return
     */
    protected TypedQuery<M> getQuery(Specification<M> spec, Sort sort) {

        CriteriaBuilder builder = em.getCriteriaBuilder();
        CriteriaQuery<M> query = builder.createQuery(entityClass);

        Root<M> root = applySpecificationToCriteria(spec, entityClass, query);
        query.select(root);

        applyJoins(root);

        if (sort != null) {
            query.orderBy(toOrders(sort, root, builder));
        }

        TypedQuery<M> q = em.createQuery(query);

        repositoryHelper.applyEnableQueryCache(q);

        return applyRepositoryMethodMetadata(q);
    }

    private void applyJoins(Root<M> root) {
        if (joins == null) {
            return;
        }

        for (QueryJoin join : joins) {
            root.join(join.property(), join.joinType());
        }
    }


    /**
     * Applies the given {@link Specification} to the given {@link CriteriaQuery}.
     *
     * @param spec        can be {@literal null}.
     * @param domainClass must not be {@literal null}.
     * @param query       must not be {@literal null}.
     * @return
     */
    private <S, U extends M> Root<U> applySpecificationToCriteria(Specification<U> spec, Class<U> domainClass,
                                                                  CriteriaQuery<S> query) {

        Assert.notNull(query);
        Assert.notNull(domainClass);
        Root<U> root = query.from(domainClass);

        if (spec == null) {
            return root;
        }

        CriteriaBuilder builder = em.getCriteriaBuilder();
        Predicate predicate = spec.toPredicate(root, query, builder);

        if (predicate != null) {
            query.where(predicate);
        }

        return root;
    }

    private <S> TypedQuery<S> applyRepositoryMethodMetadata(TypedQuery<S> query) {
        if (metadata == null) {
            return query;
        }

        LockModeType type = metadata.getLockModeType();
        TypedQuery<S> toReturn = type == null ? query : query.setLockMode(type);

        applyQueryHints(toReturn);

        return toReturn;
    }

    private void applyQueryHints(Query query) {

        for (Map.Entry<String, Object> hint : getQueryHints().entrySet()) {
            query.setHint(hint.getKey(), hint.getValue());
        }
    }

    ///////直接从SimpleJpaRepository复制过来的///////////////////////////////


    @Override
    public List<M> findAll() {
        return repositoryHelper.findAll(findAllQL);
    }

    @Override
    public List<M> findAll(final Sort sort) {
        return repositoryHelper.findAll(findAllQL, sort);
    }

    @Override
    public Page<M> findAll(final Pageable pageable) {
        List<M> list = repositoryHelper.findAll(findAllQL, pageable);
        return new PageResult<>(
                pageable.getEnableToMap() ? JsonUtil.getBaseEntityMapList(list) : list,
                pageable,
                repositoryHelper.count(countAllQL)
        );
    }

    @Override
    public long count() {
        return repositoryHelper.count(countAllQL);
    }

    /////////////////////////////////////////////////
    ///////////////////自定义实现////////////////////
    /////////////////////////////////////////////////

    @Override
    public Page<M> findAll(final Searchable searchable) {
        List<M> list = repositoryHelper.findAll(findAllQL, searchable, searchCallback);
        long total = searchable.hasPageable() ? count(searchable) : list.size();
        return new PageResult<>(
                searchable.getEnableToMap() ? JsonUtil.getBaseEntityMapList(list) : list,
                searchable.getPage(),
                total
        );
    }

    @Override
    public long count(final Searchable searchable) {
        return repositoryHelper.count(countAllQL, searchable, searchCallback);
    }

    @Override
    public Class<M> getEntityClass() {
        return this.entityClass;
    }

    @Override
    public String getEntityName() {
        return this.entityName;
    }

    /**
     * 重写默认的 这样可以走一级/二级缓存
     *
     * @param id
     * @return
     */
    @Override
    public boolean exists(ID id) {
        return findOne(id) != null;
    }

}
