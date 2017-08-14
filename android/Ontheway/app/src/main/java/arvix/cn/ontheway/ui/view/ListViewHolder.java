package arvix.cn.ontheway.ui.view;

import android.app.Activity;
import android.content.Context;
import android.view.View;
import android.view.ViewGroup;

import com.handmark.pulltorefresh.library.PullToRefreshListView;

import arvix.cn.ontheway.R;

/**
 * @author shiner
 */
public class ListViewHolder {
	public PullToRefreshListView list;
	public ViewGroup empty_ll;

	public static ListViewHolder initList(Context ctx, View root) {
		ListViewHolder holder = new ListViewHolder();
		holder.list = (PullToRefreshListView) root.findViewById(R.id.list);
		holder.list.setShowIndicator(false);
		// holder.list.setOnScrollListener(new PauseOnScrollListener(ImageLoader
		// .getInstance(), false, true));
		holder.empty_ll = (ViewGroup) root.findViewById(R.id.empty_ll);
		return holder;
	}


	public static ListViewHolder initList(Activity act) {
		ListViewHolder holder = new ListViewHolder();
		holder.list = (PullToRefreshListView) act.findViewById(R.id.list);
		holder.list.setShowIndicator(false);
		// holder.list.setOnScrollListener(new PauseOnScrollListener(ImageLoader
		// .getInstance(), false, true));
		holder.empty_ll = (ViewGroup)act.findViewById(R.id.empty_ll);
		return holder;
	}

	public void mayShowEmpty(int count) {
		empty_ll.setVisibility(count > 0 ? View.GONE : View.VISIBLE);
	}

}
