import '../../data/models/order_model.dart';
import '../../data/models/order_tracking_response.dart';

//! OrdersState
class OrdersState {
  const OrdersState();
}

//! OrderInitial
class OrderInitial extends OrdersState {}

//! OrderLoading
class OrderLoading extends OrdersState {}

//! OrderLoaded
class OrderLoaded extends OrdersState {
  final List<OrderModel> orders;

  const OrderLoaded(this.orders);
}

//! OrderDetailsLoading
class OrderDetailsLoading extends OrdersState {}

//! OrderDetailsLoaded
class OrderDetailsLoaded extends OrdersState {
  final OrderModel order;

  const OrderDetailsLoaded(this.order);
}

//! OrderSuccess
class OrderSuccess extends OrdersState {
  final String message;

  const OrderSuccess(this.message);
}

//! OrderError
class OrderError extends OrdersState {
  final String error;

  const OrderError(this.error);
}

//! OrderDetailsError
class OrderDetailsError extends OrdersState {
  final String error;

  const OrderDetailsError(this.error);
}

//! OrderTrackingLoading
class OrderTrackingLoading extends OrdersState {}

//! OrderTrackingLoaded
class OrderTrackingLoaded extends OrdersState {
  final OrderTrackResponse tracking;
  const OrderTrackingLoaded(this.tracking);
}

//! OrderTrackingError
class OrderTrackingError extends OrdersState {
  final String error;

  const OrderTrackingError(this.error);
}
