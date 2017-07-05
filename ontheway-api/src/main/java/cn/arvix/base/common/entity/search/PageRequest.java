package cn.arvix.base.common.entity.search;

import org.springframework.data.domain.Sort;

/**
 * @author Created by yangyang on 2017/3/16.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class PageRequest extends org.springframework.data.domain.PageRequest implements Pageable {

    /**
     * 把使用对象的toMap方法转换
     */
    private boolean enableToMap = false;

    /**
     * Creates a new {@link PageRequest}. Pages are zero indexed, thus providing 0 for {@code page} will return the first
     * page.
     *
     * @param page zero-based page index.
     * @param size the size of the page to be returned.
     */
    public PageRequest(int page, int size) {
        super(page, size);
    }

    /**
     * Creates a new {@link PageRequest} with sort parameters applied.
     *
     * @param page       zero-based page index.
     * @param size       the size of the page to be returned.
     * @param direction  the direction of the {@link Sort} to be specified, can be {@literal null}.
     * @param properties the properties to sort by, must not be {@literal null} or empty.
     */
    public PageRequest(int page, int size, Sort.Direction direction, String... properties) {
        super(page, size, direction, properties);
    }

    /**
     * Creates a new {@link PageRequest} with sort parameters applied.
     *
     * @param page zero-based page index.
     * @param size the size of the page to be returned.
     * @param sort can be {@literal null}.
     */
    public PageRequest(int page, int size, Sort sort) {
        super(page, size, sort);
    }

    @Override
    public boolean getEnableToMap() {
        return this.enableToMap;
    }

    @Override
    public PageRequest setEnableToMap(Boolean enableToMap) {
        this.enableToMap = enableToMap;
        return this;
    }
}
