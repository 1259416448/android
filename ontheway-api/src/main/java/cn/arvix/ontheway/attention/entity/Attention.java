package cn.arvix.ontheway.attention.entity;

import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.ontheway.sys.user.entity.User;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

/**
 * @author Created by yangyang on 2017/10/25.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Entity
@Table(name = "otw_attention")
public class Attention extends BaseEntity<Long> {

    //用户ID
    @ManyToOne(fetch = FetchType.LAZY)
    private User user;

    //关注用户ID
    @ManyToOne(fetch = FetchType.LAZY)
    private User attentionUser;

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public User getAttentionUser() {
        return attentionUser;
    }

    public void setAttentionUser(User attentionUser) {
        this.attentionUser = attentionUser;
    }
}
