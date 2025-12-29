Breakfast Requester Refactor Plan
=================================

Goal
----
- Convert the e-commerce app into a Breakfast Requester that is 100% local-first, fast, and one-tap focused.
- Keep the existing feature-first architecture, Cubits, get_it DI, ScreenUtil, shared UI atoms, and Either<String, T> pattern.
- Remove all network/Firebase dependencies; use CacheHelper + local notifications only.

Feature Map
-----------
- Keep (renamed/purposed): base shell, intro/onboarding, notifications (local), home → breakfast_menu, product → breakfast_item, cart → current_request, checkout → confirmation, profile → mode (host/requester) + simple profile.
- Add: order (request flow), popup/overlay (host prompt), quick-actions widgets.
- Remove: auth, wishlist, payments/pricing/shipping/inventory, remote offers, remote categories.

Updated Folder Structure
------------------------
```
lib/
  core/
    app/ (cozy_home.dart still wires theme/localization/navigatorKey)
    component/widgets/ (reuse existing atoms/molecules)
    constants/ (trim e-commerce errors/prices, add breakfast keys/strings)
    cubit/global_cubit.dart (trim auth/currency/cart/wishlist concerns)
    network/local_network.dart (CacheHelper only)
    notification/ (local notifications + simple payload handler)
    services/service_locator.dart
  features/
    breakfast_menu/
      data/models/breakfast_item_model.dart
      data/repo/breakfast_menu_repo_local.dart
      view/cubit/breakfast_menu_cubit.dart
      view/screens/breakfast_menu_screen.dart
      view/widgets/quick_request_bar.dart, item tiles/cards
    breakfast_item/  (formerly product; detail view only)
      data/models/breakfast_item_detail.dart
      view/cubit/breakfast_item_cubit.dart
      view/screens/breakfast_item_screen.dart
    order/ (current request)
      data/models/breakfast_request_model.dart
      data/repo/order_repo_local.dart
      view/cubit/order_cubit.dart
      view/widgets/request_summary_sheet.dart
    confirmation/
      view/cubit/confirmation_cubit.dart
      view/screens/confirmation_screen.dart
    mode/
      data/repo/mode_repo_local.dart (persist host/requester mode + name)
      view/cubit/mode_cubit.dart
      view/screens/mode_switch_screen.dart
    notifications/ (local only)
      view/cubit/notification_cubit.dart (reads stored requests + triggers alerts)
    overlay/
      view/cubit/popup_cubit.dart
      view/widgets/host_overlay.dart (accept/reject)
```

Core Changes
------------
- main.dart: remove Firebase init; keep orientation + ScreenUtil; initialize CacheHelper, LocalNotificationService, service locator; wrap app with MultiBlocProvider for GlobalCubit, ModeCubit, OrderCubit, PopupCubit.
- service_locator.dart: drop Dio/DioConsumer and API repos; register CacheHelper, LocalNotificationService, ModeRepoLocal, BreakfastMenuRepoLocal, OrderRepoLocal, NotificationRepoLocal, relevant cubits.
- constants: replace price/currency keys with breakfast-specific keys (menu cache key, request queue key, mode key, requester name key).
- global_cubit.dart: keep language + nav index; remove auth/cart/wishlist/currency; add host/requester mode getter + simple user name cache.
- notifications: use flutter_local_notifications with payload for requestId; remove FCM handling.

Local Data Rules
----------------
- All repositories backed by CacheHelper (JSON encode/decode).
- Keep Either<String, T> for all repo methods and emit error strings that match localization keys.
- Persist:
  - Menu items list (static seed + editable).
  - Pending/current request with status (pending/accepted/rejected).
  - Request history (optional for host view).
  - Mode + display name.

