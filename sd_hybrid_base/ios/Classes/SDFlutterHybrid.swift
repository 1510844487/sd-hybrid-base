//
//  SDFlutterHybrid.swift
//  SDBaoAgent
//
//  Created by Tr2e on 2022/5/10.
//  Copyright © 2022 shuidi. All rights reserved.
//

import Foundation
import flutter_boost
import UIKit

public class SDFlutterHybrid: NSObject, FlutterBoostDelegate {
    
    /// 单例
    public static let shared: SDFlutterHybrid = SDFlutterHybrid()
    
    
    /// * 初始化方法
    /// - Parameters:
    ///   - routerDelegate:             路由代理，处理原生跳转
    ///   - application:                当前App实例
    ///   - rootNavigationController:   根导航控制器
    ///   - callBack:                   Boost启动回调
    public func setup(
        routerDelegate: SDHybridRouterDelegate,
        application: UIApplication,
        rootNavigationController: UINavigationController,
        callBack: ((_ engine: FlutterEngine) -> Void)? = nil
    ) {
        let singleton = SDFlutterHybrid.shared
        singleton.navigationController = rootNavigationController
        SDHybridRouter.shared.setup(with: routerDelegate)
        FlutterBoost.instance().setup(application, delegate: singleton) { engine in
            if let callBack = callBack, let engine = engine {
                callBack(engine)
            }
        }
    }
    
    var navigationController: UINavigationController?
    var resultTable: Dictionary<String, ([AnyHashable:Any]?) -> Void> = [:]
    
    public func pushNativeRoute(_ pageName: String!, arguments: [AnyHashable : Any]!) {
        SDHybridRouter.shared.push(nativeRouter: pageName)
    }
    
    public func pushFlutterRoute(_ options: FlutterBoostRouteOptions!) {
        
        let vc: FBFlutterViewContainer = FBFlutterViewContainer()
        vc.setName(
            options.pageName,
            uniqueId: options.uniqueId,
            params: options.arguments,
            opaque: options.opaque
        )
        
        let isPresent = (options.arguments?["isPresent"] as? Bool)  ?? false
        let isAnimated = (options.arguments?["isAnimated"] as? Bool) ?? true
        
        resultTable[options.pageName] = options.onPageFinished
        
        if (isPresent || !options.opaque) {
            self.navigationController?.present(vc, animated: isAnimated, completion: nil)
        } else {
            self.navigationController?.pushViewController(vc, animated: isAnimated)
        }
    }
    
    public func popRoute(_ options: FlutterBoostRouteOptions!) {
        
        let animated = (options.arguments["animated"] as? Bool) ?? true
        
        if let vc = self.navigationController?.presentedViewController as? FBFlutterViewContainer,vc.uniqueIDString() == options.uniqueId {
            if vc.modalPresentationStyle == .overFullScreen {
                self.navigationController?.topViewController?.beginAppearanceTransition(true, animated: false)
                vc.dismiss(animated: animated) {
                    self.navigationController?.topViewController?.endAppearanceTransition()
                }
            } else {
                vc.dismiss(animated: animated, completion: nil)
            }
        } else {
            self.navigationController?.popViewController(animated: animated)
        }
        if let onPageFinshed = resultTable[options.pageName] {
            onPageFinshed(options.arguments)
            resultTable.removeValue(forKey: options.pageName)
        }
    }
}
