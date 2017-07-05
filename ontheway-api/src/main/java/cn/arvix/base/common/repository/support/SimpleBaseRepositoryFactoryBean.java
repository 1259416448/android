package cn.arvix.base.common.repository.support;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.support.JpaRepositoryFactoryBean;
import org.springframework.data.repository.core.support.RepositoryFactorySupport;

import javax.persistence.EntityManager;
import java.io.Serializable;

/**
 * @author Created by yangyang on 2017/3/4.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class SimpleBaseRepositoryFactoryBean<R extends JpaRepository<M, ID>, M, ID extends Serializable>
        extends JpaRepositoryFactoryBean<R, M, ID> {
    /**
     * Creates a new {@link JpaRepositoryFactoryBean} for the given repository interface.
     *
     * @param repositoryInterface must not be {@literal null}.
     */
    public SimpleBaseRepositoryFactoryBean(Class<? extends R> repositoryInterface) {
        super(repositoryInterface);
    }

    protected RepositoryFactorySupport createRepositoryFactory(EntityManager entityManager) {
        return new SimpleBaseRepositoryFactory(entityManager);
    }
}
