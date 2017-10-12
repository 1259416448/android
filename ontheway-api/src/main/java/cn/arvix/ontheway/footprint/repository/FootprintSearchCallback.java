package cn.arvix.ontheway.footprint.repository;

import cn.arvix.base.common.entity.search.Searchable;
import cn.arvix.base.common.repository.callback.DefaultSearchCallback;
import cn.arvix.ontheway.footprint.service.FootprintService;

import javax.persistence.Query;

/**
 * @author Created by yangyang on 2017/7/28.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class FootprintSearchCallback extends DefaultSearchCallback {

    public FootprintSearchCallback() {
        super("x");
    }

    //对于足迹的内容检索，都需要自定义查询
    @Override
    public void prepareQL(StringBuilder ql, Searchable search) {
        super.prepareQL(ql, search);
        boolean ifSearchType = search.containsSearchKey("searchType");
        if (ifSearchType) {
            FootprintService.SearchType searchType = search.getValue("searchType");
            //构建list页面的查询数据
            Double latitude = search.getValue("latitude");
            Double longitude = search.getValue("longitude");
            if (FootprintService.SearchType.list.equals(searchType)) {
                if (ql.toString().startsWith("from ")) {
                    StringBuilder select = new StringBuilder();
                    select.append("select new cn.arvix.ontheway.footprint.entity.Footprint ( "
                            + " x.id as id ,"
                            + " x.content as content ,"
                            + " ( select d.fileUrl from Document d where d.id = x.photo.id ) as footprintPhoto ,"
                            + " x.user.id as userId ,"
                            + " x.address as address ,"
                            + " x.latitude as latitude ,"
                            + " x.longitude as longitude ,"
                            + " x.type as type ,"
                            + " x.ifBusinessComment as ifBusinessComment ,"
                            + " x.business as business ,"
                            //+ " (ROUND( 6378.138 * 2 * ASIN( SQRT( POW( SIN( ( ").append(latitude).append(" * PI() / 180 - x.latitude * PI() / 180 ) / 2 ), 2 ) + COS( ").append(latitude).append(" * PI() / 180) * COS(x.latitude * PI() / 180) * POW( SIN( ( ").append(longitude).append(" * PI() / 180 - x.longitude * PI() / 180 ) / 2 ), 2 ) ) ) ,3)) as distance ,")
                            + " 0.0 as instance ,")
                            .append(" x.dateCreated as dateCreated ) ");
                    ql.insert(0, select);
                    Double distance = search.getValue("distance");
                    ql.append(" and (ROUND( 6378.138 * 2 * ASIN( SQRT( POW( SIN( ( ").append(latitude).append(" * PI() / 180 - x.latitude * PI() / 180 ) / 2 ), 2 ) + COS( ").append(latitude).append(" * PI() / 180) * COS(x.latitude * PI() / 180) * POW( SIN( ( ").append(longitude).append(" * PI() / 180 - x.longitude * PI() / 180 ) / 2 ), 2 ) ) ) ,3)) < ").append(distance);
                    ql.append(" order by dateCreated DESC ");
                }
            } else if (FootprintService.SearchType.map.equals(searchType)) {
                if (ql.toString().startsWith("from ")) {
                    StringBuilder select = new StringBuilder();
                    select.append("select new cn.arvix.ontheway.footprint.entity.Footprint( "
                            + " x.id as id ,"
                            + " x.content as content ,"
                            + " x.user.id as userId ,"
                            + " x.address as address ,"
                            + " x.latitude as latitude ,"
                            + " x.longitude as longitude ,")
                            .append(" x.dateCreated as dateCreated ) ");
                    ql.insert(0, select);
                }
                Double distance = search.getValue("distance");
                ql.append(" and (ROUND( 6378.138 * 2 * ASIN( SQRT( POW( SIN( ( ").append(latitude).append(" * PI() / 180 - x.latitude * PI() / 180 ) / 2 ), 2 ) + COS( ").append(latitude).append(" * PI() / 180) * COS(x.latitude * PI() / 180) * POW( SIN( ( ").append(longitude).append(" * PI() / 180 - x.longitude * PI() / 180 ) / 2 ), 2 ) ) ) ,3)) < ").append(distance);
            } else if (FootprintService.SearchType.ar.equals(searchType)) {
                if (ql.toString().startsWith("from ")) {
                    StringBuilder select = new StringBuilder();
                    select.append("select new cn.arvix.ontheway.footprint.entity.Footprint( "
                            + " x.id as id ,"
                            + " x.content as content ,"
                            + " ( select d.fileUrl from Document d where d.id = x.photo.id ) as footprintPhoto ,"
                            + " x.user.id as userId ,"
                            + " x.address as address ,"
                            + " x.latitude as latitude ,"
                            + " x.longitude as longitude ,"
                            + " x.type as type ,"
                            + " x.ifBusinessComment as ifBusinessComment ,"
                            + " x.business as business ,"
                            + " (ROUND( 6378.138 * 2 * ASIN( SQRT( POW( SIN( ( ").append(latitude).append(" * PI() / 180 - x.latitude * PI() / 180 ) / 2 ), 2 ) + COS( ").append(latitude).append(" * PI() / 180) * COS(x.latitude * PI() / 180) * POW( SIN( ( ").append(longitude).append(" * PI() / 180 - x.longitude * PI() / 180 ) / 2 ), 2 ) ) ) ,3)) as distance ,")
                            //+ " 0 as instance ,")
                            .append(" x.dateCreated as dateCreated ) ");
                    ql.insert(0, select);
                }
                Double distance = search.getValue("distance");
                ql.append(" and (ROUND( 6378.138 * 2 * ASIN( SQRT( POW( SIN( ( ").append(latitude).append(" * PI() / 180 - x.latitude * PI() / 180 ) / 2 ), 2 ) + COS( ").append(latitude).append(" * PI() / 180) * COS(x.latitude * PI() / 180) * POW( SIN( ( ").append(longitude).append(" * PI() / 180 - x.longitude * PI() / 180 ) / 2 ), 2 ) ) ) ,3)) < ").append(distance);
            }
        }
    }

    @Override
    public void setValues(Query query, Searchable search) {
        super.setValues(query, search);
    }
}
