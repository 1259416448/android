package cn.arvix.ontheway.message.entity;

import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.base.common.utils.TimeMaker;
import com.google.common.collect.Maps;
import io.swagger.annotations.ApiModelProperty;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.validation.constraints.NotNull;
import java.util.Map;

/**
 * @author Created by yangyang on 2017/10/25.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@Entity
@Table(name = "otw_feedback")
public class Feedback extends BaseEntity<Long> {

    @Column(columnDefinition = "text")
    @NotNull(message = "content is not null")
    private String content;

    private String contactInfo;

    @ApiModelProperty(hidden = true)
    private Long userId; //提交用户

    @Transient
    public Map<String, Object> toMap() {
        Map<String, Object> objectMap = Maps.newHashMap();
        objectMap.put("id", getId());
        objectMap.put("title", contactInfo);
        objectMap.put("userId", userId);
        objectMap.put("content", content);
        objectMap.put("dateCreated", TimeMaker.toTimeMillis(getDateCreated()));
        objectMap.put("dateCreatedFormat", TimeMaker.toDateTimeStr(getDateCreated()));
        objectMap.put("dateCreatedStr", TimeMaker.dateCreatedStr(TimeMaker.toTimeMillis(getDateCreated())));
        return objectMap;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getContactInfo() {
        return contactInfo;
    }

    public void setContactInfo(String contactInfo) {
        this.contactInfo = contactInfo;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }
}
