package cn.arvix.ontheway.ducuments.entity;

import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.base.common.utils.HibernateValidationUtil;
import cn.arvix.base.common.utils.TimeMaker;
import com.google.common.collect.Maps;
import io.swagger.annotations.ApiModelProperty;
import org.hibernate.annotations.Formula;
import org.hibernate.validator.constraints.Length;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.util.Map;

/**
 * @author Created by yangyang on 2017/3/31.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@Entity
@Table(name = "agile_document_dir")
public class DocumentDir extends BaseEntity<Long> {

    public static final String TABLE_NAME = "agile_document_dir";

    //名称
    @Column
    @NotNull(message = "name is not null")
    @Length(min = 1, max = 50, message = "The length of the name is between {min} and {max}!")
    private String name;

    /**
     * 父路径
     */
    @Column
    private Long parentId;

    @Column
    private String parentIds;

    /**
     * 文件夹类型
     */
    @Enumerated(EnumType.STRING)
    @NotNull(message = "documentDirType is not null")
    private DocumentDirType documentDirType;

    /**
     * 图标
     */
    @Column
    private String iconCode;

    /**
     * 是否有叶子节点
     */
    @Formula(value = "(select count(*) from agile_document_dir f_t where f_t.parent_id = id)")
    private boolean hasChildren;

    /**
     * 是拥有文件
     */
    @Formula(value = "(select count(*) from agile_document f_t where f_t.parent_id = id)")
    private boolean hasFiles;

    /**
     * 是否显示
     */
    @Column(name = "is_show")
    private Boolean show = Boolean.FALSE;

    /**
     * 文件夹大小
     */
    @Column
    private Float size;

    /**
     * 文件数量
     */
    @Column
    private Integer fileNo;

    /**
     * 是否允许创建下级节点
     */
    private Boolean ifCreate = Boolean.TRUE;

    /**
     * 是否允许删除
     */
    @Column
    private Boolean IfDelete = Boolean.TRUE;

    @ApiModelProperty(hidden = true)
    private transient Map<String, Object> objectMap;

    public Map<String, Object> getObjectMap() {
        if (objectMap == null) {
            objectMap = Maps.newHashMap();
        }
        return objectMap;
    }

    public void setObjectMap(Map<String, Object> objectMap) {
        this.objectMap = objectMap;
    }

    @Transient
    public Map<String, Object> toMap() {
        objectMap = Maps.newHashMap();
        objectMap.put("id", getId());
        objectMap.put("name", name);
        objectMap.put("iconCode", iconCode);
        objectMap.put("parentIds", parentIds);
        objectMap.put("parentId", parentId);
        objectMap.put("show", show);
        objectMap.put("IfDelete", IfDelete);
        objectMap.put("hasChildren", hasChildren);
        objectMap.put("hasFiles", hasFiles);
        objectMap.put("ifCreate", ifCreate);
        objectMap.put("creater", getCreater());
        objectMap.put("documentDirType", documentDirType);
        objectMap.put("dateCreated", TimeMaker.toDateTimeStr(getDateCreated()));
        objectMap.put("lastUpdated", TimeMaker.toDateTimeStr(getLastUpdated()));
        return objectMap;
    }


    public String tableName() {
        return TABLE_NAME;
    }

    /**
     * checkLack
     */
    public String checkLack() {
        StringBuilder builder = HibernateValidationUtil.validateModel(this);
        return builder.toString();
    }

    public String makeSelfAsNewParentIds() {
        return org.apache.commons.lang3.StringUtils.isEmpty(getParentIds())
                ? getSeparator() + getId() + getSeparator()
                : getParentIds() + getId() + getSeparator();
    }


    public String getSeparator() {
        return "/";
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Long getParentId() {
        return parentId;
    }

    public void setParentId(Long parentId) {
        this.parentId = parentId;
    }

    public String getParentIds() {
        return parentIds;
    }

    public void setParentIds(String parentIds) {
        this.parentIds = parentIds;
    }

    public String getIconCode() {
        return iconCode;
    }

    public void setIconCode(String iconCode) {
        this.iconCode = iconCode;
    }

    public boolean isHasChildren() {
        return hasChildren;
    }

    public void setHasChildren(boolean hasChildren) {
        this.hasChildren = hasChildren;
    }

    public Boolean getShow() {
        return show;
    }

    public void setShow(Boolean show) {
        this.show = show;
    }

    public Float getSize() {
        return size;
    }

    public void setSize(Float size) {
        this.size = size;
    }

    public Integer getFileNo() {
        return fileNo;
    }

    public void setFileNo(Integer fileNo) {
        this.fileNo = fileNo;
    }

    public Boolean getIfDelete() {
        return IfDelete;
    }

    public void setIfDelete(Boolean ifDelete) {
        IfDelete = ifDelete;
    }

    public DocumentDirType getDocumentDirType() {
        return documentDirType;
    }

    public void setDocumentDirType(DocumentDirType documentDirType) {
        this.documentDirType = documentDirType;
    }

    public Boolean getIfCreate() {
        return ifCreate;
    }

    public void setIfCreate(Boolean ifCreate) {
        this.ifCreate = ifCreate;
    }

    public boolean isHasFiles() {
        return hasFiles;
    }

    public void setHasFiles(boolean hasFiles) {
        this.hasFiles = hasFiles;
    }
}
