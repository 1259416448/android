package cn.arvix.ontheway.business.service;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.CommonErrorCode;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.ontheway.business.entity.BusinessType;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * @author Created by yangyang on 2017/8/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class BusinessTypeService extends BaseServiceImpl<BusinessType, Long> {

    private static final String DEFAULT_COLOR_CODE = "7335E9";

    private BusinessTypeContactService businessTypeContactService;

    @Autowired
    public void setBusinessTypeContactService(BusinessTypeContactService businessTypeContactService) {
        this.businessTypeContactService = businessTypeContactService;
    }

    /**
     * 创建类型
     *
     * @param m 类型
     * @return 创建结果
     */
    public JSONResult save_(BusinessType m) {
        //如果父级不为空，需要判断一下父级是否存在
        if (m.getParentId() != null) {
            BusinessType parent = super.findOneWithNoCheck(m.getParentId());
            if (parent == null) {
                return JsonUtil.getFailure("parent not found", CommonErrorCode.BUSINESS_TYPE_PARENT_MISS);
            }
        }
        return super.save_(m);
    }

    /**
     * 修改类型
     * 这里只允许修改名称，图片，是否置顶，权重，app是否可见
     * <p>
     * parentId修改 只允许当前类型不存在Business关联时，才能修改
     *
     * @param m 实体
     * @return 修改结果
     */
    public JSONResult update_(BusinessType m) {
        BusinessType dbEntity = super.findOne(m.getId());
        //改变了 parentId 需要检查是否使用过
        if (!Objects.equals(m.getParentId(), dbEntity.getParentId())) {
            if (businessTypeContactService.checkBusinessTypeUsed(dbEntity.getId())) {
                return JsonUtil.getFailure("Business not allow change parentId", CommonErrorCode.BUSINESS_TYPE_NOT_ALLOW_UPDATE_PARENT_ID);
            }
        }
        dbEntity.setName(m.getName());
        dbEntity.setIconStr(m.getIconStr());
        dbEntity.setIconStrAndroid(m.getIconStrAndroid());
        dbEntity.setIfTop(m.getIfTop());
        dbEntity.setWeight(m.getWeight());
        dbEntity.setParentId(m.getParentId());
        dbEntity.setIfShow(m.getIfShow());
        dbEntity.setColorCode(m.getColorCode());
        super.update(dbEntity);
        return JsonUtil.getSuccess(CommonContact.UPDATE_SUCCESS, CommonContact.UPDATE_SUCCESS, dbEntity.toMap());
    }

    /**
     * 删除类型，不允许删除使用过类型，不允许删除有下级的类型
     *
     * @param id 主键
     * @return 删除结果
     */
    public JSONResult delete_(Long id) {
        BusinessType dbEntity = super.findOne(id);
        if (dbEntity.getHasChildren()) {
            return JsonUtil.getFailure("当前类型包含子类型，不允许删除", CommonErrorCode.BUSINESS_TYPE_HAS_CHILDREN);
        }
        //判断是否可删除
        if (businessTypeContactService.checkBusinessTypeUsed(dbEntity.getId())) {
            return JsonUtil.getFailure("Business not allow change parentId", CommonErrorCode.BUSINESS_TYPE_NOT_ALLOW_UPDATE_PARENT_ID);
        }
        super.delete(dbEntity);
        return JsonUtil.getSuccess(CommonContact.DELETE_SUCCESS, CommonContact.DELETE_SUCCESS, dbEntity.getId());
    }

    /**
     * 获取所有类型（不包含前端ifShow = false的数据）
     *
     * @return 所有可见类型数据
     */
    public JSONResult all() {
        Map<String, Object> params = Maps.newHashMap();
        params.put("ifShow_eq", Boolean.TRUE);
        Searchable searchable = Searchable.newSearchable(params, new Sort(Sort.Direction.DESC, "weight"));
        List<BusinessType> businessTypeList = super.findAllWithSort(searchable);

        //构建前端数据，分组构建
        List<BusinessType> topBusinessTypeList = businessTypeList.stream()
                .filter(x -> x.getParentId() == null).collect(Collectors.toList());
        List<Map<String, Object>> jsonList = Lists.newArrayListWithCapacity(topBusinessTypeList.size());
        if (topBusinessTypeList.size() > 0) {
            topBusinessTypeList.forEach(x -> {
                List<BusinessType> childrenBusinessTypeList = businessTypeList.stream()
                        .filter(c -> Objects.equals(x.getId(), c.getParentId())).collect(Collectors.toList());
                Map<String, Object> jsonMap = x.toMap();
                List<Map<String, Object>> childrenJsonList = JsonUtil.getBaseEntityMapList(childrenBusinessTypeList);
                jsonMap.put("children", childrenJsonList);
                jsonList.add(jsonMap);
            });
        }
        return JsonUtil.getSuccess(CommonContact.FETCH_SUCCESS, CommonContact.FETCH_SUCCESS, jsonList);
    }

    /**
     * 通过类型Ids 获取颜色代码
     *
     * @param ids 商家所属类型 ids
     * @return default colorCode 7335E9
     */
    public String getColorCodeByTypeIds(Set<Long> ids) {
        Map<String, Object> params = Maps.newHashMap();
        params.put("id_in", ids);
        //颜色代码只能添加到二级类型中
        params.put("parentId_isNotNull", "");
        List<BusinessType> businessTypeList = super.findAllWithNoPageNoSort(Searchable.newSearchable(params));
        String colorCode = null;
        if (businessTypeList.size() > 0) {
            colorCode = businessTypeList.get(0).getColorCode();
        }
        if (StringUtils.isEmpty(colorCode)) {
            colorCode = DEFAULT_COLOR_CODE;
        }
        return colorCode;
    }

    /**
     * 根据获取类型ID获取类型名称
     *
     * @return 类型名称数组
     */
    public List<String> findTypeByTypeIds(Set<Long> ids) {
        Map<String, Object> params = Maps.newHashMap();
        params.put("id_in", ids);
        List<BusinessType> businessTypeList = super.findAllWithNoPageNoSort(Searchable.newSearchable(params));
        if(businessTypeList.size()>0){
            List<String> array = Lists.newArrayListWithCapacity(businessTypeList.size());
            businessTypeList.forEach(x->array.add(x.getName()));
            return array;
        }
        return null;
    }
}
