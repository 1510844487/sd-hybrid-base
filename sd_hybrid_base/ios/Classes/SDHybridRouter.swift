//
//  SDHybridRouter.swift
//  SDBaoAgent
//
//  Created by Tr2e on 2022/4/20.
//  Copyright © 2022 shuidi. All rights reserved.
//

import Foundation


public typealias SDRouterPushCompletion = (_ completed: Bool) -> Void
public typealias SDRouterPopCompletion = (_ params: [AnyHashable: Any]?) -> Void

public protocol SDHybridRouterDelegate {
    func handleNaviteRouter(_ router: String)
}

public class SDHybridRouter {
    
    public static let shared: SDHybridRouter = SDHybridRouter()
    var delegate: SDHybridRouterDelegate?
    
    public func setup(with delegate: SDHybridRouterDelegate) {
        SDHybridRouter.shared.delegate = delegate
    }
    
    /// * 开启页面
    /// * Flutter页面路由格式: agent://flutter/pageName
    /// * Native页面路由格式: agent://native/pageName
    /// - Parameters:
    ///   - router:         页面路由
    ///   - completion:     页面开启回调
    ///   - popCompletion:  页面关闭回调
    public func push(
        router: String,
        completion: SDRouterPushCompletion? = nil,
        popCompletion: SDRouterPopCompletion? = nil
    ) {
        guard router.count > 0 else { return }
        if let encodeUrl = router.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let routerUrl = URL(string: encodeUrl),
           routerUrl.host == "flutter" {
            // 开启Flutter页面
            push(
                flutterName: routerUrl.path,
                params: routerUrl.query(),
                completion: completion,
                popCompletion: popCompletion
            )
        } else {
            // 开启Native页面
            push(
                nativeRouter: router,
                completion: completion,
                popCompletion: popCompletion
            )
        }
    }
    
    public func push(
        nativeRouter: String,
        completion: SDRouterPushCompletion? = nil,
        popCompletion: SDRouterPopCompletion? = nil
    ) {
        // 原生工程处理
        delegate?.handleNaviteRouter(nativeRouter)
    }
    
    public func push(
        flutterName: String,
        params: [String: Any]? = nil,
        completion: SDRouterPushCompletion? = nil,
        popCompletion: SDRouterPopCompletion? = nil
    ) {
        SDFlutterRouter.push(
            pageName: flutterName,
            params: params,
            completion: completion,
            onPageFinished: popCompletion
        )
    }
}

extension URL {
    func query() -> [String: Any] {
        var parameters = [String: Any]()
        let components = URLComponents.init(string: self.absoluteString)
        components?.queryItems?.forEach({ (item) in
            if item.name.isEmpty == false, let value = item.value {
                if let decode = value.removingPercentEncoding, decode.isEmpty == false {
                    parameters[item.name] = decode
                }
            }
        })
        return parameters
    }
}
