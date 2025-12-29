import 'package:bloc/bloc.dart';
import 'package:cozy/core/notification/local_notification_handler.dart';
import 'package:cozy/core/services/offline_share_service.dart';
import 'package:cozy/features/breakfast_menu/data/model/breakfast_item_model.dart';
import 'package:cozy/features/order/data/model/breakfast_request_model.dart';
import 'package:cozy/features/order/data/repo/order_repo.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'dart:convert';

import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit(this._repo) : super(OrderInitial());

  final OrderRepoLocal _repo;
  BreakfastRequestModel? _active;

  Future<void> loadActiveRequest() async {
    final result = await _repo.getActive();
    result.fold(
      (error) {},
      (request) {
        if (request != null) {
          _active = request;
          emit(OrderRestored(request));
        }
      },
    );
  }

  Future<void> placeQuickRequest(
    BreakfastItemModel item, {
    String? note,
    String requesterName = 'Guest',
    int quantity = 1,
    double? deliveryFee,
  }) async {
    emit(OrderSaving());
    final request = BreakfastRequestModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: List.generate(quantity, (_) => item),
      requesterName: requesterName,
      status: RequestStatus.pending,
      createdAt: DateTime.now(),
      note: note,
      deliveryFee: deliveryFee ?? 0,
    );
    final result = await _repo.saveRequest(request);
    result.fold(
      (error) => emit(OrderError(error)),
      (saved) async {
        _active = saved;
        await OfflineShareService.sendRequest(saved);
        await LocalNotificationService.showSimpleNotification(
          title: 'New breakfast request',
          body: '${saved.requesterName} wants $quantity x ${item.name}',
          id: saved.hashCode,
        );
        emit(OrderPlaced(saved));
      },
    );
  }

  Future<void> placeMultiRequest(
    List<SelectedOrderItem> selectedItems, {
    String? note,
    String requesterName = 'Guest',
    double deliveryFee = 0,
  }) async {
    if (selectedItems.isEmpty) {
      emit(OrderError('order_empty'));
      return;
    }

    emit(OrderSaving());
    final expandedItems = <BreakfastItemModel>[];
    for (final entry in selectedItems) {
      final qty = entry.quantity <= 0 ? 1 : entry.quantity;
      expandedItems.addAll(List.generate(qty, (_) => entry.item));
    }

    final request = BreakfastRequestModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: expandedItems,
      requesterName: requesterName,
      status: RequestStatus.pending,
      createdAt: DateTime.now(),
      note: note,
      deliveryFee: deliveryFee,
    );

    final result = await _repo.saveRequest(request);
    result.fold(
      (error) => emit(OrderError(error)),
      (saved) async {
        _active = saved;
        await OfflineShareService.sendRequest(saved);
        await LocalNotificationService.showSimpleNotification(
          title: 'New breakfast request',
          body: '${saved.requesterName} shared ${selectedItems.length} items',
          id: saved.hashCode,
        );
        emit(OrderPlaced(saved));
      },
    );
  }

  Future<void> respondToRequest(
    String id,
    RequestStatus status,
  ) async {
    emit(OrderUpdating());
    final result = await _repo.setStatus(id, status);
    result.fold(
      (error) => emit(OrderError(error)),
      (updated) async {
        _active = updated;
        final body = status == RequestStatus.accepted
            ? 'Request accepted'
            : 'Request rejected';
        await LocalNotificationService.showSimpleNotification(
          title: 'Share Al Fetaar',
          body: body,
          id: updated.hashCode,
        );
        if (status == RequestStatus.accepted) {
          await OfflineShareService.sendReceipt(updated);
        }
        emit(OrderStatusChanged(updated));
      },
    );
  }

  /// Broadcast the current pending request again (local network only).
  /// Returns `null` on success, or an error key otherwise.
  Future<String?> shareActiveRequest() async {
    final result = await _repo.getActive();
    final active = result.fold<BreakfastRequestModel?>(
      (_) => _active,
      (request) => request ?? _active,
    );
    if (active == null || active.status != RequestStatus.pending) {
      return 'order_not_found';
    }
    await OfflineShareService.sendRequest(active);
    await LocalNotificationService.showSimpleNotification(
      title: 'Share Al Fetaar',
      body: 'تم بث الطلب على الشبكة المحلية',
      id: active.hashCode,
    );
    await _showOverlayBubble(active);
    return null;
  }

  Future<void> _showOverlayBubble(BreakfastRequestModel request) async {
    try {
      final granted = await FlutterOverlayWindow.isPermissionGranted();
      if (granted != true) {
        final req = await FlutterOverlayWindow.requestPermission();
        if (req != true) return;
      }
      await FlutterOverlayWindow.showOverlay(
        height: 240,
        width: 320,
        enableDrag: true,
        alignment: OverlayAlignment.center,
        overlayTitle: 'Share Al Fetaar',
        overlayContent: '${request.requesterName} أرسل طلب فطار',
        flag: OverlayFlag.clickThrough,
      );
      await FlutterOverlayWindow.shareData(jsonEncode(request.toJson()));
    } catch (_) {
      // ignore overlay errors to avoid breaking flow
    }
  }
}

class SelectedOrderItem {
  const SelectedOrderItem({
    required this.item,
    this.quantity = 1,
  });

  final BreakfastItemModel item;
  final int quantity;
}
