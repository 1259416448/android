package cn.arvix.ontheway.footprint.service;

import cn.arvix.base.common.entity.JSONResult;
import cn.arvix.base.common.entity.SystemModule;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.ontheway.ducuments.service.DocumentService;
import cn.arvix.ontheway.footprint.dto.FootprintCreateDTO;
import cn.arvix.ontheway.footprint.entity.Footprint;
import cn.arvix.ontheway.footprint.entity.Statistics;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

/**
 * @author Created by yangyang on 2017/7/26.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class FootprintService extends BaseServiceImpl<Footprint, Long> {

    private DocumentService documentService;

    @Autowired
    public void setDocumentService(DocumentService documentService) {
        this.documentService = documentService;
    }

    private StatisticsService statisticsService;

    @Autowired
    public void setStatisticsService(StatisticsService statisticsService) {
        this.statisticsService = statisticsService;
    }

    /**
     * 创建一条足迹信息
     *
     * @param dto 足迹信息
     * @return 操作结果
     */
    @Transactional(rollbackFor = Exception.class)
    public JSONResult save(FootprintCreateDTO dto) {
        Assert.notNull(dto.getFootprint(), "footprint is not null");
        Footprint m = dto.getFootprint();
        //设置当前登陆用户
        m.setUser(webContextUtils.getCheckCurrentUser());
        if (m.getBusiness() != null) {
            m.setIfBusinessComment(Boolean.TRUE);
        }
        //创建统计信息
        Statistics statistics = new Statistics();
        statistics.setSystemModule(SystemModule.footprint);
        statisticsService.save(statistics);
        m.setStatistics(statistics);
        super.save(m);
        statistics.setInstanceId(m.getId());
        //保存document信息
        if (dto.getDocuments() != null) {
            dto.getDocuments().forEach(x -> {
                x.setParentId(m.getId());
                x.setSystemModule(SystemModule.footprint);
                documentService.save_(x);
                //这里暂未增加视频处理
                if (m.getPhoto() == null) {
                    m.setPhoto(x);
                }
            });
        }
        return JsonUtil.getSuccess(CommonContact.SAVE_SUCCESS, CommonContact.SAVE_SUCCESS);
    }

}
