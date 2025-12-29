import 'package:cozy/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//! CustomLoadingIndicator
class CustomLoadingIndicator extends StatefulWidget {
  final double? size;
  final Color? color;
  final LoadingType type;

  const CustomLoadingIndicator({
    super.key,
    this.size,
    this.color,
    this.type = LoadingType.furnitureRotation,
  });

  @override
  State<CustomLoadingIndicator> createState() => _CustomLoadingIndicatorState();
}

enum LoadingType {
  furnitureRotation,
  buildingHome,
  furnitureAssembly,
  roomSetup,
}

//! _CustomLoadingIndicatorState
class _CustomLoadingIndicatorState extends State<CustomLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _primaryController;
  late AnimationController _secondaryController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _primaryController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _secondaryController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2,
    ).animate(CurvedAnimation(
      parent: _primaryController,
      curve: Curves.linear,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _secondaryController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _secondaryController,
      curve: Curves.easeInOut,
    ));

    _primaryController.repeat();
    _secondaryController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _secondaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size ?? 60.w;
    final color = widget.color ?? AppColors.primary;

    switch (widget.type) {
      case LoadingType.furnitureRotation:
        return _buildFurnitureRotationLoader(size, color);
      case LoadingType.buildingHome:
        return _buildBuildingHomeLoader(size, color);
      case LoadingType.furnitureAssembly:
        return _buildFurnitureAssemblyLoader(size, color);
      case LoadingType.roomSetup:
        return _buildRoomSetupLoader(size, color);
    }
  }

  Widget _buildFurnitureRotationLoader(double size, Color color) {
    return AnimatedBuilder(
      animation: Listenable.merge([_primaryController, _secondaryController]),
      builder: (context, child) {
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [

              Transform.rotate(
                angle: _rotationAnimation.value * 3.14159,
                child: SizedBox(
                  width: size,
                  height: size,
                  child: Stack(
                    children: [
                      _buildRotatingIcon(Icons.chair_outlined, 0, size, color),
                      _buildRotatingIcon(Icons.bed_outlined, 1, size, color),
                      _buildRotatingIcon(
                          Icons.table_restaurant_outlined, 2, size, color),
                      _buildRotatingIcon(
                          Icons.weekend_outlined, 3, size, color),
                    ],
                  ),
                ),
              ),

              Transform.scale(
                scale: _scaleAnimation.value,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    width: size * 0.4,
                    height: size * 0.4,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.home_outlined,
                      size: size * 0.2,
                      color: color,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBuildingHomeLoader(double size, Color color) {
    return AnimatedBuilder(
      animation: _primaryController,
      builder: (context, child) {
        final progress = _primaryController.value;
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [

              Positioned(
                bottom: size * 0.1,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: (progress * 500).toInt()),
                  width: size * 0.8,
                  height: size * 0.1,
                  decoration: BoxDecoration(
                    color: progress > 0.2
                        ? color.withOpacity(0.3)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),

              Positioned(
                bottom: size * 0.2,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: (progress * 500).toInt()),
                  width: size * 0.6,
                  height: size * 0.4,
                  decoration: BoxDecoration(
                    color: progress > 0.4
                        ? color.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4.r),
                    border: progress > 0.4
                        ? Border.all(color: color.withOpacity(0.5))
                        : null,
                  ),
                ),
              ),

              Positioned(
                top: size * 0.2,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: (progress * 500).toInt()),
                  width: 0,
                  height: 0,
                  decoration: BoxDecoration(
                    border: progress > 0.6
                        ? Border(
                            left: BorderSide(
                              width: size * 0.35,
                              color: Colors.transparent,
                            ),
                            right: BorderSide(
                              width: size * 0.35,
                              color: Colors.transparent,
                            ),
                            bottom: BorderSide(
                              width: size * 0.25,
                              color: color.withOpacity(0.4),
                            ),
                          )
                        : null,
                  ),
                ),
              ),

              Positioned(
                bottom: size * 0.2,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: (progress * 500).toInt()),
                  width: size * 0.15,
                  height: size * 0.25,
                  decoration: BoxDecoration(
                    color: progress > 0.8
                        ? color.withOpacity(0.6)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFurnitureAssemblyLoader(double size, Color color) {
    return AnimatedBuilder(
      animation: _primaryController,
      builder: (context, child) {
        final progress = _primaryController.value;
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [

              _buildChairAssembly(size, color, progress),

              if (progress < 0.8)
                Positioned(
                  top: size * 0.1,
                  right: size * 0.1,
                  child: Transform.rotate(
                    angle: progress * 6.28,
                    child: Icon(
                      Icons.build_outlined,
                      size: size * 0.2,
                      color: color.withOpacity(0.6),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoomSetupLoader(double size, Color color) {
    return AnimatedBuilder(
      animation: Listenable.merge([_primaryController, _secondaryController]),
      builder: (context, child) {
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [

              Container(
                width: size * 0.9,
                height: size * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: color.withOpacity(0.3),
                    width: 2.w,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),

              _buildMovingFurniture(Icons.chair_outlined, size, color, 0),
              _buildMovingFurniture(Icons.bed_outlined, size, color, 0.25),
              _buildMovingFurniture(
                  Icons.table_restaurant_outlined, size, color, 0.5),
              _buildMovingFurniture(Icons.weekend_outlined, size, color, 0.75),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRotatingIcon(
      IconData icon, int index, double size, Color color) {
    final radius = size * 0.35;

    return Positioned(
      left: size / 2 + radius * (index % 2 == 0 ? 1 : -1) * 0.7 - size * 0.08,
      top: size / 2 + radius * (index < 2 ? -1 : 1) * 0.7 - size * 0.08,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Icon(
          icon,
          size: size * 0.16,
          color: color.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildChairAssembly(double size, Color color, double progress) {
    return Stack(
      alignment: Alignment.center,
      children: [

        if (progress > 0.2)
          Positioned(
            bottom: size * 0.2,
            left: size * 0.35,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: size * 0.05,
              height: size * 0.3,
              color: color.withOpacity(0.6),
            ),
          ),
        if (progress > 0.3)
          Positioned(
            bottom: size * 0.2,
            right: size * 0.35,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: size * 0.05,
              height: size * 0.3,
              color: color.withOpacity(0.6),
            ),
          ),

        if (progress > 0.5)
          Positioned(
            bottom: size * 0.4,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: size * 0.35,
              height: size * 0.08,
              decoration: BoxDecoration(
                color: color.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),

        if (progress > 0.7)
          Positioned(
            top: size * 0.2,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: size * 0.3,
              height: size * 0.25,
              decoration: BoxDecoration(
                color: color.withOpacity(0.4),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMovingFurniture(
      IconData icon, double size, Color color, double delay) {
    final progress = (_primaryController.value + delay) % 1.0;
    final moveDistance = size * 0.3;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 100),
      left: size * 0.1 + (moveDistance * progress),
      top: size * 0.1 + (moveDistance * progress),
      child: Transform.scale(
        scale: 0.5 + (progress * 0.5),
        child: Icon(
          icon,
          size: size * 0.15,
          color: color.withOpacity(0.3 + (progress * 0.5)),
        ),
      ),
    );
  }
}


extension CustomLoadingExtension on CustomLoadingIndicator {
  static Widget furniture({double? size, Color? color}) {
    return CustomLoadingIndicator(
      size: size,
      color: color,
      type: LoadingType.furnitureRotation,
    );
  }

  static Widget buildingHome({double? size, Color? color}) {
    return CustomLoadingIndicator(
      size: size,
      color: color,
      type: LoadingType.buildingHome,
    );
  }

  static Widget assembly({double? size, Color? color}) {
    return CustomLoadingIndicator(
      size: size,
      color: color,
      type: LoadingType.furnitureAssembly,
    );
  }

  static Widget roomSetup({double? size, Color? color}) {
    return CustomLoadingIndicator(
      size: size,
      color: color,
      type: LoadingType.roomSetup,
    );
  }
}
