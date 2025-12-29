import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showToast(
  BuildContext context, {
  required String message,
  required ToastStates state,
  Duration duration = const Duration(seconds: 3),
  ToastStyle style = ToastStyle.minimal,
}) {

  ScaffoldMessenger.of(context).removeCurrentSnackBar();


  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: _buildToastContent(message, state, style),
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
    ),
  );
}

Widget _buildToastContent(String message, ToastStates state, ToastStyle style) {
  switch (style) {
    case ToastStyle.furniture:
      return _FurnitureToast(message: message, state: state);
    case ToastStyle.home:
      return _HomeToast(message: message, state: state);
    case ToastStyle.room:
      return _RoomToast(message: message, state: state);
    case ToastStyle.minimal:
      return _MinimalToast(message: message, state: state);
  }
}

enum ToastStates {
  success,
  error,
  warning,
  info,
  delivery,
  orderPlaced,
}

enum ToastStyle {
  furniture,
  home,
  room,
  minimal,
}

//! _FurnitureToast
class _FurnitureToast extends StatefulWidget {
  final String message;
  final ToastStates state;

  const _FurnitureToast({
    required this.message,
    required this.state,
  });

  @override
  State<_FurnitureToast> createState() => _FurnitureToastState();
}

//! _FurnitureToastState
class _FurnitureToastState extends State<_FurnitureToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _iconRotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _iconRotation = Tween<double>(
      begin: -0.2,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value * 100.h),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getToastColor(widget.state),
                    _getToastColor(widget.state).withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: _getToastColor(widget.state).withOpacity(0.3),
                    blurRadius: 12.r,
                    offset: Offset(0, 6.h),
                  ),
                ],
              ),
              child: Row(
                children: [

                  Transform.rotate(
                    angle: _iconRotation.value,
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        _getFurnitureIcon(widget.state),
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),


                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _getToastTitle(context, widget.state),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          widget.message,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),


                  _buildDecorativeShape(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDecorativeShape() {
    return SizedBox(
      width: 30.w,
      height: 30.w,
      child: CustomPaint(
        painter: _FurnitureShapePainter(
          color: Colors.white.withOpacity(0.1),
          state: widget.state,
        ),
      ),
    );
  }
}

//! _HomeToast
class _HomeToast extends StatefulWidget {
  final String message;
  final ToastStates state;

  const _HomeToast({
    required this.message,
    required this.state,
  });

  @override
  State<_HomeToast> createState() => _HomeToastState();
}

//! _HomeToastState
class _HomeToastState extends State<_HomeToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _buildAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _buildAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: _getToastColor(widget.state).withOpacity(0.3),
              width: 2.w,
            ),
            boxShadow: [
              BoxShadow(
                color: _getToastColor(widget.state).withOpacity(0.2),
                blurRadius: 15.r,
                offset: Offset(0, 8.h),
              ),
            ],
          ),
          child: Row(
            children: [

              SizedBox(
                width: 50.w,
                height: 50.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [

                    if (_buildAnimation.value > 0.2)
                      Positioned(
                        bottom: 5.h,
                        child: Container(
                          width: 40.w,
                          height: 6.h,
                          decoration: BoxDecoration(
                            color:
                                _getToastColor(widget.state).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ),

                    if (_buildAnimation.value > 0.4)
                      Positioned(
                        bottom: 11.h,
                        child: Container(
                          width: 30.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            color:
                                _getToastColor(widget.state).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(
                              color:
                                  _getToastColor(widget.state).withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),

                    if (_buildAnimation.value > 0.6)
                      Positioned(
                        top: 10.h,
                        child: Icon(
                          Icons.home_outlined,
                          size: 30.sp,
                          color: _getToastColor(widget.state),
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(width: 16.w),


              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getToastTitle(context, widget.state),
                      style: TextStyle(
                        color: _getToastColor(widget.state),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      widget.message,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

//! _RoomToast
class _RoomToast extends StatelessWidget {
  final String message;
  final ToastStates state;

  const _RoomToast({
    required this.message,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: _getToastColor(state).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: _getToastColor(state).withOpacity(0.3),
          width: 1.w,
        ),
      ),
      child: Row(
        children: [

          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: _getToastColor(state).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              _getRoomIcon(state),
              color: _getToastColor(state),
              size: 20.sp,
            ),
          ),

          SizedBox(width: 12.w),


          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: _getToastColor(state),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//! _MinimalToast
class _MinimalToast extends StatelessWidget {
  final String message;
  final ToastStates state;

  const _MinimalToast({
    required this.message,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: _getToastColor(state),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getSimpleIcon(state),
            color: Colors.white,
            size: 18.sp,
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


//! _FurnitureShapePainter
class _FurnitureShapePainter extends CustomPainter {
  final Color color;
  final ToastStates state;

  _FurnitureShapePainter({required this.color, required this.state});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    switch (state) {
      case ToastStates.success:
        _drawChair(canvas, size, paint);
        break;
      case ToastStates.error:
        _drawBrokenFurniture(canvas, size, paint);
        break;
      case ToastStates.warning:
        _drawCaution(canvas, size, paint);
        break;
      case ToastStates.delivery:
        _drawTruck(canvas, size, paint);
        break;
      default:
        _drawHome(canvas, size, paint);
    }
  }

  void _drawChair(Canvas canvas, Size size, Paint paint) {

    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.8);
    path.lineTo(size.width * 0.2, size.height * 0.4);
    path.lineTo(size.width * 0.8, size.height * 0.4);
    path.lineTo(size.width * 0.8, size.height * 0.8);
    path.lineTo(size.width * 0.7, size.height * 0.8);
    path.lineTo(size.width * 0.7, size.height * 0.5);
    path.lineTo(size.width * 0.3, size.height * 0.5);
    path.lineTo(size.width * 0.3, size.height * 0.8);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawBrokenFurniture(Canvas canvas, Size size, Paint paint) {

    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.8),
      paint..strokeWidth = 2,
    );
    canvas.drawLine(
      Offset(size.width * 0.8, size.height * 0.2),
      Offset(size.width * 0.2, size.height * 0.8),
      paint,
    );
  }

  void _drawCaution(Canvas canvas, Size size, Paint paint) {

    final path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.2);
    path.lineTo(size.width * 0.2, size.height * 0.8);
    path.lineTo(size.width * 0.8, size.height * 0.8);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawTruck(Canvas canvas, Size size, Paint paint) {

    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.4, size.width * 0.8,
          size.height * 0.4),
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.8),
      size.width * 0.1,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.8),
      size.width * 0.1,
      paint,
    );
  }

  void _drawHome(Canvas canvas, Size size, Paint paint) {

    final path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.2);
    path.lineTo(size.width * 0.2, size.height * 0.5);
    path.lineTo(size.width * 0.2, size.height * 0.8);
    path.lineTo(size.width * 0.8, size.height * 0.8);
    path.lineTo(size.width * 0.8, size.height * 0.5);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


Color _getToastColor(ToastStates state) {
  switch (state) {
    case ToastStates.success:
      return AppColors.primary;
    case ToastStates.error:
      return AppColors.red;
    case ToastStates.warning:
      return Colors.amber;
    case ToastStates.info:
      return Colors.blue;
    case ToastStates.delivery:
      return Colors.green;
    case ToastStates.orderPlaced:
      return Colors.purple;
  }
}

IconData _getFurnitureIcon(ToastStates state) {
  switch (state) {
    case ToastStates.success:
      return Icons.chair_outlined;
    case ToastStates.error:
      return Icons.warning_outlined;
    case ToastStates.warning:
      return Icons.info_outlined;
    case ToastStates.delivery:
      return Icons.local_shipping_outlined;
    case ToastStates.orderPlaced:
      return Icons.shopping_bag_outlined;
    default:
      return Icons.home_outlined;
  }
}

IconData _getRoomIcon(ToastStates state) {
  switch (state) {
    case ToastStates.success:
      return Icons.meeting_room_outlined;
    case ToastStates.error:
      return Icons.door_front_door_outlined;
    case ToastStates.warning:
      return Icons.kitchen_outlined;
    case ToastStates.delivery:
      return Icons.garage_outlined;
    default:
      return Icons.home_outlined;
  }
}

IconData _getSimpleIcon(ToastStates state) {
  switch (state) {
    case ToastStates.success:
      return Icons.check_circle_outline;
    case ToastStates.error:
      return Icons.error_outline;
    case ToastStates.warning:
      return Icons.warning_amber_outlined;
    case ToastStates.delivery:
      return Icons.local_shipping_outlined;
    default:
      return Icons.info_outline;
  }
}

String _getToastTitle(BuildContext context, ToastStates state) {
  switch (state) {
    case ToastStates.success:
      return 'toast_perfect'.tr(context);
    case ToastStates.error:
      return 'toast_oops'.tr(context);
    case ToastStates.warning:
      return 'toast_heads_up'.tr(context);
    case ToastStates.delivery:
      return 'toast_on_the_way'.tr(context);
    case ToastStates.orderPlaced:
      return 'toast_order_placed'.tr(context);
    default:
      return 'toast_info'.tr(context);
  }
}


extension FurnitureToastExtension on BuildContext {
  void showFurnitureToast(
    String message, {
    ToastStates state = ToastStates.success,
    ToastStyle style = ToastStyle.furniture,
    Duration duration = const Duration(seconds: 3),
  }) {
    showToast(
      this,
      message: message,
      state: state,
      style: style,
      duration: duration,
    );
  }
}
