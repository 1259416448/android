package cn.arvix.ontheway.ducuments.dto;

/**
 * @author Created by yangyang on 2017/6/27.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class QiniuImgEditDTO {

    private Long id;

    private String newFileUrl;

    private Boolean deleteYuan = Boolean.TRUE;

    private Integer rotate;

    private Integer width;

    private Integer height;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Integer getRotate() {
        return rotate;
    }

    public void setRotate(Integer rotate) {
        this.rotate = rotate;
    }

    public String getNewFileUrl() {
        return newFileUrl;
    }

    public void setNewFileUrl(String newFileUrl) {
        this.newFileUrl = newFileUrl;
    }

    public Boolean getDeleteYuan() {
        return deleteYuan;
    }

    public void setDeleteYuan(Boolean deleteYuan) {
        this.deleteYuan = deleteYuan;
    }

    public Integer getWidth() {
        return width;
    }

    public void setWidth(Integer width) {
        this.width = width;
    }

    public Integer getHeight() {
        return height;
    }

    public void setHeight(Integer height) {
        this.height = height;
    }
}
