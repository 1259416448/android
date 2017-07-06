/**
 * Copyright (c) 2005-2012 https://github.com/zhangkaitao
 * <p>
 * Licensed under the Apache License, Version 2.0 (the "License");
 */
package cn.arvix.base.common.service.impl;

import cn.arvix.ontheway.sys.utils.WebContextUtils;
import cn.arvix.base.common.entity.AbstractEntity;
import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.entity.search.exception.SearchException;
import cn.arvix.base.common.repository.BaseRepository;
import cn.arvix.base.common.service.BaseService;
import cn.arvix.base.common.service.exception.DataCheckException;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.base.common.utils.MessageUtils;
import cn.arvix.base.common.utils.TimeMaker;
import com.google.common.collect.Lists;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

import java.io.Serializable;
import java.util.List;

/**
 * 抽象service层基类 提供一些简便方法
 * 泛型 ： M 表示实体类型；ID表示主键类型
 */
public abstract class BaseServiceImpl<M extends AbstractEntity, ID extends Serializable> implements BaseService<M, ID> {

    protected BaseRepository<M, ID> baseRepository;

    protected WebContextUtils webContextUtils;

    @Autowired
    public void setWebContextUtils(WebContextUtils webContextUtils) {
        this.webContextUtils = webContextUtils;
    }

    @Autowired
    public void setBaseRepository(BaseRepository<M, ID> baseRepository) {
        this.baseRepository = baseRepository;
    }

    /**
     * 保存单个实体，返回JSONResult
     * 默认调用 实体超类中的toMap方法返回对象数据
     *
     * @param m 实体
     * @return JSONResult
     */
    public JSONResult save_(M m) {
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.SAVE_SUCCESS),
                CommonContact.SAVE_SUCCESS, this.save(m).toMap());
    }

    /**
     * 保存单个实体
     *
     * @param m 实体
     * @return 返回保存的实体
     */
    public M save(M m) {
        //获取当前登陆用户，并设置创建人
        if (StringUtils.isEmpty(m.getCreater())) {
            //获取当前登陆用户
            String username = webContextUtils.getCurrentPrincipal();
            if (StringUtils.isEmpty(username)) username = "???";
            m.setCreater(username);
        }
        m.setDateCreated(TimeMaker.nowSqlDate());
        //检验数据完整性
        String msg = m.checkLack();
        if (!StringUtils.isEmpty(msg)) throw new DataCheckException(msg);
        return baseRepository.save(m);
    }

    public M saveAndFlush(M m) {
        m = this.save(m);
        baseRepository.flush();
        return m;
    }

    /**
     * 修改单个实体 返回JSONResult
     *
     * @param m 实体
     * @return JSONResult
     */
    public JSONResult update_(M m) {
        M res = this.update(m);
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.UPDATE_SUCCESS),
                CommonContact.UPDATE_SUCCESS, res.toMap());
    }

    /**
     * 更新单个实体
     *
     * @param m 实体
     * @return 返回更新的实体
     */
    public M update(M m) {
        String msg = m.checkLack();
        if (!StringUtils.isEmpty(msg)) throw new DataCheckException(msg);
        m.setLastUpdated(TimeMaker.nowSqlDate());
        return baseRepository.save(m);
    }

    /**
     * 根据主键删除相应实体
     *
     * @param id 主键
     */
    public void delete(ID id) {
        baseRepository.delete(id);
    }

    /**
     * 根据主键删除相应实体 返回JSONResult
     *
     * @param id 主键
     * @return JSONResult
     */
    public JSONResult delete_(ID id) {
        this.delete(id);
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.DELETE_SUCCESS),
                CommonContact.DELETE_SUCCESS, id);
    }


    /**
     * 删除实体
     *
     * @param m 实体
     */
    public void delete(M m) {
        baseRepository.delete(m);
    }

    /**
     * 根据主键删除相应实体
     *
     * @param ids 实体
     */
    public void delete(ID[] ids) {
        baseRepository.delete(ids);
    }

    /**
     * 根据主键删除相应实体
     *
     * @param ids 实体
     */
    public JSONResult delete_(ID[] ids) {
        baseRepository.delete(ids);
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.DELETE_MORE_SUCCESS),
                CommonContact.DELETE_MORE_SUCCESS, ids);
    }

    /**
     * 按照主键查询
     * 如果查询不存在，抛出 SearchException 异常
     *
     * @param id 主键
     * @return 返回id对应的实体
     */
    public M findOne(ID id) {
        M m = baseRepository.findOne(id);
        if (m == null) throw new SearchException(CommonContact.NOT_FUND);
        return m;
    }

    /**
     * 按照主键查询 返回JSONResult
     *
     * @param id ID
     * @return JSONResult
     */
    public JSONResult findOne_(ID id) {
        return JsonUtil.getSuccess(MessageUtils.message(CommonContact.FETCH_SUCCESS),
                CommonContact.FETCH_SUCCESS, findOne(id).toMap());
    }

    /**
     * 实体是否存在
     *
     * @param id 主键
     * @return 存在 返回true，否则false
     */
    public boolean exists(ID id) {
        return baseRepository.exists(id);
    }

    /**
     * 统计实体总数
     *
     * @return 实体总数
     */
    public long count() {
        return baseRepository.count();
    }

    /**
     * 查询所有实体
     *
     * @return
     */
    public List<M> findAll() {
        return baseRepository.findAll();
    }

    /**
     * 按照顺序查询所有实体
     *
     * @param sort
     * @return
     */
    public List<M> findAll(Sort sort) {
        return baseRepository.findAll(sort);
    }

    /**
     * 分页及排序查询实体
     *
     * @param pageable 分页及排序数据
     * @return
     */
    public Page<M> findAll(Pageable pageable) {
        return baseRepository.findAll(pageable);
    }

    /**
     * 按条件分页并排序查询实体
     *
     * @param searchable 条件
     * @return
     */
    public Page<M> findAll(Searchable searchable) {
        return baseRepository.findAll(searchable);
    }

    /**
     * 按条件不分页不排序查询实体
     *
     * @param searchable 条件
     * @return
     */
    public List<M> findAllWithNoPageNoSort(Searchable searchable) {
        searchable.removePageable();
        searchable.removeSort();
        return Lists.newArrayList(baseRepository.findAll(searchable).getContent());
    }

    /**
     * 按条件排序查询实体(不分页)
     *
     * @param searchable 条件
     * @return
     */
    public List<M> findAllWithSort(Searchable searchable) {
        searchable.removePageable();
        return Lists.newArrayList(baseRepository.findAll(searchable).getContent());
    }


    /**
     * 按条件分页并排序统计实体数量
     *
     * @param searchable 条件
     * @return
     */
    public Long count(Searchable searchable) {
        return baseRepository.count(searchable);
    }

    public Class<M> getEntityClass() {
        return baseRepository.getEntityClass();
    }

    public String getEntityName() {
        return baseRepository.getEntityName();
    }
}
