import 'package:cozy/core/network/local_network.dart';
import 'package:cozy/core/services/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'global_state.dart';

/// Minimal global cubit: only language + optional bottom nav index for the local notebook app.
class GlobalCubit extends Cubit<GlobalState> {
  GlobalCubit() : super(GlobalInitial());

  int currentNavIndex = 0;
  String language = sl<CacheHelper>().getCachedLanguage();

  void init() {
    emit(LanguageChangedState());
  }

  void changeBottomNavIndex(int index) {
    if (currentNavIndex != index) {
      currentNavIndex = index;
      emit(BottomNavChangeState());
    }
  }

  Future<void> changeLanguage() async {
    emit(LanguageChangingState());
    final newLanguage =
        sl<CacheHelper>().getCachedLanguage() == "en" ? "ar" : "en";
    await sl<CacheHelper>().cacheLanguage(newLanguage);
    language = newLanguage;
    emit(LanguageChangedState());
  }
}
