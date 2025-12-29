import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cozy/features/breakfast_menu/data/model/breakfast_item_model.dart';
import 'package:cozy/features/breakfast_menu/data/repo/breakfast_menu_repo.dart';

import 'breakfast_menu_state.dart';

class BreakfastMenuCubit extends Cubit<BreakfastMenuState> {
  BreakfastMenuCubit(this._repo) : super(BreakfastMenuInitial());

  final BreakfastMenuRepo _repo;
  List<BreakfastItemModel> items = [];
  BreakfastType? filter;

  Future<void> loadMenu() async {
    emit(BreakfastMenuLoading());
    final result = await _repo.getMenu();
    result.fold(
      (error) => emit(BreakfastMenuError(error)),
      (data) {
        items = data;
        emit(BreakfastMenuLoaded(filteredItems));
      },
    );
  }

  Future<void> addItem(BreakfastItemModel item) async {
    items = [...items, item];
    await _repo.saveMenu(items);
    emit(BreakfastMenuLoaded(filteredItems));
  }

  Future<void> updateItem(BreakfastItemModel item) async {
    items = [
      for (final it in items) if (it.id == item.id) item else it,
    ];
    await _repo.saveMenu(items);
    emit(BreakfastMenuLoaded(filteredItems));
  }

  Future<void> deleteItem(String id) async {
    items = items.where((it) => it.id != id).toList();
    await _repo.saveMenu(items);
    emit(BreakfastMenuLoaded(filteredItems));
  }

  Future<void> importFromFile(String path) async {
    emit(BreakfastMenuLoading());
    final result = await _repo.importFromFile(File(path));
    result.fold(
      (error) => emit(BreakfastMenuError(error)),
      (data) {
        items = data;
        emit(BreakfastMenuLoaded(filteredItems));
      },
    );
  }

  Future<void> exportToFile(String path) async {
    await _repo.exportToFile(items, File(path));
  }

  Future<void> refresh() async {
    await loadMenu();
  }

  void setFilter(BreakfastType? type) {
    filter = type;
    emit(BreakfastMenuLoaded(filteredItems));
  }

  List<BreakfastItemModel> get menuItems => items;

  List<BreakfastItemModel> get filteredItems {
    if (filter == null) return items;
    return items.where((item) => item.type == filter).toList();
  }
}
