import 'dart:convert';
import 'dart:io';

import 'package:cozy/core/network/local_network.dart';
import 'package:cozy/features/breakfast_menu/data/model/breakfast_item_model.dart';
import 'package:dartz/dartz.dart';

class BreakfastMenuRepo {
  BreakfastMenuRepo(this.cacheHelper);
  final CacheHelper cacheHelper;

  static const _menuKey = 'share_fetaar_menu';

  Future<Either<String, List<BreakfastItemModel>>> getMenu() async {
    try {
      final raw = cacheHelper.getDataString(key: _menuKey);
      if (raw == null) {
        return const Right([]);
      }
      final decoded = jsonDecode(raw) as List<dynamic>;
      final items = decoded
          .map((e) => BreakfastItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(items);
    } catch (_) {
      return const Left('menu_load_failed');
    }
  }

  Future<Either<String, Unit>> saveMenu(List<BreakfastItemModel> items) async {
    try {
      final payload = jsonEncode(
          items.map((item) => item.toJson()).toList(growable: false));
      await cacheHelper.setData(_menuKey, payload);
      return const Right(unit);
    } catch (_) {
      return const Left('menu_save_failed');
    }
  }

  Future<Either<String, List<BreakfastItemModel>>> importFromFile(
      File file) async {
    try {
      final raw = await file.readAsString();
      final decoded = jsonDecode(raw) as List<dynamic>;
      final items = decoded
          .map((e) => BreakfastItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
      await saveMenu(items);
      return Right(items);
    } catch (_) {
      return const Left('menu_import_failed');
    }
  }

  Future<Either<String, Unit>> exportToFile(
      List<BreakfastItemModel> items, File file) async {
    try {
      final payload = jsonEncode(
          items.map((item) => item.toJson()).toList(growable: false));
      await file.writeAsString(payload);
      return const Right(unit);
    } catch (_) {
      return const Left('menu_export_failed');
    }
  }
}
