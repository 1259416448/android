package arvix.cn.ontheway.bean;

import android.location.Location;

import com.baidu.mapapi.search.core.PoiInfo;

/**
 *
 */

public class ARPoint {
    Location location;
    PoiInfo poiInfo;

    /**
     *
     * @param poiInfo
     * @param altitude
     */
    public ARPoint(PoiInfo poiInfo, double altitude) {
        location = new Location("ARPoint");
        this.poiInfo = poiInfo;
        location.setLatitude(poiInfo.location.latitude);
        location.setLongitude(poiInfo.location.longitude);
        location.setAltitude(altitude);
    }

    public Location getLocation() {
        return location;
    }



    public void setLocation(Location location) {
        this.location = location;
    }


    public PoiInfo getPoiInfo() {
        return poiInfo;
    }

    public void setPoiInfo(PoiInfo poiInfo) {
        this.poiInfo = poiInfo;
    }
}
