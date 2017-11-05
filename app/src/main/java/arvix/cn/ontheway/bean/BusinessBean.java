package arvix.cn.ontheway.bean;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * Created by Administrator on 2017/11/4.
 */
public class BusinessBean implements Parcelable {


    /**
     * address : 北京市西城区
     * businessId : 506
     * colorCode : E52C2C
     * contactInfo :
     * distance : 5.8866534
     * latitude : 39.957730095053
     * longitude : 116.38923904163
     * name : 天宝丰源包子
     */

    private String address;
    private int businessId;
    private String colorCode;
    private String contactInfo;
    private double distance;
    private double latitude;
    private double longitude;
    private String name;

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getBusinessId() {
        return businessId;
    }

    public void setBusinessId(int businessId) {
        this.businessId = businessId;
    }

    public String getColorCode() {
        return colorCode;
    }

    public void setColorCode(String colorCode) {
        this.colorCode = colorCode;
    }

    public String getContactInfo() {
        return contactInfo;
    }

    public void setContactInfo(String contactInfo) {
        this.contactInfo = contactInfo;
    }

    public double getDistance() {
        return distance;
    }

    public void setDistance(double distance) {
        this.distance = distance;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.address);
        dest.writeInt(this.businessId);
        dest.writeString(this.colorCode);
        dest.writeString(this.contactInfo);
        dest.writeDouble(this.distance);
        dest.writeDouble(this.latitude);
        dest.writeDouble(this.longitude);
        dest.writeString(this.name);
    }

    public BusinessBean() {
    }

    protected BusinessBean(Parcel in) {
        this.address = in.readString();
        this.businessId = in.readInt();
        this.colorCode = in.readString();
        this.contactInfo = in.readString();
        this.distance = in.readDouble();
        this.latitude = in.readDouble();
        this.longitude = in.readDouble();
        this.name = in.readString();
    }

    public static final Parcelable.Creator<BusinessBean> CREATOR = new Parcelable.Creator<BusinessBean>() {
        @Override
        public BusinessBean createFromParcel(Parcel source) {
            return new BusinessBean(source);
        }

        @Override
        public BusinessBean[] newArray(int size) {
            return new BusinessBean[size];
        }
    };
}
