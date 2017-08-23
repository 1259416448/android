package cn.arvix.ontheway.business.entity;

import cn.arvix.base.common.entity.BaseEntity;
import org.hibernate.annotations.Formula;

import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * @author Created by yangyang on 2017/8/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Table(name = "otw_business_statistics")
@Entity
public class BusinessStatistics extends BaseEntity<Long> {

    //商家ID
    private Long businessId;

    //总收藏数
    private Integer collectionNum = 0;

    //总评论数
    private Integer commentNum = 0;

    //商家上传的照片总数
    private Integer businessPhotoNum = 0;

    //用户上传的照片总数 , 这里直接获取用户评论的当前商家图片总数
    @Formula(value = "( select count(*) from agile_document agiled " +
            "where agiled.system_module = 'business' " +
            "and  exists ( select 1 from otw_footprint otwf " +
            "where otwf.if_business_comment = 1 " +
            "and otwf.business = business_id " +
            "and otwf.id = agiled.parent_id ) )")
    private Integer userPhotoNum;

    public static BusinessStatistics getInstance() {
        return new BusinessStatistics();
    }

    public Long getBusinessId() {
        return businessId;
    }

    public void setBusinessId(Long businessId) {
        this.businessId = businessId;
    }

    public Integer getCollectionNum() {
        return collectionNum;
    }

    public void setCollectionNum(Integer collectionNum) {
        this.collectionNum = collectionNum;
    }

    public Integer getCommentNum() {
        return commentNum;
    }

    public void setCommentNum(Integer commentNum) {
        this.commentNum = commentNum;
    }

    public Integer getBusinessPhotoNum() {
        return businessPhotoNum;
    }

    public void setBusinessPhotoNum(Integer businessPhotoNum) {
        this.businessPhotoNum = businessPhotoNum;
    }

    public Integer getUserPhotoNum() {
        return userPhotoNum;
    }

    public void setUserPhotoNum(Integer userPhotoNum) {
        this.userPhotoNum = userPhotoNum;
    }
}
