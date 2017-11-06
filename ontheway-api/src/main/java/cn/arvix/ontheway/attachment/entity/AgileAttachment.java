package cn.arvix.ontheway.attachment.entity;

import cn.arvix.ontheway.ducuments.entity.Document;
import cn.arvix.base.common.entity.SystemModule;
import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.base.common.utils.HibernateValidationUtil;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

/**
 * @author Created by yangyang on 2017/4/6.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@Entity
@Table(name = "agile_attachment")
public class AgileAttachment extends BaseEntity<Long> {


    public static final String TABLE_NAME = "agile_attachment";

    /**
     * 附件类型
     */
    @NotNull(message = "attachmentType is not null")
    @Enumerated(EnumType.STRING)
    private SystemModule agileModule;

    /**
     * 文件
     */
    @ManyToOne
    @NotNull(message = "document is not null")
    private Document document;

    /**
     * 实例Id
     */
    @NotNull(message = "instanceId is not null")
    private Long instanceId;

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


    public SystemModule getAgileModule() {
        return agileModule;
    }

    public void setAgileModule(SystemModule agileModule) {
        this.agileModule = agileModule;
    }

    public Document getDocument() {
        return document;
    }

    public void setDocument(Document document) {
        this.document = document;
    }

    public Long getInstanceId() {
        return instanceId;
    }

    public void setInstanceId(Long instanceId) {
        this.instanceId = instanceId;
    }
}
