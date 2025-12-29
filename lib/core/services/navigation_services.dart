




import 'package:flutter/material.dart';

import '../app/cozy_home.dart' show navigatorKey;

//! NavigationService
class NavigationService {

  static GlobalKey<NavigatorState> get navigator => navigatorKey;

  static Future<dynamic>? navigateTo(String routeName, {Object? arguments}) {
    if (navigator.currentState != null) {
      return navigator.currentState!.pushNamed(routeName, arguments: arguments);
    }
    return null;
  }

  static Future<dynamic>? navigateToReplacement(String routeName,
      {Object? arguments}) {
    if (navigator.currentState != null) {
      return navigator.currentState!
          .pushReplacementNamed(routeName, arguments: arguments);
    }
    return null;
  }

  static Future<dynamic>? navigateToAndRemoveUntil(String routeName,
      {Object? arguments, bool Function(Route<dynamic>)? predicate}) {
    if (navigator.currentState != null) {
      return navigator.currentState!.pushNamedAndRemoveUntil(
        routeName,
        predicate ?? (route) => false,
        arguments: arguments,
      );
    }
    return null;
  }

  static void goBack({dynamic result}) {
    if (navigator.currentState != null && navigator.currentState!.canPop()) {
      navigator.currentState!.pop(result);
    }
  }

  static bool canGoBack() {
    return navigator.currentState != null && navigator.currentState!.canPop();
  }
}
