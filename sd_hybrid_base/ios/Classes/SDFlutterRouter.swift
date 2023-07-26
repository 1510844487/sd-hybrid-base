//
//  SDFlutterRouter.swift
//  SDBaoAgent
//
//  Created by Tr2e on 2022/5/9.
//  Copyright © 2022 shuidi. All rights reserved.
//

import Foundation
import flutter_boost

public struct SDFlutterRouter {
    
    /// * Native开启Flutter页面
    /// - Parameters:
    ///   - pageName:       页面名称
    ///   - params:         页面参数
    ///   - completion:     页面开启回调
    ///   - onPageFinished: 页面关闭回调
    public static func push(
        pageName: String,
        params: [String: Any]? = nil,
        completion: SDRouterPushCompletion? = nil,
        onPageFinished: SDRouterPopCompletion? = nil
    ) {
        guard pageName.count > 0 else { return }
        var pageName = pageName
        if pageName.first != "/" {
            pageName.insert("/", at: pageName.startIndex)
        }
        let options = FlutterBoostRouteOptions()
        options.pageName = pageName
        options.arguments = params ?? [:]
        options.completion = { result in
            completion?(result)
        }
        options.onPageFinished = { params in
            onPageFinished?(params)
        }
        FlutterBoost.instance().open(options)
    }
    
    
    /// * Native页面关闭回调
    /// - Parameters:
    ///   - router: Native页面路由
    ///   - params: 回调参数
    public static func pop(router: String, params: [AnyHashable: Any]? = nil) {
        guard router.count > 0 else { return }
        if let _ = URL(string: router) {
            pop(pageName: router, params: params)
        }
    }
    
    
    /// * Native页面关闭回调
    /// - Parameters:
    ///   - pageName:   Native页面名称
    ///   - params:     回调参数
    public static func pop(pageName: String, params: [AnyHashable: Any]? = nil) {
        FlutterBoost.instance().sendResultToFlutter(
            withPageName: pageName,
            arguments: params ?? [:]
        )
    }
}
