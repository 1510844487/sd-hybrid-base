import 'package:flutter/cupertino.dart';
import 'package:flutter_boost/flutter_boost.dart';

/// 路由管理
class SDNavigator {
  static final SDNavigator _sdNavigator = SDNavigator._();

  SDNavigator._();

  static SDNavigator get instance => _sdNavigator;

  /// 开启路由
  ///
  /// 通过路由开启路由
  ///
  /// [router] 路由
  ///
  /// 示例：agent://flutter/customer/clue?router_withNative=1&router_opaque=1&tab=clue&uid=
  ///
  /// router_withNative 是否依附原生容器打开Flutter路由  0 依附原生容器    1  不依附原生容器   固定参数
  ///
  /// router_opaque     开启的Flutter路由是否透明       0 路由透明       1  路由非透明      固定参数
  ///
  /// 路由格式参考 [https://wdh.feishu.cn/wiki/wikcns5nUC5o9xuGvdsVZvAwpWc#pxFZaJ]
  Future<T?> push<T extends Object?>(String router) {
    if (router.isEmpty) {
      return Future.value(null as T);
    }

    Uri uri = Uri.parse(router);
    if ("flutter" == uri.authority) {
      String path = uri.path;
      Map<String, String> queryParameters = uri.queryParameters;
      String withNativeStr = queryParameters['router_withNative'] ?? '1';
      bool withNative = withNativeStr == '0';
      String opaqueStr = queryParameters['router_opaque'] ?? '1';
      bool opaque = opaqueStr == '0';
      return pushByPageName(path, withNative: withNative, params: queryParameters, opaque: opaque);
    } else {
      return pushByPageName(router, withNative: false, params: {}, opaque: false);
    }
  }

  /// 开启路由
  ///
  /// [pageName] 路由名称
  ///
  /// [withNative] 是否衣服原生容器弹出
  ///
  /// [params] 携带导下一个路由参数
  ///
  /// [opaque] 路由是否透明
  ///
  /// 路由关闭时会返回一个 Future<T?>，此值为路由回传参数
  @Deprecated('\n' '推荐使用 pushByRouter 方法进行替换，该方法后续会逐步去掉')
  Future<T?> pushByPageName<T extends Object?>(
    String pageName, {
    bool? withNative,
    Map<String, dynamic>? params,
    bool? opaque,
  }) {
    if (pageName.isEmpty) {
      return Future.value(null as T);
    }
    return BoostNavigator.instance.push(
      pageName,
      withContainer: withNative ?? false,
      arguments: params,
      opaque: opaque ?? false,
    );
  }

  /// 替换栈顶路由
  ///
  /// 通过路由替换栈顶路由
  ///
  /// [router] 路由
  ///
  /// 示例：agent://flutter/customer/clue?router_withNative=1&router_opaque=1&tab=clue&uid=
  ///
  /// router_withNative 是否依附原生容器打开Flutter路由  0 依附原生容器    1  不依附原生容器   固定参数
  ///
  /// router_opaque     开启的Flutter路由是否透明       0 路由透明       1  路由非透明      固定参数
  ///
  /// 路由格式参考 [https://wdh.feishu.cn/wiki/wikcns5nUC5o9xuGvdsVZvAwpWc#pxFZaJ]
  Future<T> pushReplacement<T extends Object>(String router) {
    Uri uri = Uri.parse(router);
    if ("flutter" == uri.authority) {
      String path = uri.path;
      Map<String, String> queryParameters = uri.queryParameters;
      String withNativeStr = queryParameters['router_withNative'] ?? '1';
      bool withNative = withNativeStr == '0';
      return pushReplacementByPageName(path, withNative: withNative, params: queryParameters);
    } else {
      return pushReplacementByPageName(router, withNative: false, params: {});
    }
  }

  /// 替换栈顶路由
  ///
  /// [pageName] 路由名称
  ///
  /// [withNative] 是否衣服原生容器弹出
  ///
  /// [params] 携带导下一个路由参数
  ///
  /// 返回值路由回传参数
  @Deprecated('\n' '推荐使用 pushByRouter 方法进行替换，该方法后续会逐步去掉')
  Future<T> pushReplacementByPageName<T extends Object>(
    String pageName, {
    bool? withNative = false,
    Map<String, dynamic>? params,
  }) {
    return BoostNavigator.instance.pushReplacement(
      pageName,
      withContainer: withNative ?? false,
      arguments: params,
    );
  }

  /// 关闭路由
  ///
  /// [result] 路由回传参数
  ///
  /// 返回值 Future<bool> 路由关闭成功失败，true 成功  false  失败
  Future<bool> pop<T extends Object>({T? result}) {
    return BoostNavigator.instance.pop(result);
  }

  /// 删除路由
  ///
  /// 根据 [uniqueId] 删除路由
  ///
  /// 参数 [uniqueId] flutter boost 的唯一id
  Future<bool> remove(String? uniqueId) {
    return BoostNavigator.instance.remove(uniqueId);
  }

  /// 获取路由参数
  ///
  /// [context] 路由上下文
  Map<dynamic, dynamic>? getRouteParams(BuildContext context) {
    var result = ModalRoute.of(context)?.settings.arguments;
    if (result == null) {
      return null;
    }
    return result as Map<dynamic, dynamic>;
  }
}
