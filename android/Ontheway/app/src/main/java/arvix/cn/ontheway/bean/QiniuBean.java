package arvix.cn.ontheway.bean;

/**
 * Created by asdtiang on 2017/8/4 0004.
 * asdtiangxia@163.com
 */

public class QiniuBean {
    /**
     * 文件类型
     */
    private String fileType;

    /**
     * 文件大小 kb
     */
    private Long fileSize;

    /**
     * 文件路径
     */
    private String fileUrl;

    private Long id;
    private String name;


    /**
     * 只有图片文件才有参数
     */
    private Integer w;

    /**
     * 只有图片文件才有参数
     */
    private Integer h;

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public Long getFileSize() {
        return fileSize;
    }

    public void setFileSize(Long fileSize) {
        this.fileSize = fileSize;
    }

    public String getFileUrl() {
        return fileUrl;
    }

    public void setFileUrl(String fileUrl) {
        this.fileUrl = fileUrl;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getW() {
        return w;
    }

    public void setW(Integer w) {
        this.w = w;
    }

    public Integer getH() {
        return h;
    }

    public void setH(Integer h) {
        this.h = h;
    }
}
