package cn.arvix.base.common.service;

import cn.arvix.base.common.entity.AbstractEntity;
import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.entity.search.Searchable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

import java.io.Serializable;
import java.util.List;

/**
 * @author Created by yangyang on 2017/3/14.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface BaseService<M extends AbstractEntity, ID extends Serializable> {

    /**
     * 保存单个实体，返回JSONResult
     * 默认调用 实体超累中的toMap方法返回对象数据
     *
     * @param m 实体
     * @return JSONResult
     */
    JSONResult save_(M m);

    /**
     * 保存单个实体
     *
     * @param m 实体
     * @return 返回保存的实体
     */
    M save(M m);

    M saveAndFlush(M m);

    /**
     * 修改单个实体 返回JSONResult
     *
     * @param m 实体
     * @return JSONResult
     */
    JSONResult update_(M m);

    /**
     * 更新单个实体
     *
     * @param m 实体
     * @return 返回更新的实体
     */
    M update(M m);

    /**
     * 根据主键删除相应实体
     *
     * @param id 主键
     */
    void delete(ID id);

    /**
     * 根据主键删除相应实体 返回JSONResult
     *
     * @param id 主键
     * @return JSONResult
     */
    JSONResult delete_(ID id);

    /**
     * 删除实体
     *
     * @param m 实体
     */
    void delete(M m);

    /**
     * 根据主键删除相应实体
     *
     * @param ids 实体
     */
    void delete(ID[] ids);

    /**
     * 根据主键删除相应实体
     *
     * @param ids 实体
     */
    JSONResult delete_(ID[] ids);

    /**
     * 按照主键查询
     *
     * @param id 主键
     * @return 返回id对应的实体
     */
    M findOne(ID id);

    /**
     * 按照主键查询 返回JSONResult
     *
     * @param id ID
     * @return JSONResult
     */
    JSONResult findOne_(ID id);

    /**
     * 实体是否存在
     *
     * @param id 主键
     * @return 存在 返回true，否则false
     */
    boolean exists(ID id);

    /**
     * 统计实体总数
     *
     * @return 实体总数
     */
    long count();

    /**
     * 查询所有实体
     */
    List<M> findAll();

    /**
     * 按照顺序查询所有实体
     *
     * @param sort 排序方式
     */
    List<M> findAll(Sort sort);

    /**
     * 分页及排序查询实体
     *
     * @param pageable 分页及排序数据
     */
    Page<M> findAll(Pageable pageable);

    /**
     * 按条件分页并排序查询实体
     *
     * @param searchable 条件
     */
    Page<M> findAll(Searchable searchable);


    /**
     * 按条件不分页不排序查询实体
     *
     * @param searchable 条件
     */
    List<M> findAllWithNoPageNoSort(Searchable searchable);

    /**
     * 按条件排序查询实体(不分页)
     *
     * @param searchable 条件
     */
    List<M> findAllWithSort(Searchable searchable);

    /**
     * 按条件分页并排序统计实体数量
     *
     * @param searchable 条件
     */
    Long count(Searchable searchable);

    Class<M> getEntityClass();

    String getEntityName();


}
