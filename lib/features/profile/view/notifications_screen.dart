import 'package:cozy/core/component/custom_toast.dart';
import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:cozy/core/notification/notification_prefs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//! NotificationsScreen
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

//! _NotificationsScreenState
class _NotificationsScreenState extends State<NotificationsScreen> {
  bool pushNotifications = true;
  bool emailNotifications = true;
  bool smsNotifications = false;
  bool orderUpdates = true;
  bool promotionalOffers = true;
  bool newArrivals = false;
  bool priceDrops = true;
  bool stockAlerts = false;

  @override
  void initState() {
    super.initState();
    // Load saved preferences
    pushNotifications = NotificationPrefs.getPushEnabled();
    emailNotifications = NotificationPrefs.getEmailEnabled();
    smsNotifications = NotificationPrefs.getSmsEnabled();
    orderUpdates = NotificationPrefs.getOrderUpdatesEnabled();
    promotionalOffers = NotificationPrefs.getPromotionsEnabled();
    newArrivals = NotificationPrefs.getNewArrivalsEnabled();
    priceDrops = NotificationPrefs.getPriceDropsEnabled();
    stockAlerts = NotificationPrefs.getStockAlertsEnabled();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'notifications'.tr(context),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'notification_preferences'.tr(context),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'manage_notification_settings'.tr(context),
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textGrey,
              ),
            ),
            SizedBox(height: 24.h),
            _buildSectionHeader('general_notifications'.tr(context)),
            _buildNotificationTile(
              'push_notifications'.tr(context),
              'receive_push_notifications'.tr(context),
              pushNotifications,
              (value) async {
                setState(() => pushNotifications = value);
                await NotificationPrefs.setPushEnabled(value);
              },
            ),
            _buildNotificationTile(
              'email_notifications'.tr(context),
              'receive_email_notifications'.tr(context),
              emailNotifications,
              (value) async {
                setState(() => emailNotifications = value);
                await NotificationPrefs.setEmailEnabled(value);
              },
            ),
            _buildNotificationTile(
              'sms_notifications'.tr(context),
              'receive_sms_notifications'.tr(context),
              smsNotifications,
              (value) async {
                setState(() => smsNotifications = value);
                await NotificationPrefs.setSmsEnabled(value);
              },
            ),
            SizedBox(height: 24.h),
            _buildSectionHeader('order_notifications'.tr(context)),
            _buildNotificationTile(
              'order_updates'.tr(context),
              'order_status_updates'.tr(context),
              orderUpdates,
              (value) async {
                setState(() => orderUpdates = value);
                await NotificationPrefs.setOrderUpdatesEnabled(value);
              },
            ),
            SizedBox(height: 24.h),
            _buildSectionHeader('marketing_notifications'.tr(context)),
            _buildNotificationTile(
              'promotional_offers'.tr(context),
              'special_deals_discounts'.tr(context),
              promotionalOffers,
              (value) async {
                setState(() => promotionalOffers = value);
                await NotificationPrefs.setPromotionsEnabled(value);
              },
            ),
            _buildNotificationTile(
              'new_arrivals'.tr(context),
              'latest_products_updates'.tr(context),
              newArrivals,
              (value) async {
                setState(() => newArrivals = value);
                await NotificationPrefs.setNewArrivalsEnabled(value);
              },
            ),
            _buildNotificationTile(
              'price_drops'.tr(context),
              'price_reduction_alerts'.tr(context),
              priceDrops,
              (value) async {
                setState(() => priceDrops = value);
                await NotificationPrefs.setPriceDropsEnabled(value);
              },
            ),
            _buildNotificationTile(
              'stock_alerts'.tr(context),
              'out_of_stock_notifications'.tr(context),
              stockAlerts,
              (value) async {
                setState(() => stockAlerts = value);
                await NotificationPrefs.setStockAlertsEnabled(value);
              },
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: AppButton(
                onPressed: _saveSettings,
                text: 'save_settings'.tr(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textBlack,
        ),
      ),
    );
  }

  Widget _buildNotificationTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  void _saveSettings() async {
    // Everything is persisted on toggle; this is a visual confirmation.
    showToast(context,
        message: 'settings_saved'.tr(context), state: ToastStates.success);
  }
}
