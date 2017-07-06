package cn.arvix.ontheway.ducuments.entity;

import cn.arvix.ontheway.sys.user.entity.User;
import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.base.common.utils.HibernateValidationUtil;
import cn.arvix.base.common.utils.TimeMaker;
import com.google.common.collect.Maps;
import io.swagger.annotations.ApiModelProperty;
import org.hibernate.validator.constraints.Length;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.util.Map;

/**
 * @author Created by yangyang on 2017/3/31.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Entity
@Table(name = "agile_document")
public class Document extends BaseEntity<Long> {

    public static final String TABLE_NAME = "agile_document";

    //名称
    @Column
    @NotNull(message = "name is not null")
    @Length(min = 1, max = 255, message = "The length of the name is between {min} and {max}!")
    private String name;

    //名称
    @Column
    @NotNull(message = "newName is not null")
    @Length(min = 1, max = 255, message = "The length of the newName is between {min} and {max}!")
    private String newName;

    /**
     * 父路径
     */
    @Column
    private Long parentId;

    /**
     * 文件类型
     */
    private String fileType;

    /**
     * 文件大小 kb
     */
    private Float fileSize;

    /**
     * 文件路径
     */
    private String fileUrl;

    /**
     * 下载数量
     */
    private Integer downloadNo;

    /**
     * 描述信息
     */
    @Column(columnDefinition = "longtext")

    /**
     * @NotNull(message = "content is not null!")
     */
    private String content;

    /**
     * 图标
     */
    @Column
    private String iconCode;

    /**
     * 只有图片文件才有参数
     */
    private Integer w;

    /**
     * 只有图片文件才有参数
     */
    private Integer h;

    /**
     * 上传用户
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @ApiModelProperty(hidden = true)
    private User user;


    public String tableName() {
        return TABLE_NAME;
    }

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
        objectMap.put("newName", newName);
        objectMap.put("fileType", fileType);
        objectMap.put("fileSize", fileSize);
        objectMap.put("fileUrl", fileUrl);
        objectMap.put("iconCode", iconCode);
        objectMap.put("downloadNo", downloadNo);
        objectMap.put("parentId", parentId);
        objectMap.put("content", content);
        objectMap.put("w", w);
        objectMap.put("h", h);
        objectMap.put("creater", getCreater());
        objectMap.put("uname", user.getName());
        objectMap.put("uid", user.getId());
        objectMap.put("dateCreated", TimeMaker.toDateTimeStr(getDateCreated()));
        objectMap.put("lastUpdated", TimeMaker.toDateTimeStr(getLastUpdated()));
        return objectMap;
    }

    /**
     * checkLack
     */
    public String checkLack() {
        StringBuilder builder = HibernateValidationUtil.validateModel(this);
        return builder.toString();
    }

    public Document clone() {
        try {
            super.clone();
        } catch (CloneNotSupportedException e) {
            e.printStackTrace();
        }
        Document newDocument = new Document();
        newDocument.setName(this.getName());
        newDocument.setNewName(this.getNewName());
        newDocument.setParentId(this.getParentId());
        newDocument.setFileType(this.getFileType());
        newDocument.setFileUrl(this.getFileUrl());
        newDocument.setFileSize(this.getFileSize());
        newDocument.setDownloadNo(this.getDownloadNo());
        newDocument.setContent(this.getContent());
        newDocument.setIconCode(this.getIconCode());
        newDocument.setW(this.getW());
        newDocument.setH(this.getH());
        newDocument.setUser(this.getUser());
        return newDocument;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNewName() {
        return newName;
    }

    public void setNewName(String newName) {
        this.newName = newName;
    }

    public Long getParentId() {
        return parentId;
    }

    public void setParentId(Long parentId) {
        this.parentId = parentId;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public Float getFileSize() {
        return fileSize;
    }

    public void setFileSize(Float fileSize) {
        this.fileSize = fileSize;
    }

    public String getFileUrl() {
        return fileUrl;
    }

    public void setFileUrl(String fileUrl) {
        this.fileUrl = fileUrl;
    }

    public Integer getDownloadNo() {
        return downloadNo;
    }

    public void setDownloadNo(Integer downloadNo) {
        this.downloadNo = downloadNo;
    }

    public String getIconCode() {
        return iconCode;
    }

    public void setIconCode(String iconCode) {
        this.iconCode = iconCode;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getW() {
        return w;
    }

    public void setW(Integer w) {
        this.w = w;
    }

    public Integer getH() {
        return h;
    }

    public void setH(Integer h) {
        this.h = h;
    }
}
