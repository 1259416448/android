package cn.arvix.ontheway.footprint.entity;

import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.base.common.utils.HibernateValidationUtil;

import javax.persistence.Entity;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;

/**
 * 点赞记录表
 *
 * @author Created by yangyang on 2017/7/28.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Entity
@Table(name = "otw_like_records")
public class LikeRecords extends BaseEntity<Long> {

    //点赞用户ID
    @NotNull(message = "userId is not null")
    private Long userId;

    //足迹ID
    @NotNull(message = "footprintId is not null")
    private Long footprintId;

    //足迹发布用户ID
    @NotNull(message = "footprintUserId is not null")
    private Long footprintUserId;

    /**
     * checkLack
     */
    public String checkLack() {
        StringBuilder builder = HibernateValidationUtil.validateModel(this);
        return builder.toString();
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getFootprintId() {
        return footprintId;
    }

    public void setFootprintId(Long footprintId) {
        this.footprintId = footprintId;
    }

    public Long getFootprintUserId() {
        return footprintUserId;
    }

    public void setFootprintUserId(Long footprintUserId) {
        this.footprintUserId = footprintUserId;
    }
}
