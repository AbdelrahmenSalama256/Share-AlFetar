import 'dart:convert';

import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/features/order/data/model/breakfast_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

@pragma('vm:entry-point')
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _OverlayApp());
}

class _OverlayApp extends StatelessWidget {
  const _OverlayApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const _OverlayBubble(),
      theme: ThemeData(
        fontFamily: 'Tajawal',
      ),
    );
  }
}

class _OverlayBubble extends StatefulWidget {
  const _OverlayBubble();

  @override
  State<_OverlayBubble> createState() => _OverlayBubbleState();
}

class _OverlayBubbleState extends State<_OverlayBubble> {
  BreakfastRequestModel? _request;

  @override
  void initState() {
    super.initState();
    FlutterOverlayWindow.overlayListener.listen((event) {
      if (event == null) return;
      try {
        final json = jsonDecode(event.toString()) as Map<String, dynamic>;
        setState(() {
          _request = BreakfastRequestModel.fromJson(json);
        });
      } catch (_) {
        // ignore malformed payload
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final req = _request;
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 18,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.fastfood, color: AppColors.primary),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'طلب فطار جديد',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textBlack,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: FlutterOverlayWindow.closeOverlay,
                    icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (req != null) ...[
                Text(
                  'من: ${req.requesterName}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'عدد الأصناف: ${req.items.length}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                if ((req.note ?? '').isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    'ملاحظات: ${req.note}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ] else
                const Text(
                  'جارِ استقبال البيانات...',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: FlutterOverlayWindow.closeOverlay,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.border),
                      ),
                      child: const Text('إغلاق'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await FlutterOverlayWindow.shareData('open_app');
                        await FlutterOverlayWindow.closeOverlay();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('افتح التطبيق'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
