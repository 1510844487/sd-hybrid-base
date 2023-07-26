import 'package:flutter/cupertino.dart';
import 'package:flutter_boost/flutter_boost.dart';

/// 页面生命周期管理者
///
/// 主要用户监听页面的显示状态以及引用的前后台状态等
///
class SDPageLifecycler {
  ///页面事件监听集合
  final Set<SDGlobalPageVisibleObserver> _globalListeners = <SDGlobalPageVisibleObserver>{};

  ///单个页面事件监听集合
  ///listeners for single page event
  final Map<Route<dynamic>, Set<SDPageVisibileObserver>> _listeners = <Route<dynamic>, Set<SDPageVisibileObserver>>{};

  final Map<SDPageVisibileObserver, _BoostPageVisibilityObserver> _sdPageObserver2BoostPageObserverMap =
      <SDPageVisibileObserver, _BoostPageVisibilityObserver>{};

  /// 是否已经添加 Boost 页面全局时间观察者
  bool _hasAddBoostGlobalObserver = false;

  static final SDPageLifecycler _sdPageLifecycler = SDPageLifecycler._();

  SDPageLifecycler._();

  static SDPageLifecycler get instance => _sdPageLifecycler;

  ///注册观察者
  ///
  /// [observer] 观察者
  void addGlobalObserver(SDGlobalPageVisibleObserver? observer) {
    if (observer != null) {
      _globalListeners.add(observer);
    }
    _addBootstGlobalObserver();
  }

  ///移除观察者
  ///
  /// [observer] 观察者
  void removeGlobalObserver(SDGlobalPageVisibleObserver? observer) {
    if (observer != null) {
      _globalListeners.remove(observer);
    }
  }

  /// 注册boost页面全局事件观察者
  void _addBootstGlobalObserver() {
    if (!_hasAddBoostGlobalObserver) {
      _hasAddBoostGlobalObserver = true;
      PageVisibilityBinding.instance.addGlobalObserver(_BoostGlobalPageVisibleObserver(_globalListeners));
    }
  }

  /// 注册单个页面观察者
  ///
  /// [observer] 页面观察者
  ///
  /// [route] 页面路由
  void addObserver(SDPageVisibileObserver observer, BuildContext? context) {
    if (context != null) {
      try {
        Route<dynamic> route = ModalRoute.of<dynamic>(context) as Route<dynamic>;
        // final observers = _listeners.putIfAbsent(route, () => <SDPageVisibileObserver>{});
        // observers.add(observer);
        _addBoostObserver(observer, route);
      } catch (e) {
        print(e);
      }
    }
  }

  /// 移除单个页面观察者
  ///
  /// [observer] 页面观察者
  void removeObserver(SDPageVisibileObserver observer) {
    _removeBoostObserver(observer);

    // for (final route in _listeners.keys) {
    //   final observers = _listeners[route];
    //   observers?.remove(observer);
    //   _removeBoostObserver(observer);
    // }
  }

  /// 注册boost页面事件观察者
  void _addBoostObserver(SDPageVisibileObserver observer, Route<dynamic> route) {
    if(!_sdPageObserver2BoostPageObserverMap.containsKey(observer)){
      _BoostPageVisibilityObserver _boostPageVisibilityObserver = _BoostPageVisibilityObserver(observer);
      _sdPageObserver2BoostPageObserverMap[observer] = _boostPageVisibilityObserver;
      PageVisibilityBinding.instance.addObserver(_boostPageVisibilityObserver, route);
    }
  }

  /// 移除boost页面事件观察者
  void _removeBoostObserver(SDPageVisibileObserver observer) {
    _BoostPageVisibilityObserver? _boostPageVisibilityObserver = _sdPageObserver2BoostPageObserverMap.remove(observer);
    if (_boostPageVisibilityObserver != null) {
      PageVisibilityBinding.instance.removeObserver(_boostPageVisibilityObserver);
    }
  }
}

/// 页面是否可见观察者
class SDGlobalPageVisibleObserver {
  /// 页面被添加
  void onPagePush(Route<dynamic> route) {}

  /// 页面可见
  ///
  /// Android "onResume" or iOS "viewDidAppear"
  void onPageShow(Route<dynamic> route) {}

  /// 页面不可见
  ///
  /// Android "onStop" or iOS "viewDidDisappear"
  void onPageHide(Route<dynamic> route) {}

  /// 页面被移除
  void onPagePop(Route<dynamic> route) {}

  /// 应用处于前台
  ///
  /// 前后台切换触发
  void onForeground(Route<dynamic> route) {}

  /// 应用处于后台
  ///
  /// 前后台切换触发
  void onBackground(Route<dynamic> route) {}
}

/// 单个页面观察者
class SDPageVisibileObserver {
  /// 页面可见
  ///
  /// Android "onResume" or iOS "viewDidAppear"
  void onPageShow() {}

  /// 页面不可见
  ///
  /// Android "onStop" or iOS "viewDidDisappear"
  void onPageHide() {}

  /// 应用处于前台
  ///
  /// 前后台切换触发
  void onForeground() {}

  /// 应用处于后台
  ///
  /// 前后台切换触发
  void onBackground() {}
}

class _BoostGlobalPageVisibleObserver with GlobalPageVisibilityObserver {
  final Set<SDGlobalPageVisibleObserver> _globalListeners;

  _BoostGlobalPageVisibleObserver(this._globalListeners);

  @override
  void onPagePush(Route<dynamic> route) {
    for (var element in _globalListeners) {
      element.onPagePush(route);
    }
  }

  @override
  void onBackground(Route<dynamic> route) {
    for (var element in _globalListeners) {
      element.onBackground(route);
    }
  }

  @override
  void onForeground(Route<dynamic> route) {
    for (var element in _globalListeners) {
      element.onForeground(route);
    }
  }

  @override
  void onPagePop(Route<dynamic> route) {
    for (var element in _globalListeners) {
      element.onPagePop(route);
    }
  }

  @override
  void onPageHide(Route<dynamic> route) {
    for (var element in _globalListeners) {
      element.onPageHide(route);
    }
  }

  @override
  void onPageShow(Route<dynamic> route) {
    for (var element in _globalListeners) {
      element.onPageShow(route);
    }
  }
}

class _BoostPageVisibilityObserver with PageVisibilityObserver {
  final SDPageVisibileObserver? _sdPageVisibileObserver;

  _BoostPageVisibilityObserver(this._sdPageVisibileObserver);

  @override
  void onPageShow() {
    if (_sdPageVisibileObserver != null) {
      _sdPageVisibileObserver!.onPageShow();
    }
  }

  @override
  void onBackground() {
    if (_sdPageVisibileObserver != null) {
      _sdPageVisibileObserver!.onBackground();
    }
  }

  @override
  void onForeground() {
    if (_sdPageVisibileObserver != null) {
      _sdPageVisibileObserver!.onForeground();
    }
  }

  @override
  void onPageHide() {
    if (_sdPageVisibileObserver != null) {
      _sdPageVisibileObserver!.onPageHide();
    }
  }
}
