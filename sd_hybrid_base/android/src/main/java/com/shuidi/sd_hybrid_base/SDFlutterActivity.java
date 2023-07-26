package com.shuidi.sd_hybrid_base;


import android.os.Bundle;

import com.idlefish.flutterboost.containers.FlutterBoostActivity;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * 水滴 Flutter activity
 */
public class SDFlutterActivity extends FlutterBoostActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        BinaryMessenger binaryMessenger = getFlutterEngine().getDartExecutor().getBinaryMessenger();
//        SDFlutterChannel.instance().init(binaryMessenger);
    }

    @Override
    public void finishContainer(Map<String, Object> result) {
        super.finishContainer(result);
    }
}
