//! About models
class AboutContentItem {
  final String? icon;
  final String? title;
  final String? description;
  AboutContentItem({this.icon, this.title, this.description});
  factory AboutContentItem.fromJson(Map<String, dynamic> json) => AboutContentItem(
        icon: json['icon']?.toString(),
        title: json['title']?.toString(),
        description: json['description']?.toString(),
      );
}

class AboutSection {
  final String? title;
  final String? titleAr;
  final String? description;
  final String? descriptionAr;
  final List<AboutContentItem> content;
  AboutSection({this.title, this.titleAr, this.description, this.descriptionAr, this.content = const []});
  factory AboutSection.fromJson(Map<String, dynamic> json) => AboutSection(
        title: json['title']?.toString(),
        titleAr: json['title_ar']?.toString(),
        description: json['description']?.toString(),
        descriptionAr: json['description_ar']?.toString(),
        content: (json['content'] as List?)
                ?.map((e) => AboutContentItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}

class SocialLinks {
  final String? facebook;
  final String? instagram;
  final String? twitter;
  final String? linkedin;
  final String? youtube;
  SocialLinks({this.facebook, this.instagram, this.twitter, this.linkedin, this.youtube});
  factory SocialLinks.fromJson(Map<String, dynamic> json) => SocialLinks(
        facebook: json['facebook']?.toString(),
        instagram: json['instagram']?.toString(),
        twitter: json['twitter']?.toString(),
        linkedin: json['linkedin']?.toString(),
        youtube: json['youtube']?.toString(),
      );
}

class StatisticItem {
  final String? stats;
  final String? title;
  final String? titleAr;
  StatisticItem({this.stats, this.title, this.titleAr});
  factory StatisticItem.fromJson(Map<String, dynamic> json) => StatisticItem(
        stats: json['stats']?.toString(),
        title: json['title']?.toString(),
        titleAr: json['title_ar']?.toString(),
      );
}

class StatisticsSection {
  final String? tagline;
  final String? taglineAr;
  final String? description;
  final String? descriptionAr;
  final List<StatisticItem> content;
  StatisticsSection({this.tagline, this.taglineAr, this.description, this.descriptionAr, this.content = const []});
  factory StatisticsSection.fromJson(Map<String, dynamic> json) => StatisticsSection(
        tagline: json['tagline']?.toString(),
        taglineAr: json['tagline_ar']?.toString(),
        description: json['description']?.toString(),
        descriptionAr: json['description_ar']?.toString(),
        content: (json['content'] as List?)
                ?.map((e) => StatisticItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}

class AboutResponse {
  final AboutSection about;
  final SocialLinks social;
  final StatisticsSection statistics;
  AboutResponse({required this.about, required this.social, required this.statistics});
  factory AboutResponse.fromJson(Map<String, dynamic> json) => AboutResponse(
        about: AboutSection.fromJson((json['about'] as Map<String, dynamic>? ?? {})),
        social: SocialLinks.fromJson((json['social'] as Map<String, dynamic>? ?? {})),
        statistics: StatisticsSection.fromJson((json['statistics'] as Map<String, dynamic>? ?? {})),
      );
}

