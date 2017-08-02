package arvix.cn.ontheway.ui;

import android.app.AlertDialog;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.os.Bundle;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.style.AbsoluteSizeSpan;
import android.text.style.ForegroundColorSpan;
import android.text.style.ImageSpan;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.ListView;

import com.baidu.mapapi.search.core.PoiInfo;
import com.baidu.mapapi.search.poi.PoiResult;
import com.handmark.pulltorefresh.library.PullToRefreshBase;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;
import arvix.cn.ontheway.R;
import arvix.cn.ontheway.async.AsyncUtil;
import arvix.cn.ontheway.async.Callback;
import arvix.cn.ontheway.async.Result;
import arvix.cn.ontheway.bean.ARPoint;
import arvix.cn.ontheway.bean.TrackBean;
import arvix.cn.ontheway.data.TrackListData;
import arvix.cn.ontheway.service.inter.CacheInterface;
import arvix.cn.ontheway.ui.head.HeaderHolder;
import arvix.cn.ontheway.ui.track.TrackListActivity;
import arvix.cn.ontheway.ui.track.TrackListAdapter;
import arvix.cn.ontheway.ui.view.ListViewHolder;
import arvix.cn.ontheway.utils.OnthewayApplication;
import arvix.cn.ontheway.utils.StaticMethod;
import arvix.cn.ontheway.utils.StaticVar;


/**
 * Created by asdtiang on 2017/8/2 0002.
 * asdtiangxia@163.com
 */

public class AddressSelectActivity extends BaseActivity  implements AdapterView.OnItemClickListener, PullToRefreshBase.OnRefreshListener2<ListView>{

    @ViewInject(R.id.main_search_edit)
    private EditText searchET;
    private AddressSelectAdapter adapter;
    private List<ARPoint> datas;
    private ListViewHolder listHolder;
    View lastSelected;
    ARPoint selectedPoint;
    CacheInterface cache;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        cache = OnthewayApplication.getInstahce(CacheInterface.class);
        setContentView(R.layout.activity_address_select);
        x.view().inject(this);
        initView();
    }

    private int pageNum = 0;
    private void initView() {
        //android:hint="搜索附近位置"

        SpannableStringBuilder ssb = new SpannableStringBuilder("  icon  搜索附近位置");
        int length = ssb.length();
        AbsoluteSizeSpan absoluteSizeSpan = new AbsoluteSizeSpan(14, true);
        ForegroundColorSpan colorSpan = new ForegroundColorSpan(Color.parseColor("#979797"));
        ssb.setSpan(colorSpan, 6, length, Spannable.SPAN_EXCLUSIVE_INCLUSIVE);
        ssb.setSpan(absoluteSizeSpan, 6, length, Spannable.SPAN_EXCLUSIVE_INCLUSIVE);
        Bitmap b = BitmapFactory.decodeResource(getResources(), R.drawable.sousuo_1);
        ImageSpan imgSpan = new ImageSpan(self, b);
        ssb.setSpan(imgSpan, 2, 6, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        searchET.setHint(ssb);
        initData(false);
        datas = new ArrayList();
        adapter = new AddressSelectAdapter(this, R.layout.address_select_item,datas);
        listHolder = ListViewHolder.initList(this);
        listHolder.list.setAdapter(adapter);
        listHolder.list.setOnItemClickListener(this);
        listHolder.list.setMode(PullToRefreshBase.Mode.BOTH);
        listHolder.list.setOnRefreshListener(this);
        listHolder.list.setRefreshing();
        HeaderHolder head=new HeaderHolder();
        head.init(self,"所在位置");
    }


    private void initData(final boolean refresh) {
        AsyncUtil.goAsync(new Callable<Result<List<ARPoint>>>() {
            @Override
            public Result<List<ARPoint>> call() throws Exception {
                Result<List<ARPoint> > ret = new Result<>();
                List<ARPoint> dataList = new ArrayList<ARPoint>();
                PoiResult poiResult =  cache.getTMem(StaticVar.LAST_POIRESULT, PoiResult.class);
                Double  alt =  cache.getDouble(StaticVar.BAIDU_LOC_CACHE_ALT);
                List<PoiInfo> allAddr = poiResult.getAllPoi();
                for (PoiInfo p: allAddr) {
                    Log.i("MainActivity", "p.name--->" + p.name +"p.phoneNum" + p.phoneNum +" -->p.address:" + p.address + "p.location" + p.location);
                    dataList.add(new ARPoint(p , alt));
                }
                ret.setData(dataList);
                return ret;
            }
        }, new Callback<Result<List<ARPoint>>>() {

            @Override
            public void onHandle(Result<List<ARPoint>> result) {
                if (result.ok()) {
                    //成功才更新page状态
                    if (refresh) {
                        pageNum = 0;
                    }
                    pageNum++;

                    if (refresh) {
                        datas.clear();
                    }
                    datas.addAll(result.getData());
                    adapter.notifyDataSetChanged();
                } else {
                    new AlertDialog.Builder(AddressSelectActivity.this).setMessage(result.getErrorMsg()).show();
                }
                listHolder.mayShowEmpty(adapter.getCount());
                listHolder.list.onRefreshComplete();
            }
        });

    }


    /**
     * Callback method to be invoked when an item in this AdapterView has
     * been clicked.
     * <p>
     * Implementers can call getItemAtPosition(position) if they need
     * to access the data associated with the selected item.
     *
     * @param parent   The AdapterView where the click happened.
     * @param view     The view within the AdapterView that was clicked (this
     *                 will be a view provided by the adapter)
     * @param position The position of the view in the adapter.
     * @param id       The row id of the item that was clicked.
     */
    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

    }

    /**
     * onPullDownToRefresh will be called only when the user has Pulled from
     * the start, and released.
     *
     * @param refreshView
     */
    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {
        initData(true);
    }

    /**
     * onPullUpToRefresh will be called only when the user has Pulled from
     * the end, and released.
     *
     * @param refreshView
     */
    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {
        initData(false);
    }
}
