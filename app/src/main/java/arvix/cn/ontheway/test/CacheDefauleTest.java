package arvix.cn.ontheway.test;

import junit.framework.Assert;

import arvix.cn.ontheway.service.inter.CacheService;


/**
 * Created by asdtiang on 2017/7/18 0018.
 * asdtiangxia@163.com
 */

public class CacheDefauleTest  {
    CacheService cache = null;

    public CacheDefauleTest(CacheService cache ){
        this.cache = cache;
    }

    public void startTest(){
        put();
       // putJSON();
    }

    public void put() {
        String key = "keyTest";
        String value = "value";
        cache.put(key,value);
        Assert.assertEquals(cache.get(key),value);
    }
/**
    public void putJSON() {
        TestCacheBean bean = new TestCacheBean();
        bean.setName("name");
        bean.setValue("value");
        String key = "jsonKeyTest";
        cache.putObject(key,bean);
        Assert.assertEquals(cache.getT(key,TestCacheBean.class).getName(),bean.getName());

    }


    public class TestCacheBean{
        private String name;
        private String value;
        public String getValue() {
            return value;
        }

        public void setValue(String value) {
            this.value = value;
        }



        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }
    }**/
}
