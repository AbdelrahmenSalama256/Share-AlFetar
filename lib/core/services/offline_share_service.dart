import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cozy/features/order/data/model/breakfast_request_model.dart';

/// Offline share over local network broadcast (free, no extra plugins).
/// Listens for incoming requests and emits them; sender broadcasts on LAN.
class OfflineShareService {
  static const _port = 45454;
  static RawDatagramSocket? _listener;
  static final _streamController =
      StreamController<BreakfastRequestModel>.broadcast();

  static Stream<BreakfastRequestModel> get stream => _streamController.stream;

  static Future<void> startListening() async {
    if (_listener != null) return;
    _listener = await RawDatagramSocket.bind(
      InternetAddress.anyIPv4,
      _port,
      reuseAddress: true,
      reusePort: true,
    );
    _listener!.broadcastEnabled = true;
    _listener!.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = _listener!.receive();
        if (datagram == null) return;
        try {
          final payload = utf8.decode(datagram.data);
          final jsonData = jsonDecode(payload) as Map<String, dynamic>;
          final request = BreakfastRequestModel.fromJson(jsonData);
          _streamController.add(request);
        } catch (_) {
          // ignore malformed packets
        }
      }
    });
  }

  static Future<void> sendRequest(BreakfastRequestModel request) async {
    final socket = await RawDatagramSocket.bind(
      InternetAddress.anyIPv4,
      0,
      reuseAddress: true,
      reusePort: true,
    );
    socket.broadcastEnabled = true;
    final payload = utf8.encode(jsonEncode(request.toJson()));
    socket.send(payload, InternetAddress('255.255.255.255'), _port);
    socket.close();
  }

  /// Broadcast an accepted order as a receipt/ack for requesters on the LAN.
  static Future<void> sendReceipt(BreakfastRequestModel request) async {
    await sendRequest(request);
  }

  static Future<void> dispose() async {
    await _streamController.close();
    _listener?.close();
    _listener = null;
  }
}
