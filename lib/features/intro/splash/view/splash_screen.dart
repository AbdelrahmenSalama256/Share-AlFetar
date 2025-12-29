import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/constants/app_constant.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/network/local_network.dart';
import 'package:cozy/core/services/service_locator.dart';
import 'package:cozy/features/base/view/base_screen.dart';
import 'package:cozy/features/intro/onboarding/view/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//! SplashScreen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashViewState();
}

//! _SplashViewState
class _SplashViewState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _backgroundController;
  late AnimationController _particleController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();


    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );


    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );


    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    _initializeAnimations();
    _startAnimations();
    _navigateToNextScreen();
  }

  void _initializeAnimations() {

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );


    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeInOut),
      ),
    );


    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic),
      ),
    );


    _rotationAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOutBack),
      ),
    );


    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundController,
        curve: Curves.easeInOut,
      ),
    );


    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _particleController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _startAnimations() {
    _backgroundController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _mainController.forward();
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      _particleController.repeat();
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _backgroundController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  _navigateToNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 3500));
    if (mounted) {
      final cacheHelper = sl<CacheHelper>();
      final token = cacheHelper.getDataString(key: AppConstants.token);
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              token != null ? const BaseScreen() : const OnboardingView(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge(
            [_mainController, _backgroundController, _particleController]),
        builder: (context, child) {
          return Stack(
            children: [

              _buildAnimatedBackground(),

              _buildFloatingFurnitureParticles(),

              _buildMainContent(),

              _buildFurnitureDecorativeShapes(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(AppColors.primary, AppColors.primaryLight,
                    _backgroundAnimation.value) ??
                AppColors.primary,
            AppColors.primary,
            Color.lerp(AppColors.primary, const Color(0xFF1A237E),
                    _backgroundAnimation.value * 0.3) ??
                AppColors.primary,
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingFurnitureParticles() {
    final furnitureIcons = [
      Icons.chair_outlined,
      Icons.bed_outlined,
      Icons.table_restaurant_outlined,
      Icons.weekend_outlined,
      Icons.chair_alt_outlined,
      Icons.kitchen_outlined,
      Icons.desk_outlined,
      Icons.single_bed_outlined,
    ];

    return Stack(
      children: List.generate(8, (index) {
        final delay = index * 0.3;
        final animationValue = (_particleAnimation.value + delay) % 1.0;

        return Positioned(
          left: (30 + index * 40).w + (50 * animationValue).w,
          top: (80 + index * 90).h + (30 * (animationValue * 2 - 1).abs()).h,
          child: Transform.rotate(
            angle: animationValue * 0.5,
            child: Opacity(
              opacity: (1 - animationValue) * 0.4,
              child: Icon(
                furnitureIcons[index],
                size: (16 + index % 3 * 6).sp,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMainContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          _buildLogoContainer(),
          SizedBox(height: 40.h),

          _buildBrandName(),
          SizedBox(height: 8.h),

          _buildTagline(),
          SizedBox(height: 60.h),

          _buildVersionText(),
        ],
      ),
    );
  }

  Widget _buildLogoContainer() {
    return Stack(
      alignment: Alignment.center,
      children: [

        Container(
          width: 200.w,
          height: 200.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.transparent,
              ],
            ),
          ),
        ),


        Container(
          width: 160.w,
          height: 160.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 2.w,
            ),
          ),
        ),


        Container(
          width: 140.w,
          height: 140.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20.r,
                offset: Offset(0, 10.h),
              ),
            ],
          ),
        ),


        Transform.rotate(
          angle: _rotationAnimation.value,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15.r,
                      offset: Offset(0, 5.h),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 80.w,
                    height: 80.w,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.chair_outlined,
                        size: 60.sp,
                        color: AppColors.primary,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBrandName() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Text(
          "cozy_home".tr(context),
          style: TextStyle(
            fontSize: 36.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildTagline() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1.5),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _mainController,
          curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic),
        ),
      ),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
          ),
        ),
        child: Text(
          "splash_tagline".tr(context),
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }

  Widget _buildVersionText() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 2),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _mainController,
          curve: const Interval(0.7, 1.0, curve: Curves.easeOutCubic),
        ),
      ),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.w,
            ),
          ),
          child: Text(
            "${"version".tr(context)}  0.0.1",
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFurnitureDecorativeShapes() {
    return Stack(
      children: [

        Positioned(
          top: 100.h,
          left: 30.w,
          child: Transform.rotate(
            angle: _particleAnimation.value * 0.3,
            child: _buildSofaShape(),
          ),
        ),


        Positioned(
          top: 80.h,
          right: 40.w,
          child: Transform.rotate(
            angle: -_particleAnimation.value * 0.4,
            child: _buildChairShape(),
          ),
        ),


        Positioned(
          top: 300.h,
          left: 20.w,
          child: Transform.rotate(
            angle: _particleAnimation.value * 0.2,
            child: _buildTableShape(),
          ),
        ),


        Positioned(
          bottom: 180.h,
          right: 35.w,
          child: Transform.rotate(
            angle: -_particleAnimation.value * 0.5,
            child: _buildLampShape(),
          ),
        ),


        Positioned(
          bottom: 220.h,
          left: 25.w,
          child: Transform.rotate(
            angle: _particleAnimation.value * 0.3,
            child: _buildBedShape(),
          ),
        ),


        Positioned(
          top: 400.h,
          right: 20.w,
          child: Transform.rotate(
            angle: -_particleAnimation.value * 0.2,
            child: _buildCabinetShape(),
          ),
        ),
      ],
    );
  }


  Widget _buildSofaShape() {
    return SizedBox(
      width: 45.w,
      height: 30.w,
      child: Stack(
        children: [

          Positioned(
            bottom: 0,
            child: Container(
              width: 45.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 5.w,
            child: Container(
              width: 35.w,
              height: 25.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildChairShape() {
    return SizedBox(
      width: 35.w,
      height: 40.w,
      child: Stack(
        children: [

          Positioned(
            bottom: 15.h,
            child: Container(
              width: 35.w,
              height: 15.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 5.w,
            child: Container(
              width: 25.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(3.r),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 8.w,
            child: Container(
              width: 2.w,
              height: 15.w,
              color: Colors.white.withOpacity(0.12),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 8.w,
            child: Container(
              width: 2.w,
              height: 15.w,
              color: Colors.white.withOpacity(0.12),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTableShape() {
    return SizedBox(
      width: 40.w,
      height: 35.w,
      child: Stack(
        children: [

          Positioned(
            top: 10.h,
            child: Container(
              width: 40.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.14),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),

          ...List.generate(4, (index) {
            return Positioned(
              bottom: 0,
              left: index < 2 ? 5.w : 30.w,
              top: index % 2 == 0 ? 18.h : 18.h,
              child: Container(
                width: 3.w,
                height: 17.w,
                color: Colors.white.withOpacity(0.1),
              ),
            );
          }),
        ],
      ),
    );
  }


  Widget _buildLampShape() {
    return SizedBox(
      width: 25.w,
      height: 45.w,
      child: Stack(
        children: [

          Positioned(
            top: 0,
            child: Container(
              width: 25.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                  bottomLeft: Radius.circular(8.r),
                  bottomRight: Radius.circular(8.r),
                ),
              ),
            ),
          ),

          Positioned(
            top: 20.h,
            left: 11.w,
            child: Container(
              width: 3.w,
              height: 20.w,
              color: Colors.white.withOpacity(0.1),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 7.w,
            child: Container(
              width: 11.w,
              height: 5.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildBedShape() {
    return SizedBox(
      width: 50.w,
      height: 30.w,
      child: Stack(
        children: [

          Positioned(
            bottom: 5.h,
            child: Container(
              width: 50.w,
              height: 15.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),

          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 8.w,
              height: 25.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(3.r),
              ),
            ),
          ),

          Positioned(
            top: 8.h,
            right: 8.w,
            child: Container(
              width: 12.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCabinetShape() {
    return Container(
      width: 30.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        children: [

          Container(
            width: 30.w,
            height: 18.w,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.15),
                  width: 1.w,
                ),
              ),
            ),
            child: Center(
              child: Container(
                width: 4.w,
                height: 4.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          SizedBox(
            width: 30.w,
            height: 18.w,
            child: Center(
              child: Container(
                width: 4.w,
                height: 4.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
