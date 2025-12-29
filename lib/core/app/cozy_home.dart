import 'package:cozy/core/component/widgets/app_theme.dart';
import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/core/cubit/global_state.dart';
import 'package:cozy/core/locale/localization_settings.dart';
import 'package:cozy/features/breakfast_menu/view/screens/breakfast_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/service_locator.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//! CozyHome
class CozyHome extends StatelessWidget {
  const CozyHome({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
    ));
    return BlocBuilder<GlobalCubit, GlobalState>(
      builder: (context, state) {
        return ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) {
            return MaterialApp(
              title: 'Share Al Fetaar',
              navigatorKey: navigatorKey,
              theme: AppTheme.getLightTheme(sl<GlobalCubit>().language),
              locale: Locale(sl<GlobalCubit>().language),

              builder: (context, child) {
                final mediaQueryData = MediaQuery.of(context);
                final scale = mediaQueryData.textScaler
                    .clamp(minScaleFactor: 1.0, maxScaleFactor: 1.0);
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaler: scale),
                  child: child!,
                );
              },
              debugShowCheckedModeBanner: false,
              //!Localization Settings
              localizationsDelegates: localizationsDelegatesList,
              supportedLocales: supportedLocalesList,

              //!App Scroll Behavior
              scrollBehavior: ScrollConfiguration.of(context)
                  .copyWith(physics: const ClampingScrollPhysics()),
              //! Theme

              //!Routing

              home: const BreakfastMenuScreen(),
            );
          },
        );
      },
    );
  }
}
