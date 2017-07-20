package arvix.cn.ontheway;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.design.widget.BottomNavigationView;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.MenuItem;
import android.widget.TextView;

import com.baidu.mapapi.SDKInitializer;
import com.baidu.mapapi.map.MapView;

public class MainActivity extends AppCompatActivity {
    private static  MainActivity mainActivity;

    private BottomNavigationView.OnNavigationItemSelectedListener mOnNavigationItemSelectedListener
            = new BottomNavigationView.OnNavigationItemSelectedListener() {

        @Override
        public boolean onNavigationItemSelected(@NonNull MenuItem item) {
            Intent intent = null;
            switch (item.getItemId()) {
                case R.id.to_index:
                   // mTextMessage.setText(R.string.title_home);
                    return true;
                case R.id.navigation_map:
                    intent = new Intent(mainActivity, BaiduActivity.class);
                    startActivity(intent);
                    return true;
                case R.id.login_menu:
                    intent = new Intent(mainActivity, LoginActivity.class);
                    startActivity(intent);
                    return true;
            }
            return false;
        }

    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.i(this.getClass().getName(),"MainActivity--->onCreate!!!!!!!!!!!!!--------------->" + System.currentTimeMillis());
        setContentView(R.layout.activity_main);
        mainActivity = this;
       // mTextMessage = (TextView) findViewById(R.id.message);
        BottomNavigationView navigation = (BottomNavigationView) findViewById(R.id.navigation);
        navigation.setOnNavigationItemSelectedListener(mOnNavigationItemSelectedListener);
        SDKInitializer.initialize(getApplicationContext());
      //  getApplicationContext()
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();


    }
    @Override
    protected void onResume() {
        super.onResume();

    }
    @Override
    protected void onPause() {
        super.onPause();

    }


}