Example Local Repo (CacheHelper + Either)
-----------------------------------------
```dart
class BreakfastMenuRepoLocal {
  BreakfastMenuRepoLocal(this.cache);
  final CacheHelper cache;
  static const _menuKey = 'menu_items';

  Future<Either<String, List<BreakfastItemModel>>> getMenu() async {
    try {
      final raw = cache.getDataString(key: _menuKey);
      if (raw == null) return right(_seedMenu());
      final decoded = jsonDecode(raw) as List<dynamic>;
      final items = decoded
          .map((e) => BreakfastItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(items);
    } catch (_) {
      return left('menu_load_failed');
    }
  }

  Future<Either<String, Unit>> saveMenu(List<BreakfastItemModel> items) async {
    try {
      await cache.setData(_menuKey, jsonEncode(items.map((e) => e.toJson()).toList()));
      return right(unit);
    } catch (_) {
      return left('menu_save_failed');
    }
  }

  List<BreakfastItemModel> _seedMenu() => const [
        BreakfastItemModel(id: 'egg_wrap', name: 'Egg Wrap', type: BreakfastType.sandwich),
        BreakfastItemModel(id: 'coffee', name: 'Coffee', type: BreakfastType.drink),
        BreakfastItemModel(id: 'juice', name: 'Orange Juice', type: BreakfastType.drink),
        BreakfastItemModel(id: 'pb_toast', name: 'Peanut Toast', type: BreakfastType.snack),
      ];
}
```

Order Flow (Requester → Host)
-----------------------------
- Requester taps quick buttons or selects items → OrderCubit saves `BreakfastRequestModel` to CacheHelper.
- OrderCubit triggers LocalNotificationService with payload `{requestId, itemsCount, requesterName}`.
- PopupCubit listens to request stream (from OrderRepoLocal) and shows `HostOverlay` in-app when a pending request exists.
- If app is backgrounded, notification tap opens host overlay via navigatorKey + payload handler.
- Host taps Accept/Reject → OrderRepoLocal updates status + timestamp; PopupCubit hides overlay and fires confirmation event; ConfirmationCubit shows success/rejection screen to requester.

Example Order Cubit
-------------------
```dart
class OrderCubit extends Cubit<OrderState> {
  OrderCubit(this._repo, this._notifications) : super(OrderInitial());
  final OrderRepoLocal _repo;
  final LocalNotificationService _notifications;

  Future<void> placeQuickRequest(BreakfastItemModel item, {String? note}) async {
    emit(OrderSaving());
    final result = await _repo.saveRequest(
      BreakfastRequestModel.quick(item: item, note: note),
    );
    await result.fold(
      (error) => emit(OrderError(error)),
      (request) async {
        await _notifications.showRequestAlert(request);
        emit(OrderPlaced(request));
      },
    );
  }

  Future<void> respondToRequest(String id, RequestStatus status) async {
    emit(OrderUpdating());
    final result = await _repo.setStatus(id, status);
    result.fold(
      (error) => emit(OrderError(error)),
      (request) => emit(OrderStatusChanged(request)),
    );
  }
}
```

Popup/Overlay Flow
------------------
- PopupCubit watches `OrderRepoLocal.watchPending()` (Stream<BreakfastRequestModel?>).
- When a pending request exists, show `HostOverlay` (full-screen modal with Accept/Reject, single-tap actions).
- Overlay actions call `OrderCubit.respondToRequest`, then close via PopupCubit.clear().
- If no pending request, overlay stays hidden.

UI/UX Adjustments
-----------------
- Remove price, quantity, stock, shipping, payment widgets.
- Breakfast Menu: grid/list of items with quick request buttons + optional note field, zero navigation friction.
- Request Summary: one-tap confirm, no form fields.
- Host Overlay: big Accept/Reject buttons, shows requester name, items, optional note; always appears on top + via notification tap.
- Intro: short explainer of requester/host roles and local-only nature.

Removal List
------------
- Delete network layer (dio, interceptors, endpoints), auth/login/register, wishlist, payments/checkout amounts, inventory/variations, remote offers/categories.
- Remove Firebase init and messaging; keep only flutter_local_notifications.
- Drop currency handling and price formatting.

Implementation Checklist
------------------------
- Update pubspec: remove dio/firebase_messaging/pretty_dio_logger/http_parser/html/html_unescape if unused; keep flutter_local_notifications/shared_preferences/bloc/get_it/flutter_screenutil.
- Replace service locator registrations with local repos/cubits.
- Trim GlobalCubit; add ModeCubit/OrderCubit/PopupCubit providers in main.dart.
- Build new menu/order/overlay screens using existing shared components for visuals and touch targets.
- Wire LocalNotificationService to open host overlay via navigatorKey when payload indicates pending request.

