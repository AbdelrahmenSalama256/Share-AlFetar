import 'package:cozy/features/order/data/model/breakfast_request_model.dart';

abstract class PopupState {}

class PopupHidden extends PopupState {}

class PopupVisible extends PopupState {
  final BreakfastRequestModel request;
  PopupVisible(this.request);
}
