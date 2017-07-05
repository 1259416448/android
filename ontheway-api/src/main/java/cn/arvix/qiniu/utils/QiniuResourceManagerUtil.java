package cn.arvix.qiniu.utils;

import com.qiniu.common.QiniuException;
import com.qiniu.common.Zone;
import com.qiniu.storage.BucketManager;
import com.qiniu.storage.Configuration;
import com.qiniu.storage.model.FetchRet;
import com.qiniu.storage.model.FileInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class QiniuResourceManagerUtil {

    private QiniuUploadUtil qiniuUploadUtil;

    /**
     * 目前默认使用华东
     */
    private Configuration cfg = new Configuration(Zone.zone0());

    @Autowired
    public void setQiniuUploadUtil(QiniuUploadUtil qiniuUploadUtil) {
        this.qiniuUploadUtil = qiniuUploadUtil;
    }

    public BucketManager getBucketManager() {
        return new BucketManager(qiniuUploadUtil.getAuth(), cfg);
    }

    /**
     * 文件管理包括对存储在七牛云存储上的文件进行查看、复制、移动和删除处理。
     *
     * @throws QiniuException
     */
    // 获取空间名列表
    public String[] getAllBucket() throws QiniuException {
        return getBucketManager().buckets();
    }

    /**
     * 根据前缀获取文件列表的迭代器
     *
     * @param prefix    文件名前缀
     * @param limit     每次迭代的长度限制，最大1000，推荐值 100
     * @param delimiter 指定目录分隔符，列出所有公共前缀（模拟列出目录效果）。缺省值为空字符串
     * @return FileInfo迭代器
     */
    // 根据前缀获得空间文件列表,批量获取文件列表
    public void getBucketAll(String prefix, int limit,
                             String delimiter) {
        // BucketManager.FileListIterator it =
        // bucketManager.createFileListIterator(bucket, prefix)
        BucketManager.FileListIterator it = getBucketManager()
                .createFileListIterator(qiniuUploadUtil.getBucket(), prefix, 100, null);
        while (it.hasNext()) {
            FileInfo[] items = it.next();
            if (items.length > 1) {
                //assertNotNull(items[0]);
            }
        }
    }

    // 查看文件的属性
    public FileInfo getFileInfo(String key)
            throws QiniuException {
        FileInfo info = getBucketManager().stat(qiniuUploadUtil.getBucket(), key);
        return info;
    }


    /**
     * 复制文件
     *
     * @param key          复制的文件key
     * @param targetBucket 目标空间
     * @param targetKey    目标名称
     * @throws QiniuException
     */
    public void getFileCopy(String key, String targetBucket,
                            String targetKey) throws QiniuException {
        getBucketManager().copy(qiniuUploadUtil.getBucket(), key, targetBucket, targetKey);
    }

    // 重命名、移动文件
    @SuppressWarnings("unused")
    public void remaneOrMoveFile(String key, String key2,
                                 String targetBucket, String targetKey) throws QiniuException {
        if (true) {
            getBucketManager().rename(qiniuUploadUtil.getBucket(), key, key2);
        } else {
            getBucketManager().move(qiniuUploadUtil.getBucket(), key, targetBucket, targetKey);
        }
    }

    // 删除文件
    public void deleteFile(String key) throws QiniuException {
        getBucketManager().delete(qiniuUploadUtil.getBucket(), key);
    }

    // 批量操作,当需要一次性进行多个操作时, 可以使用批量操作.
    @SuppressWarnings({"null", "unused"})
//    public void moreOperate(String key, String key1, String key2, String key3,
//                            String key4) {
//        String[] array = null;
//        String[] array1 = null;
//        BucketManager.Batch ops = new BucketManager.Batch()
//                .copy(TestConfig.bucket, TestConfig.key, TestConfig.bucket, key)
//                .move(TestConfig.bucket, key1, TestConfig.bucket, key2)
//                .rename(TestConfig.bucket, key3, key4)
//                .stat(TestConfig.bucket, array)
//                .stat(TestConfig.bucket, array[0])
//                .stat(TestConfig.bucket, array[1], array[2])
//                .delete(TestConfig.bucket, array1)
//                .delete(TestConfig.bucket, array1[0])
//                .delete(TestConfig.bucket, array1[1], array1[2]);
//        try {
//            Response r = bucketManager.batch(ops);
//            BatchStatus[] bs = r.jsonToObject(BatchStatus[].class);
//            for (BatchStatus b : bs) {
//                //assertEquals(200, b.code);
//            }
//        } catch (QiniuException e) {
//            Response r = e.response;
//            // 请求失败时简单状态信息
//            System.out.println(r.toString());
//            try {
//                // 响应的文本信息
//                System.out.println(r.bodyString());
//            } catch (QiniuException e1) {
//                // ignore
//            }
//        }
//    }

    // 抓取资源
    public FetchRet getResource(String url, String key)
            throws QiniuException {
        // 要求url可公网正常访问，不指定 key 时以文件的 hash 值为 key
        return getBucketManager().fetch(url, qiniuUploadUtil.getBucket(), key);

    }

    // 更新镜像资源
    // 将key拼接到镜像源地址，然后拉取资源保存在空间
    public void updateResource(String key) throws QiniuException {
        getBucketManager().prefetch(qiniuUploadUtil.getBucket(), key);
    }

}
