import '../../data/models/notification_model.dart';

abstract class NotificationsState {}

//! NotificationsInitial
class NotificationsInitial extends NotificationsState {}

//! NotificationsLoading
class NotificationsLoading extends NotificationsState {}

//! NotificationsLoaded
class NotificationsLoaded extends NotificationsState {
  final List<NotificationModel> notifications;

  NotificationsLoaded(this.notifications);
}

//! NotificationsError
class NotificationsError extends NotificationsState {
  final String message;

  NotificationsError(this.message);
}

//! NotificationMarkedAsRead
class NotificationMarkedAsRead extends NotificationsState {
  final int notificationId;

  NotificationMarkedAsRead(this.notificationId);
}
