package cn.arvix.base.common.entity;


import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.MappedSuperclass;
import java.io.Serializable;

/**
 * mysql id 自动生成 基础entity类 提供
 *
 * @author Created by yangyang on 2017/3/1.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@MappedSuperclass
public abstract class BaseEntity<ID extends Serializable> extends AbstractEntity<ID> {

    @Id
    @GeneratedValue
    //@GenericGenerator(name = "generator", strategy = "uuid")
    //@GeneratedValue(generator = "generator")
    private ID id;

    @Override
    public ID getId() {
        return id;
    }


    @Override
    public void setId(ID id) {
        this.id = id;
    }

}
