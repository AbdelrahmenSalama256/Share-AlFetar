import 'package:cozy/core/common/common.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/services/service_locator.dart';
import 'package:cozy/features/profile/data/models/about_model.dart';
import 'package:cozy/features/profile/data/repo/about_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cozy/core/component/widgets/unified_app_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

//! AboutUsScreen
class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: UnifiedAppBar.inner(title: 'about_us'.tr(context)),
      body: FutureBuilder(
        future: sl<AboutRepo>().fetchAbout(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final either = snapshot.data!;
          return either.fold(
            (error) => Center(
                child: Text(error.tr(context),
                    style:
                        TextStyle(fontSize: 16.sp, color: AppColors.textGrey))),
            (about) => _buildContent(context, about),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, AboutResponse data) {
    final lang = Localizations.localeOf(context).languageCode;
    final aboutTitle =
        lang == 'ar' ? (data.about.titleAr ?? '') : (data.about.title ?? '');
    final aboutDesc = lang == 'ar'
        ? (data.about.descriptionAr ?? '')
        : (data.about.description ?? '');
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (aboutTitle.isNotEmpty)
            Center(
              child: Text(
                aboutTitle,
                style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack),
              ),
            ),
          if (aboutDesc.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(
              aboutDesc,
              style: TextStyle(
                  fontSize: 14.sp, color: AppColors.textGrey, height: 1.5),
            ),
          ],
          SizedBox(height: 24.h),
          if (data.about.content.isNotEmpty)
            Column(
              children: data.about.content
                  .where((e) =>
                      ((e.title ?? '').trim().isNotEmpty) ||
                      ((e.description ?? '').trim().isNotEmpty))
                  .map((e) => _buildSection(
                        (e.title ?? '').trim(),
                        (e.description ?? '').trim(),
                      ))
                  .toList(),
            ),
          SizedBox(height: 24.h),
          if (_hasAnySocial(data.social))
            _buildSocialSection(context, data.social),
          SizedBox(height: 24.h),
          if (_hasAnyStats(data.statistics))
            _buildStatsSection(context, data.statistics),
        ],
      ),
    );
  }

  bool _hasAnySocial(SocialLinks social) {
    return ((social.facebook ?? '').trim().isNotEmpty) ||
        ((social.instagram ?? '').trim().isNotEmpty) ||
        ((social.twitter ?? '').trim().isNotEmpty) ||
        ((social.linkedin ?? '').trim().isNotEmpty) ||
        ((social.youtube ?? '').trim().isNotEmpty);
  }

  bool _hasAnyStats(StatisticsSection statistics) {
    return ((statistics.tagline ?? '').trim().isNotEmpty) ||
        ((statistics.description ?? '').trim().isNotEmpty) ||
        (statistics.content.isNotEmpty);
  }

  Widget _buildSocialSection(BuildContext context, SocialLinks social) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('follow_us'.tr(context),
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack)),
        SizedBox(height: 16.h),
        Wrap(spacing: 16.w, runSpacing: 10.h, children: [
          if ((social.facebook ?? '').isNotEmpty)
            _buildSocialButton(context, 'assets/images/icons/fb.svg',
                'Facebook', social.facebook),
          if ((social.instagram ?? '').isNotEmpty)
            _buildSocialButton(context, 'assets/images/icons/ins.svg',
                'Instagram', social.instagram),
          if ((social.twitter ?? '').isNotEmpty)
            _buildSocialButton(context, 'assets/images/icons/x.svg', 'Twitter',
                social.twitter),
          if ((social.youtube ?? '').isNotEmpty)
            _buildSocialButton(context, 'assets/images/icons/yt.svg', 'YouTube',
                social.youtube),
          if ((social.linkedin ?? '').isNotEmpty)
            _buildSocialButton(context, 'assets/images/icons/in.svg',
                'LinkedIn', social.linkedin),
        ])
      ]),
    );
  }

  Widget _buildStatsSection(
      BuildContext context, StatisticsSection statistics) {
    final lang = Localizations.localeOf(context).languageCode;
    final tagline = lang == 'ar'
        ? (statistics.taglineAr ?? statistics.tagline ?? '')
        : (statistics.tagline ?? '');
    final desc = lang == 'ar'
        ? (statistics.descriptionAr ?? statistics.description ?? '')
        : (statistics.description ?? '');
    if (statistics.content.isEmpty && tagline.isEmpty && desc.isEmpty) {
      return const SizedBox();
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (tagline.isNotEmpty)
          Text(tagline,
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack)),
        if (desc.isNotEmpty) ...[
          SizedBox(height: 8.h),
          Text(desc,
              style: TextStyle(fontSize: 14.sp, color: AppColors.textGrey)),
        ],
        SizedBox(height: 12.h),
        if (statistics.content.isNotEmpty)
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: statistics.content
                .map(
                  (s) => Container(
                    width: 150.w,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.r),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Column(children: [
                      Text(s.stats ?? '',
                          style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary)),
                      SizedBox(height: 4.h),
                      Text(
                          (lang == 'ar'
                              ? (s.titleAr ?? s.title ?? '')
                              : (s.title ?? '')),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12.sp, color: AppColors.textGrey)),
                    ]),
                  ),
                )
                .toList(),
          )
      ]),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            content,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textGrey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(
      BuildContext context, String assetPath, String platform, String? url) {
    return InkWell(
      borderRadius: BorderRadius.circular(28.r),
      onTap: () => launchCustomUrl(context, url),
      child: Column(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                assetPath,
                width: 24.w,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            platform,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}

