package cn.arvix.base.common.entity;

import com.google.common.collect.Lists;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;

import java.util.List;

/**
 * Company ：FsPhoto
 * 分页数据载体
 *
 * @author Created by yangyang on 16/7/24.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@SuppressWarnings("unchecked")
public class PageResult<M> extends PageImpl<M> {


    private final List<?> content;

    private static final List ms = Lists.newArrayList();

    //分页时间，为了防止增加数据后，数据重复
    private Long currentTime;

    /**
     * Constructor of {@code PageImpl}.
     *
     * @param content  the content of this page, must not be {@literal null}.
     * @param pageable the paging information, can be {@literal null}.
     * @param total    the total amount of items available. The total might be adapted considering the length of the content
     */
    public PageResult(List content, Pageable pageable, long total) {
        super(ms, pageable, total);
        this.content = content;
    }

    /**
     * Creates a new {@link PageImpl} with the given content. This will result in the created {@link Page} being identical
     * to the entire {@link List}.
     *
     * @param content must not be {@literal null}.
     */
    public PageResult(List content) {
        super(ms);
        this.content = content;
    }

    @Override
    public List getContent() {
        if(content==null) return ms;
        return content;
    }

    public Long getCurrentTime() {
        return currentTime;
    }

    public void setCurrentTime(Long currentTime) {
        this.currentTime = currentTime;
    }
}
