import 'package:cozy/core/app/cozy_home.dart';
import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/core/network/local_network.dart';
import 'package:cozy/core/notification/local_notification_handler.dart';
import 'package:cozy/core/services/service_locator.dart';
import 'package:cozy/features/breakfast_menu/view/cubit/breakfast_menu_cubit.dart';
import 'package:cozy/features/mode/view/cubit/mode_cubit.dart';
import 'package:cozy/features/order/view/cubit/order_cubit.dart';
import 'package:cozy/features/overlay/view/cubit/popup_cubit.dart';
import 'package:cozy/overlay_main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:upgrader/upgrader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();

  //! Orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  //! Status Bar Settings
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  //! Service Locator
  initServiceLocator();
  //! Cache Helper
  await sl<CacheHelper>().init();
  // Initialize local + push notification handlers (requires CacheHelper)
  await LocalNotificationService.init();
  await LocalNotificationService.requestPermissions();
  await _requestOverlayPermission();
  //! Update Checker
  if (kDebugMode) {
    await Upgrader.clearSavedSettings();
  }
  //! Application Starts From here.
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<GlobalCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<BreakfastMenuCubit>()..loadMenu(),
        ),
        BlocProvider(
          create: (context) => sl<OrderCubit>()..loadActiveRequest(),
        ),
        BlocProvider(
          create: (context) => sl<ModeCubit>()..loadMode(),
        ),
        BlocProvider(
          create: (context) => sl<PopupCubit>()..start(),
        ),
      ],
      child: UpgradeAlert(
          upgrader: Upgrader(
            debugLogging: kDebugMode,
          ),
          dialogStyle: UpgradeDialogStyle.cupertino,
          child: const CozyHome()),
    ),
  );
}

Future<void> _requestOverlayPermission() async {
  try {
    final granted = await FlutterOverlayWindow.isPermissionGranted();
    if (granted != true) {
      await FlutterOverlayWindow.requestPermission();
    }
  } catch (_) {
    // ignore overlay permission failure on startup
  }
}
