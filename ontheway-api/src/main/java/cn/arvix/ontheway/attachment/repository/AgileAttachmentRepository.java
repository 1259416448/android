package cn.arvix.ontheway.attachment.repository;

import cn.arvix.ontheway.attachment.entity.AgileAttachment;
import cn.arvix.base.common.entity.SystemModule;
import cn.arvix.base.common.repository.BaseRepository;
import org.springframework.data.jpa.repository.Modifying;

/**
 * @author Created by yangyang on 2017/4/6.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface AgileAttachmentRepository extends BaseRepository<AgileAttachment, Long> {

    @Modifying
    int deleteByAgileModuleAndInstanceId(SystemModule agileModule, Long instanceId);

}
