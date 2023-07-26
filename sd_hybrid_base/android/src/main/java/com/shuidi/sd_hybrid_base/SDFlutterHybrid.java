package com.shuidi.sd_hybrid_base;

import android.app.Activity;
import android.app.Application;
import android.content.Intent;

import com.idlefish.flutterboost.FlutterBoost;
import com.idlefish.flutterboost.FlutterBoostDelegate;
import com.idlefish.flutterboost.FlutterBoostRouteOptions;
import com.idlefish.flutterboost.containers.FlutterBoostActivity;

import java.util.Map;

import io.flutter.embedding.android.FlutterActivityLaunchConfigs;
import io.flutter.embedding.engine.FlutterEngine;

import com.idlefish.flutterboost.FlutterBoostSetupOptions;

/**
 * 水滴 Flutter 混合栈
 */
public class SDFlutterHybrid {

    private static SDFlutterHybrid sSDFlutterHybrid;

    private SDFlutterHybrid() {
    }

    public static SDFlutterHybrid instance() {
        if (sSDFlutterHybrid == null) {
            synchronized (SDFlutterHybrid.class) {
                if (sSDFlutterHybrid == null) {
                    sSDFlutterHybrid = new SDFlutterHybrid();
                }
            }
        }
        return sSDFlutterHybrid;
    }

    /**
     * 初始化(需在application中初始化，若延迟初始化，需注意 {@link SDFlutterHybridCallback#getCurrentActivity()} 方法重新实现，防止打不开flutter页面问题出现)
     *
     * @param application    上下文
     * @param hybirdDelegate 混合框架代理，用户处理Flutter开启原生界面
     */
    public void init(Application application, SDFlutterHybridCallback hybirdDelegate) {

        if (hybirdDelegate == null) {
            throw new IllegalArgumentException("hybirdDelegate is null");
        }

        FlutterBoost.instance().setup(
                application,
                new FlutterBoostDelegate() {
                    @Override
                    public void pushNativeRoute(FlutterBoostRouteOptions options) {
                        try {
                            String router = options.pageName();
                            String uniqueId = options.uniqueId();
                            int requestCode = options.requestCode();
                            SDHybridRouterInfo routerInfo = new SDHybridRouterInfo(router, requestCode, uniqueId);
                            hybirdDelegate.pushNativieRouter(routerInfo);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }

                    @Override
                    public void pushFlutterRoute(FlutterBoostRouteOptions options) {
                        try {
                            Activity currentActivity = FlutterBoost.instance().currentActivity();
                            if (currentActivity == null){
                                currentActivity = hybirdDelegate.getCurrentActivity();
                            }
                            if (currentActivity != null) {
                                Map<String, Object> params = options.arguments();
                                boolean clearTask = false;
                                if (params.containsKey("flutter_clearTask")) {
                                    clearTask = (boolean) params.get("flutter_clearTask");
                                }
                                Intent intent = new FlutterBoostActivity.CachedEngineIntentBuilder(hybirdDelegate.getClazz())
                                        .backgroundMode(FlutterActivityLaunchConfigs.BackgroundMode.transparent)
                                        .destroyEngineWithActivity(false)
                                        .backgroundMode(options.opaque() ? FlutterActivityLaunchConfigs.BackgroundMode.opaque : FlutterActivityLaunchConfigs.BackgroundMode.transparent)
                                        .uniqueId(options.uniqueId())
                                        .url(options.pageName())
                                        .urlParams(params)
                                        .build(currentActivity);
                                if (clearTask) {
                                    intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK);
                                }
                                currentActivity.startActivityForResult(intent, options.requestCode());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }

                    @Override
                    public boolean popRoute(FlutterBoostRouteOptions options) {
                        try {
                            if (FlutterBoost.instance().currentActivity() != null) {
                                FlutterBoost.instance().currentActivity().finish();
                                int requestCode = options.requestCode();
                                String id = options.uniqueId();
                                Map<String, Object> params = options.arguments();
                                //  处理Flutter页面回传参数给原生界面
                                SDFlutterRouter.instance().finishResultData(id, params);
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        return true;
                    }
                },
                new FlutterBoost.Callback() {
                    @Override
                    public void onStart(FlutterEngine engine) {
                        hybirdDelegate.onStart(engine);
                    }
                },
                new FlutterBoostSetupOptions.Builder()
                        .shouldOverrideBackForegroundEvent(hybirdDelegate.shouldOverrideBackForegroundEvent())
                        .build()
        );

    }


}
