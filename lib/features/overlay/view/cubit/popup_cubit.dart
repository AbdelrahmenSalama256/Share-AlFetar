import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cozy/features/order/data/model/breakfast_request_model.dart';
import 'package:cozy/features/order/data/repo/order_repo.dart';
import 'package:cozy/core/services/offline_share_service.dart';

import 'popup_state.dart';

class PopupCubit extends Cubit<PopupState> {
  PopupCubit(this._repo) : super(PopupHidden());

  final OrderRepoLocal _repo;
  StreamSubscription<BreakfastRequestModel?>? _sub;
  StreamSubscription<BreakfastRequestModel>? _shareSub;

  void start() {
    _sub?.cancel();
    _sub = _repo.watchActive().listen((request) {
      _handleRequest(request);
    });
    OfflineShareService.startListening();
    _shareSub?.cancel();
    _shareSub = OfflineShareService.stream.listen((request) async {
      await _repo.saveRequest(request);
      _handleRequest(request);
    });
    _hydrate();
  }

  Future<void> _hydrate() async {
    final result = await _repo.getActive();
    result.fold((_) {}, (request) {
      _handleRequest(request);
    });
  }

  void show(BreakfastRequestModel request) {
    _handleRequest(request);
  }

  void clear() {
    emit(PopupHidden());
  }

  void _handleRequest(BreakfastRequestModel? request) {
    if (request == null || request.status != RequestStatus.pending) {
      emit(PopupHidden());
      return;
    }
    emit(PopupVisible(request));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    _shareSub?.cancel();
    return super.close();
  }
}
