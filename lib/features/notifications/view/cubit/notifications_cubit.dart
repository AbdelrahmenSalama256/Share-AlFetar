import 'package:bloc/bloc.dart';

import '../../data/models/notification_model.dart';
import '../../data/repo/notifications_repo.dart';
import 'notifications_state.dart';

//! NotificationsCubit
class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepo notificationsRepo;

  NotificationsCubit(this.notificationsRepo) : super(NotificationsInitial());

  List<NotificationModel> notifications = [];

  Future<void> fetchNotifications() async {
    emit(NotificationsLoading());
    final result = await notificationsRepo.fetchNotifications();
    result.fold(
      (error) => emit(NotificationsError(error)),
      (data) {
        notifications = data;
        emit(NotificationsLoaded(data));
      },
    );
  }

  Future<void> markAsRead(int notificationId) async {
    final result = await notificationsRepo.markAsRead(notificationId);
    result.fold(
      (error) => emit(NotificationsError(error)),
      (success) {

        final index = notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          final updatedNotification = NotificationModel(
            id: notifications[index].id,
            title: notifications[index].title,
            text: notifications[index].text,
            data: notifications[index].data,
            type: notifications[index].type,
            readAt: DateTime.now(),
            createdAt: notifications[index].createdAt,
            link: notifications[index].link,
          );
          notifications[index] = updatedNotification;
          emit(NotificationsLoaded(List.from(notifications)));
        }
      },
    );
  }

  Future<void> markAllAsRead() async {
    final result = await notificationsRepo.markAllAsRead();
    result.fold(
      (error) => emit(NotificationsError(error)),
      (success) {

        notifications = notifications.map((notification) {
          return NotificationModel(
            id: notification.id,
            title: notification.title,
            text: notification.text,
            data: notification.data,
            type: notification.type,
            readAt: DateTime.now(),
            createdAt: notification.createdAt,
            link: notification.link,
          );
        }).toList();
        emit(NotificationsLoaded(List.from(notifications)));
      },
    );
  }

  void clearError() {
    if (state is NotificationsError) {
      emit(NotificationsLoaded(notifications));
    }
  }
}
