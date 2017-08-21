package cn.arvix.ontheway.business.dto;

import cn.arvix.ontheway.business.entity.Business;
import cn.arvix.ontheway.ducuments.entity.Document;

/**
 * @author Created by yangyang on 2017/8/16.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class CreateAndClaimDTO {

    //商家信息以及认领信息
    private Business business;

    //身份认证正面照片
    private Document certificatePhoto;

    //商家营业执照
    private Document businessLicensePhoto;

    public Business getBusiness() {
        return business;
    }

    public void setBusiness(Business business) {
        this.business = business;
    }

    public Document getCertificatePhoto() {
        return certificatePhoto;
    }

    public void setCertificatePhoto(Document certificatePhoto) {
        this.certificatePhoto = certificatePhoto;
    }

    public Document getBusinessLicensePhoto() {
        return businessLicensePhoto;
    }

    public void setBusinessLicensePhoto(Document businessLicensePhoto) {
        this.businessLicensePhoto = businessLicensePhoto;
    }
}
