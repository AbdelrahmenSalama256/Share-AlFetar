import 'package:cozy/features/order/data/model/breakfast_request_model.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderSaving extends OrderState {}

class OrderPlaced extends OrderState {
  final BreakfastRequestModel request;
  OrderPlaced(this.request);
}

class OrderRestored extends OrderState {
  final BreakfastRequestModel request;
  OrderRestored(this.request);
}

class OrderUpdating extends OrderState {}

class OrderStatusChanged extends OrderState {
  final BreakfastRequestModel request;
  OrderStatusChanged(this.request);
}

class OrderError extends OrderState {
  final String message;
  OrderError(this.message);
}
