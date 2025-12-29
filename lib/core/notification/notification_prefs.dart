import 'package:cozy/core/constants/widgets/print_util.dart';
import 'package:cozy/core/network/local_network.dart';
import 'package:cozy/core/notification/local_notification_handler.dart';
import 'package:cozy/core/services/service_locator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//! NotificationPrefs
class NotificationPrefs {
  static const String _pushKey = 'push_notifications_enabled';
  static const String _emailKey = 'email_notifications_enabled';
  static const String _smsKey = 'sms_notifications_enabled';
  static const String _orderUpdatesKey = 'order_updates_enabled';
  static const String _promoKey = 'promotional_offers_enabled';
  static const String _newArrivalsKey = 'new_arrivals_enabled';
  static const String _priceDropsKey = 'price_drops_enabled';
  static const String _stockAlertsKey = 'stock_alerts_enabled';

  static final _cache = sl<CacheHelper>();

  // Defaults
  static bool get _defaultEnabled => true;

  static bool getPushEnabled() {
    final v = _cache.getData(key: _pushKey);
    return v is bool ? v : _defaultEnabled;
  }

  static bool getEmailEnabled() {
    final v = _cache.getData(key: _emailKey);
    return v is bool ? v : _defaultEnabled;
  }

  static bool getSmsEnabled() {
    final v = _cache.getData(key: _smsKey);
    return v is bool ? v : false;
  }

  static bool getOrderUpdatesEnabled() {
    final v = _cache.getData(key: _orderUpdatesKey);
    return v is bool ? v : _defaultEnabled;
  }

  static bool getPromotionsEnabled() {
    final v = _cache.getData(key: _promoKey);
    return v is bool ? v : _defaultEnabled;
  }

  static bool getNewArrivalsEnabled() {
    final v = _cache.getData(key: _newArrivalsKey);
    return v is bool ? v : false;
  }

  static bool getPriceDropsEnabled() {
    final v = _cache.getData(key: _priceDropsKey);
    return v is bool ? v : _defaultEnabled;
  }

  static bool getStockAlertsEnabled() {
    final v = _cache.getData(key: _stockAlertsKey);
    return v is bool ? v : false;
  }

  /// Enable/disable push notifications locally and at the FCM layer.
  static Future<void> setPushEnabled(bool enabled) async {
    await _cache.saveData(key: _pushKey, value: enabled);

    // Initialize local plugin if needed
    await LocalNotificationService.init();

    if (enabled) {
      // Request permissions and ensure token exists
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      // Foreground presentation on iOS
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Android 13+ runtime permission (best effort)
      try {
        await LocalNotificationService.flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      } catch (_) {}

      final token = await FirebaseMessaging.instance.getToken();
      PrintUtil.success('Push enabled. FCM token: $token');
    } else {
      // Disable foreground presentation
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: false,
        badge: false,
        sound: false,
      );

      // Clear local notifications to avoid showing old ones
      try {
        await LocalNotificationService.flutterLocalNotificationsPlugin
            .cancelAll();
      } catch (_) {}

      // Delete FCM token to stop receiving messages
      try {
        await FirebaseMessaging.instance.deleteToken();
        PrintUtil.warning('Push disabled. FCM token deleted.');
      } catch (_) {}
    }
  }

  static Future<void> setEmailEnabled(bool enabled) async =>
      _cache.saveData(key: _emailKey, value: enabled);
  static Future<void> setSmsEnabled(bool enabled) async =>
      _cache.saveData(key: _smsKey, value: enabled);
  static Future<void> setOrderUpdatesEnabled(bool enabled) async =>
      _cache.saveData(key: _orderUpdatesKey, value: enabled);
  static Future<void> setPromotionsEnabled(bool enabled) async =>
      _cache.saveData(key: _promoKey, value: enabled);
  static Future<void> setNewArrivalsEnabled(bool enabled) async =>
      _cache.saveData(key: _newArrivalsKey, value: enabled);
  static Future<void> setPriceDropsEnabled(bool enabled) async =>
      _cache.saveData(key: _priceDropsKey, value: enabled);
  static Future<void> setStockAlertsEnabled(bool enabled) async =>
      _cache.saveData(key: _stockAlertsKey, value: enabled);
}
