package cn.arvix.ontheway.footprint.dto;

import cn.arvix.ontheway.ducuments.entity.Document;
import cn.arvix.ontheway.footprint.entity.Footprint;
import io.swagger.annotations.ApiModelProperty;

import java.util.List;

/**
 * @author Created by yangyang on 2017/7/26.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class FootprintCreateDTO {

    //足迹信息
    @ApiModelProperty(value = "足迹信息")
    private Footprint footprint;

    //照片或者视频信息
    @ApiModelProperty(value = "图片或者视频信息、允许多个")
    private List<Document> documents;

    public Footprint getFootprint() {
        return footprint;
    }

    public void setFootprint(Footprint footprint) {
        this.footprint = footprint;
    }

    public List<Document> getDocuments() {
        return documents;
    }

    public void setDocuments(List<Document> documents) {
        this.documents = documents;
    }
}
