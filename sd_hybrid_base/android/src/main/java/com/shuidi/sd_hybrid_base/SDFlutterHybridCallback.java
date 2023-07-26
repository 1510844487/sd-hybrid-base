package com.shuidi.sd_hybrid_base;

import android.app.Activity;

import com.idlefish.flutterboost.containers.FlutterBoostActivity;

import java.util.Map;

import io.flutter.embedding.engine.FlutterEngine;


public abstract class SDFlutterHybridCallback<T extends FlutterBoostActivity> {

    private Class<T> mClazz;

    /**
     * Flutter 混合栈
     *
     * 后面这个方法会逐步废掉
     *
     * @param clazz
     */
    public SDFlutterHybridCallback(Class<T> clazz) {
        mClazz = clazz;
        if (mClazz == null) {
            throw new IllegalArgumentException("参数 clazz 不能为 null");
        }
    }

    public Class<T> getClazz() {
        return mClazz;
    }

    /**
     * Flutter 开启 原生页面 回调（在Flutter内开启一个路由且不存在时回到到此处）
     * <p>
     * <br>
     * 若Flutter页面需要接收原生页面的回传参数，在开启原生页面时必须使用 startActivityForResult 方法，
     * <br>
     * 且requestCode必须在参数 routerInfo 取值， 如何取值详见{@link SDHybridRouterInfo}该类
     * <p>
     * 示例：
     * <p>
     * <br>
     * Intent intent = new Intent(this, YourActivty.class);<p>
     * ...<p>
     * activity.startActivityForResult(intent, routerInfo.getRequestCode());<p><br>
     * <p>
     * 在开启的原生页面回传数据到Flutter时需调用 {@link SDFlutterRouter#pop(Activity, Map)} 该方法回传数据
     * <p>
     * <br>
     * 示例：
     * <p>
     * <br>
     * Map<String, String> result = new HashMap<>();<p>
     * result.put("title", "这里是标题");<p>
     * result.put("code", "10001");<p>
     * result.put("msg", "this is a message");<p>
     * SDFlutterRouter.getInstance().pop(this, result);<p><br>
     *
     * @param routerInfo 路由信息
     */
    public abstract void pushNativieRouter(SDHybridRouterInfo routerInfo);

    /**
     * 开启Flutter
     * @param engine    flutter engine
     */
    public void onStart(FlutterEngine engine){

    }

    /**
     * 是否重写后台事件分发
     * @return
     */
    public boolean shouldOverrideBackForegroundEvent(){
        return false;
    }

    /**
     * 获取当前activity实例，仅适用于延迟初始化的情况
     * @return
     */
    public Activity getCurrentActivity(){
        return null;
    }



}
