package arvix.cn.ontheway.bean;

/**
 * Created by asdtiang on 2017/8/9 0009.
 * asdtiangxia@163.com
 */

public class FootPrintSearchVo {
    private int size = 15;
    private int number = 0;
    private int totalPages = 0;
    private Double latitude;
    private Double longitude;
    private Long currentTime = 0l;
    private Double distance;
    private SearchType searchType;
    private SearchTime searchTime;
    private SearchDistance searchDistance;
    private String q;
    private String typeIds;


//    //检索的几种类型
//    public enum SearchType {
//        ar, list, map
//    }
//
//    //时间筛选 1天内 7天内 1月内
//    public enum SearchTime {
//        oneDay, sevenDay, oneMonth
//    }
//
//    //范围筛选 100m 500m 1km
//    public enum SearchDistance {
//        one, two, three
//    }

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

    public int getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(int totalPages) {
        this.totalPages = totalPages;
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

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }

    public int getNumber() {
        return number;
    }

    public void setNumber(int number) {
        this.number = number;
    }

    public void setSearchDistance(SearchDistance searchDistance) {
        this.searchDistance = searchDistance;
    }

    public void setDistance(Double distance) {
        this.distance = distance;
    }

}
