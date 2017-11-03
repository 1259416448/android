package arvix.cn.ontheway.bean;

/**
 * Created by Administrator on 2017/11/1.
 */
public class BusinessVo extends FootPrintSearchVo {
    private int number;
    private int size = 15;
    private Double latitude;
    private Double longitude;
    private Long currentTime = 0l;
    private Double distance;
    private String q;
    private String typeIds;
    private SearchType searchType;
    private SearchTime searchTime;
    private SearchDistance searchDistance;
    public int getNumber() {
        return number;
    }

    public void setNumber(int number) {
        this.number = number;
    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
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

    public String getQ() {
        return q;
    }

    public void setQ(String q) {
        this.q = q;
    }

    public String getTypeIds() {
        return typeIds;
    }

    public void setTypeIds(String typeIds) {
        this.typeIds = typeIds;
    }
    public SearchType getSearchType() {
        return searchType;
    }

    public void setSearchType(SearchType searchType) {
        this.searchType = searchType;
    }

    public SearchTime getSearchTime() {
        return searchTime;
    }

    public void setSearchTime(SearchTime searchTime) {
        this.searchTime = searchTime;
    }

    public SearchDistance getSearchDistance() {
        return searchDistance;
    }

}
