package cn.arvix.ontheway.sys.dto;

import io.swagger.annotations.ApiModelProperty;

/**
 * 用于激活操作的DTO
 *
 * @author Created by yangyang on 2017/3/28.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class ActivationDTO {

    //激活标示，由服务端生成，保存在redis中
    @ApiModelProperty(value = "激活标示")
    private String mark;

    //激活标示，由服务端生成，保存在redis中，短信激活需要附带当前参数
    @ApiModelProperty(value = "短信激活验证码")
    private String code;

    public String getMark() {
        return mark;
    }

    public void setMark(String mark) {
        this.mark = mark;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }
}
