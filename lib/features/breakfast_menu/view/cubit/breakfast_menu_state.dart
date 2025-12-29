import 'package:cozy/features/breakfast_menu/data/model/breakfast_item_model.dart';

abstract class BreakfastMenuState {}

class BreakfastMenuInitial extends BreakfastMenuState {}

class BreakfastMenuLoading extends BreakfastMenuState {}

class BreakfastMenuLoaded extends BreakfastMenuState {
  final List<BreakfastItemModel> items;
  BreakfastMenuLoaded(this.items);
}

class BreakfastMenuError extends BreakfastMenuState {
  final String message;
  BreakfastMenuError(this.message);
}
