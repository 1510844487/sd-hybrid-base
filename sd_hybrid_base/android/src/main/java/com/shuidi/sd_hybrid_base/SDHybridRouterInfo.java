package com.shuidi.sd_hybrid_base;

import android.net.Uri;
import android.text.TextUtils;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

/**
 * Flutter开启原生路由信息
 *
 * 路由参考：https://wdh.feishu.cn/wiki/wikcns5nUC5o9xuGvdsVZvAwpWc
 *
 */
public class SDHybridRouterInfo {

    /**
     * 路由
     */
    private String router;
    /**
     * scheme
     */
    private String scheme;
    /**
     * host
     */
    private String host;
    /**
     * path
     */
    private String path;
    /**
     * 参数
     */
    private Map<String,Object> params;

    /**
     * requestCode值
     *
     * 此值在开启原生页面时使用
     *
     * 意义：在原生页面关闭时回传值到Flutter进行内部对应使用
     *
     */
    private int requestCode;

    /**
     * Flutter Boost 生成页面唯一Id
     */
    private String uniqueId;


    public SDHybridRouterInfo(String router, int requestCode, String uniqueId) {
        this.router = router;
        this.requestCode = requestCode;
        this.uniqueId = uniqueId;
        if (!TextUtils.isEmpty(router)){
            Uri uri = Uri.parse(router);
            scheme = uri.getScheme();
            host = uri.getAuthority();
            path = uri.getPath();
            String query = uri.getQuery();
            params = new HashMap<>();
            Set<String> keySet = uri.getQueryParameterNames();
            if (keySet != null) {
                for (String key : keySet){
                    String value = uri.getQueryParameter(key);
                    params.put(key, value == null ? "" : value);
                }
//                String[] arr = query.split("&");
//                for (String s : arr) {
//                    String[] p = s.split("=");
//                    if (p.length == 2) {
//                        params.put(p[0], p[1]);
//                    }
//                }
            }
        }
    }

    public String getRouter() {
        return router;
    }

    public String getScheme() {
        return scheme;
    }

    public String getHost() {
        return host;
    }

    public String getPath() {
        return path;
    }

    public Map<String, Object> getParams() {
        return params;
    }

    public int getRequestCode() {
        return requestCode;
    }

    public String getUniqueId() {
        return uniqueId;
    }
}
