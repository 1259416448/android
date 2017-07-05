package cn.arvix.ontheway.sys.dto;

import io.swagger.annotations.ApiModelProperty;

import java.util.List;

/**
 * @author Created by yangyang on 2017/4/21.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class InvitationDTO {

    @ApiModelProperty(value = "邀请人数组")
    private List<RegisterDTO> invitations;

    public List<RegisterDTO> getInvitations() {
        return invitations;
    }

    public void setInvitations(List<RegisterDTO> invitations) {
        this.invitations = invitations;
    }
}
