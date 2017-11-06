package cn.arvix.ontheway.sys.user.service;

import cn.arvix.ontheway.sys.user.entity.UserOrganizationRecords;
import cn.arvix.ontheway.sys.user.repository.UserOrganizationRecordsRepository;
import cn.arvix.base.common.service.impl.BaseServiceImpl;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author Created by yangyang on 2017/6/5.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service
public class UserOrganizationRecordsService extends BaseServiceImpl<UserOrganizationRecords, Long> {

    private UserOrganizationRecordsRepository getUserOrganizationRecordsRepository() {
        return (UserOrganizationRecordsRepository) baseRepository;
    }

    /**
     * 添加的时候需要判断一下，不要能重复
     *
     * @return 已经存在返回true 不存在返回false
     */
    public boolean create(UserOrganizationRecords m) {
        UserOrganizationRecords userOrganizationRecords = getUserOrganizationRecordsRepository()
                .findByUserIdAndOrganizationId(m.getUser().getId(), m.getOrganization().getId());
        if (userOrganizationRecords == null) {
            super.save(m);
        } else {
            return true;
        }
        return false;
    }

    /**
     * 删除一个关系记录
     *
     * @param uid 用户ID
     * @param oid teamId
     */
    public void delete(Long uid, Long oid) {
        UserOrganizationRecords userOrganizationRecords = getUserOrganizationRecordsRepository()
                .findByUserIdAndOrganizationId(uid, oid);
        if (userOrganizationRecords != null) {
            super.delete(userOrganizationRecords);
        } else {
            //听说这样写CPU执行会快一些
        }
    }

    /**
     * 获取当前用户的所有saas team记录
     *
     * @param uid 用户ID
     * @return 所有记录
     */
    public List<UserOrganizationRecords> getByUid(Long uid) {
        return getUserOrganizationRecordsRepository().findByUserId(uid);
    }

}
