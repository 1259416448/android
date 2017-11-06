package cn.arvix.ontheway.business.service;

import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.ontheway.business.entity.BusinessStatistics;
import cn.arvix.ontheway.business.repository.BusinessStatisticsRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author Created by yangyang on 2017/8/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class BusinessStatisticsService extends BaseServiceImpl<BusinessStatistics, Long> {

    private BusinessStatisticsRepository getBusinessStatisticsRepository(){
        return (BusinessStatisticsRepository) baseRepository;
    }

    /**
     * 修改商家评论统计总数
     * 如果商家评论 == 0 ，不进行操作
     * @param businessId 商家ID
     * @param val 修改值
     */
    @Transactional
    public void updateCommentNum(Long businessId,int val){
        BusinessStatistics businessStatistics = getBusinessStatisticsRepository().findByBusinessId(businessId);
        if(businessStatistics != null){
            businessStatistics.setCommentNum(businessStatistics.getCommentNum() + val);
            if(businessStatistics.getCommentNum()<0){
                businessStatistics.setCommentNum(0);
            }
            super.update(businessStatistics);
        }
    }

    /**
     * 修改商家
     * @param businessId 商家ID
     * @param val 值
     */
    public void updateCollectionNum(Long businessId,int val){
        BusinessStatistics businessStatistics = getBusinessStatisticsRepository().findByBusinessId(businessId);
        if(businessStatistics != null ){
            businessStatistics.setCollectionNum(businessStatistics.getCollectionNum() + val);
            if(businessStatistics.getCollectionNum()<0){
                businessStatistics.setCollectionNum(0);
            }
            super.update(businessStatistics);
        }
    }

}
