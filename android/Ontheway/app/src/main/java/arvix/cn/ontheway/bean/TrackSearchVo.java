package arvix.cn.ontheway.bean;

/**
 * Created by asdtiang on 2017/8/9 0009.
 * asdtiangxia@163.com
 */

public class TrackSearchVo {

    private Integer number;
    private Integer size;
    private Double latitude;
    private Double longitude;
    private Long currentTime;
    private Double distance;


    //检索的几种类型
    public enum SearchType {
        ar, list, map
    }

    //时间筛选 1天内 7天内 1月内
    public enum SearchTime {
        oneDay, sevenDay, oneMonth
    }

    //范围筛选 100m 500m 1km
    public enum SearchDistance {
        one, two, three
    }

    public Integer getNumber() {
        return number;
    }

    public void setNumber(Integer number) {
        this.number = number;
    }

    public Integer getSize() {
        return size;
    }

    public void setSize(Integer size) {
        this.size = size;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public Long getCurrentTime() {
        return currentTime;
    }

    public void setCurrentTime(Long currentTime) {
        this.currentTime = currentTime;
    }

    public Double getDistance() {
        return distance;
    }

    public void setDistance(Double distance) {
        this.distance = distance;
    }
}
