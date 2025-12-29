import 'dart:async';
import 'dart:convert';

import 'package:cozy/core/network/local_network.dart';
import 'package:cozy/features/order/data/model/breakfast_request_model.dart';
import 'package:dartz/dartz.dart';

class OrderRepoLocal {
  OrderRepoLocal(this.cacheHelper);
  final CacheHelper cacheHelper;

  static const _currentKey = 'share_fetaar_current_request';
  static const _logKey = 'share_fetaar_request_log';
  final _streamController = StreamController<BreakfastRequestModel?>.broadcast();
  final _logStreamController =
      StreamController<List<BreakfastRequestModel>>.broadcast();

  Future<Either<String, BreakfastRequestModel>> saveRequest(
      BreakfastRequestModel request) async {
    try {
      await _persist(request);
      await _appendToLog(request);
      return Right(request);
    } catch (_) {
      return const Left('order_save_failed');
    }
  }

  Future<Either<String, BreakfastRequestModel>> setStatus(
      String id, RequestStatus status) async {
    try {
      final current = await _loadActive();
      if (current == null || current.id != id) {
        return const Left('order_not_found');
      }
      final updated = current.copyWith(
        status: status,
        respondedAt: DateTime.now(),
      );
      await _persist(updated);
      await _replaceInLog(updated);
      return Right(updated);
    } catch (_) {
      return const Left('order_update_failed');
    }
  }

  Future<void> clearActive() => _persist(null);

  Future<BreakfastRequestModel?> _loadActive() async {
    final raw = cacheHelper.getDataString(key: _currentKey);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return BreakfastRequestModel.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  Future<void> _persist(BreakfastRequestModel? request) async {
    if (request == null) {
      await cacheHelper.removeData(key: _currentKey);
      _streamController.add(null);
      return;
    }
    final payload = jsonEncode(request.toJson());
    await cacheHelper.setData(_currentKey, payload);
    _streamController.add(request);
  }

  Future<List<BreakfastRequestModel>> _loadLog() async {
    final raw = cacheHelper.getDataString(key: _logKey);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) =>
            BreakfastRequestModel.fromJson(e as Map<String, dynamic>))
        .toList(growable: true);
  }

  Future<void> _persistLog(List<BreakfastRequestModel> requests) async {
    final payload =
        jsonEncode(requests.map((e) => e.toJson()).toList(growable: false));
    await cacheHelper.setData(_logKey, payload);
    _logStreamController.add(List.unmodifiable(requests));
  }

  Future<void> _appendToLog(BreakfastRequestModel request) async {
    final log = await _loadLog();
    final existingIndex = log.indexWhere((element) => element.id == request.id);
    if (existingIndex >= 0) {
      log[existingIndex] = request;
    } else {
      log.insert(0, request);
    }
    await _persistLog(log);
  }

  Future<void> _replaceInLog(BreakfastRequestModel request) async {
    final log = await _loadLog();
    final index = log.indexWhere((element) => element.id == request.id);
    if (index == -1) {
      log.insert(0, request);
    } else {
      log[index] = request;
    }
    await _persistLog(log);
  }

  Future<Either<String, BreakfastRequestModel?>> getActive() async {
    try {
      final active = await _loadActive();
      return Right(active);
    } catch (_) {
      return const Left('order_load_failed');
    }
  }

  Future<Either<String, List<BreakfastRequestModel>>> getLog() async {
    try {
      final log = await _loadLog();
      return Right(log);
    } catch (_) {
      return const Left('order_load_failed');
    }
  }

  Stream<BreakfastRequestModel?> watchActive() {
    return _streamController.stream;
  }

  Stream<List<BreakfastRequestModel>> watchLog() {
    _seedLogStream();
    return _logStreamController.stream;
  }

  Future<void> _seedLogStream() async {
    try {
      final log = await _loadLog();
      _logStreamController.add(List.unmodifiable(log));
    } catch (_) {
      // ignore seed errors
    }
  }
}
