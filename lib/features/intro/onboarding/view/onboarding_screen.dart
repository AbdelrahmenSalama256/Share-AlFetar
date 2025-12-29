import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/auth/view/create_account_screen.dart';
import 'package:cozy/features/auth/view/login_screen.dart';
import 'package:cozy/features/base/view/base_screen.dart';
import 'package:cozy/features/intro/onboarding/data/model/onboarding_model.dart';
import 'package:flutter/foundation.dart';
import 'package:cozy/core/constants/widgets/custom_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//! OnboardingView
class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

//! _OnboardingViewState
class _OnboardingViewState extends State<OnboardingView>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildMinimalHeader(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingContents.length,
                onPageChanged: (int page) {
                  setState(() {});
                  _animationController.reset();
                  _animationController.forward();
                },
                itemBuilder: (_, i) {
                  return _buildOnboardingPage(i);
                },
              ),
            ),
            _buildMinimalBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(
                  Icons.chair_outlined,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'cozy_home'.tr(context),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
              if (kDebugMode) {
                print("Navigate to Login via Skip");
              }
            },
            child: Text(
              "onboarding_skip".tr(context),
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h),
                    _buildCleanImageContainer(index),
                    SizedBox(height: 32.h),
                    _buildCleanTitle(index),
                    SizedBox(height: 12.h),
                    _buildCleanDescription(index),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCleanImageContainer(int index) {
    final imageSize = MediaQuery.of(context).size.height * 0.25;

    return Container(
      width: imageSize,
      height: imageSize,
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: CustomCachedImage(
          imageUrl: onboardingContents[index].imagePath,
          fit: BoxFit.cover,
          h: imageSize,
          w: imageSize,
          borderRadius: 16.r,
        ),
      ),
    );
  }

  Widget _buildCleanTitle(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        onboardingContents[index].title(context),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textBlack,
          height: 1.2,
        ),
      ),
    );
  }

  Widget _buildCleanDescription(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Text(
        onboardingContents[index].description(context),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColors.textGrey,
          height: 1.4,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildMinimalBottomSection() {
    return Container(
      padding: EdgeInsets.fromLTRB(32.w, 16.h, 32.w, 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSimpleDotIndicator(),
          SizedBox(height: 24.h),
          _buildCleanActionButtons(),
        ],
      ),
    );
  }

  Widget _buildSimpleDotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        onboardingContents.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          width: _pageController.hasClients &&
                  _pageController.page?.round() == index
              ? 20.w
              : 6.w,
          height: 6.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.r),
            color: _pageController.hasClients &&
                    _pageController.page?.round() == index
                ? AppColors.primary
                : AppColors.lightGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildCleanActionButtons() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 48.h,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateAccountScreen(),
                  ),
                );
                if (kDebugMode) {
                  print("Navigate to Create Account");
                }
              },
              child: Center(
                child: Text(
                  "onboarding_create_account".tr(context),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
            if (kDebugMode) {
              print("Navigate to Login");
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                  fontFamily: context.read<GlobalCubit>().language == "ar"
                      ? 'Tajawal'
                      : "Poppins",
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "onboarding_already_have_account".tr(context),
                  ),
                  TextSpan(
                    text: ' ${"onboarding_login".tr(context)}',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontFamily: context.read<GlobalCubit>().language == "ar"
                          ? 'Tajawal'
                          : "Poppins",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const BaseScreen()),
            );
          },
          child: Text(
            'continue_as_guest'.tr(context),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
