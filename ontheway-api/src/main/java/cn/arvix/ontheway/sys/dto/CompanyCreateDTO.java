package cn.arvix.ontheway.sys.dto;

import io.swagger.annotations.ApiModelProperty;

import javax.validation.constraints.NotNull;

/**
 * @author Created by yangyang on 2017/3/30.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class CompanyCreateDTO {

//    @ApiModelProperty(value = "用户姓名")
//    @NotNull(message = "name is not null")
//    private String name;

    @ApiModelProperty(value = "公司/团队名称")
    @NotNull(message = "companyName is not null")
    private String companyName;

//    public String getName() {
//        return name;
//    }
//
//    public void setName(String name) {
//        this.name = name;
//    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }
}
