//! AppSettings
class AppSettings {
  final String? name;
  final String? email;
  final String? currency; // symbol
  final String? logoUrl;

  AppSettings({this.name, this.email, this.currency, this.logoUrl});

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return AppSettings(
      name: data['name']?.toString(),
      email: data['email']?.toString(),
      currency: data['currency']?.toString(),
      logoUrl: data['logo_url']?.toString(),
    );
  }
}

