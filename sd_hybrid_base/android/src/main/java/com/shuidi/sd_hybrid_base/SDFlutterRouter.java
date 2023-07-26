package com.shuidi.sd_hybrid_base;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.text.TextUtils;

import com.idlefish.flutterboost.FlutterBoost;
import com.idlefish.flutterboost.FlutterBoostRouteOptions;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

public class SDFlutterRouter {

    private static final String KEY_CLEAR_TASK = "flutter_clearTask";
    private static SDFlutterRouter sSDFlutterRouter;

    private int requestCode = 2000;
    private Map<String, OnRouterCallback> code2CallbackMap = new HashMap<>();

    private SDFlutterRouter() {
    }

    public static SDFlutterRouter instance() {
        if (sSDFlutterRouter == null) {
            synchronized (SDFlutterRouter.class) {
                if (sSDFlutterRouter == null) {
                    sSDFlutterRouter = new SDFlutterRouter();
                }
            }
        }
        return sSDFlutterRouter;
    }


    /**
     * Flutter页面回传数据
     */
    public static abstract class OnRouterCallback {
        /**
         * Flutter页面回传数据
         *
         * @param result 回传数据
         */
        public abstract void onResult(Map<String, Object> result);
    }

    public void push(String router) {
        push(router, null);
    }

    /**
     * 打开Flutter 路由
     * @param router    uri 路由 ， 路由参数拼接  flutter_clearTask 设置 true 可以清空页面栈
     * @param callback  回调
     */
    public void push(String router, OnRouterCallback callback) {
        if (!TextUtils.isEmpty(router)) {
            Uri uri = Uri.parse(router);
            String host = uri.getAuthority();
            if (!"flutter".equals(host)) {
                // 路由格式不合法
            }
            String pageName = uri.getPath();
            Set<String> query = uri.getQueryParameterNames();
            Map<String, Object> params = new HashMap<>();
            if (query != null) {
                for (String key : query) {
                    String value = uri.getQueryParameter(key);
                    params.put(key, value == null ? "" : value);
                }
            }
            boolean clearTask = false;
            if (params.containsKey(KEY_CLEAR_TASK)){
                String clearTaskObj = (String) params.get(KEY_CLEAR_TASK);
                if ("true".equals(clearTaskObj)){
                    clearTask = true;
                }
            }
            pushByPageName(pageName, params, clearTask, callback);
        }
    }


    public void pushByPageName(String pageName) {
        pushByPageName(pageName, null, null);
    }

    public void pushByPageName(String pageName, Map<String, Object> params) {
        pushByPageName(pageName, params, null);
    }

    public void pushByPageName(String pageName, OnRouterCallback callback) {
        pushByPageName(pageName, null, callback);
    }


    /**
     * 打开Flutter路由
     *
     * @param pageName 路由名称
     * @param params   参数
     * @param callback Flutter 路由回传参数
     */
    public void pushByPageName(String pageName, Map<String, Object> params, OnRouterCallback callback) {
        pushByPageName(pageName, params, false, callback);
    }

    /**
     * 打开Flutter路由
     *
     * @param pageName  路由名称
     * @param params    参数
     * @param clearTask 是否清空已存在页面栈（包含原生和Flutter所有页面栈都清除）
     * @param callback  Flutter 路由回传参数
     */
    public void pushByPageName(String pageName, Map<String, Object> params, boolean clearTask, OnRouterCallback callback) {
        if (params == null){
            params = new HashMap<>();
        }
        params.put("flutter_clearTask", clearTask);
        FlutterBoostRouteOptions options = new FlutterBoostRouteOptions.Builder()
                .pageName(pageName)
                .arguments(params)
                .uniqueId(createRequestCode(callback))
//                .requestCode(createRequestCode(callback))
                .build();
        FlutterBoost.instance().open(options);
    }


    /**
     * 生成request code
     *
     * @param callback
     * @return
     */
    private String createRequestCode(OnRouterCallback callback) {
        requestCode += 1;
        String id = UUID.randomUUID().toString();
        if (callback != null) {
            code2CallbackMap.put(id, callback);
        }
        return id;
    }

    /**
     * 回传Flutter页面数据到原生
     *
     * @param id     request code
     * @param result 回传数据
     */
    protected void finishResultData(String id, Map<String, Object> result) {
        OnRouterCallback callback = code2CallbackMap.remove(id);
        if (callback != null) {
            callback.onResult(result);
        }
    }

    /**
     * 关闭当前原生界面，并回传参数到Flutter页面
     *
     * @param result
     */
    public void pop(Activity activity, Map<String, String> result) {
        if (activity == null) {
            return;
        }
        Intent intent = new Intent();
        if (result != null) {
            for (Map.Entry<String, String> entry : result.entrySet()) {
                intent.putExtra(entry.getKey(), entry.getValue());
            }
        }
        activity.setResult(Activity.RESULT_OK, intent);
        activity.finish();
    }

    /**
     * 闭当前原生界面
     *
     * @param activity
     */
    public void pop(Activity activity) {
        pop(activity, null);
    }


}
