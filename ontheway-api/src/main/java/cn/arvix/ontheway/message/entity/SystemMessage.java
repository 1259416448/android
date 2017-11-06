package cn.arvix.ontheway.message.entity;

import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.base.common.utils.HibernateValidationUtil;
import cn.arvix.base.common.utils.TimeMaker;
import com.google.common.collect.Maps;

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
@Table(name = "otw_system_message")
public class SystemMessage extends BaseEntity<Long> {


    @NotNull(message = "title is not null")
    private String title;

    @Column(columnDefinition = "text")
    @NotNull(message = "content is not null")
    private String content;

    @Transient
    public Map<String, Object> toMap() {
        Map<String, Object> objectMap = Maps.newHashMap();
        objectMap.put("id", getId());
        objectMap.put("dataId", getId());
        objectMap.put("title", title);
        objectMap.put("content", content);
        objectMap.put("dateCreated", TimeMaker.toTimeMillis(getDateCreated()));
        objectMap.put("dateCreatedFormat", TimeMaker.toDateTimeStr(getDateCreated()));
        objectMap.put("dateCreatedStr", TimeMaker.dateCreatedStr(TimeMaker.toTimeMillis(getDateCreated())));
        return objectMap;
    }

    /**
     * checkLack
     */
    @Override
    public String checkLack() {
        StringBuilder builder = HibernateValidationUtil.validateModel(this);
        return builder.toString();
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
