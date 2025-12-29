import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/core/network/local_network.dart';
import 'package:cozy/features/breakfast_menu/data/repo/breakfast_menu_repo.dart';
import 'package:cozy/features/breakfast_menu/view/cubit/breakfast_menu_cubit.dart';
import 'package:cozy/features/mode/data/repo/mode_repo.dart';
import 'package:cozy/features/mode/view/cubit/mode_cubit.dart';
import 'package:cozy/features/order/data/repo/order_repo.dart';
import 'package:cozy/features/order/view/cubit/order_cubit.dart';
import 'package:cozy/features/overlay/view/cubit/popup_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;
void initServiceLocator() {
  //!external
  sl.registerLazySingleton(() => CacheHelper());
  sl.registerLazySingleton(() => GlobalCubit());

  // Local-first breakfast flow only
  sl.registerLazySingleton(() => BreakfastMenuRepo(sl<CacheHelper>()));
  sl.registerLazySingleton(() => OrderRepoLocal(sl<CacheHelper>()));
  sl.registerLazySingleton(() => ModeRepo(sl<CacheHelper>()));
  sl.registerFactory(() => BreakfastMenuCubit(sl<BreakfastMenuRepo>()));
  sl.registerFactory(() => OrderCubit(sl<OrderRepoLocal>()));
  sl.registerFactory(() => ModeCubit(sl<ModeRepo>()));
  sl.registerFactory(() => PopupCubit(sl<OrderRepoLocal>()));

  //! Repositorys
}
