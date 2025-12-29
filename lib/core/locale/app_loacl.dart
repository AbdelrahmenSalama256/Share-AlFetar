import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//! AppLocalizations
class AppLocalizations {
  final Locale? locale;
  AppLocalizations({this.locale});
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalDelegate();
  static const String _path = 'assets/translations/';

  late Map<String, String> _localStrings;
  Map<String, String>? _fallbackEnStrings;

  Future loadJsonFiles() async {
    final langCode = locale!.languageCode;
    final currentRaw = await rootBundle.loadString("$_path$langCode.json");
    final currentMap = jsonDecode(currentRaw) as Map<String, dynamic>;
    _localStrings = currentMap.map((k, v) => MapEntry(k, v.toString()));

    if (langCode != 'en') {
      try {
        final enRaw = await rootBundle.loadString("${_path}en.json");
        final enMap = jsonDecode(enRaw) as Map<String, dynamic>;
        _fallbackEnStrings = enMap.map((k, v) => MapEntry(k, v.toString()));
      } catch (_) {
        _fallbackEnStrings = null;
      }
    }
  }

  String translate(String key) {
    final value = _localStrings[key];
    if (value == null || value.trim().isEmpty || value.contains('\uFFFD')) {
      // Fallback to English if available
      final fb = _fallbackEnStrings?[key];
      if (fb != null && fb.trim().isNotEmpty) return fb;
      return key;
    }
    return value;
  }
}

//! _AppLocalDelegate
class _AppLocalDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalDelegate();
  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations appLocal = AppLocalizations(locale: locale);
    await appLocal.loadJsonFiles();
    return appLocal;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<dynamic> old) {
    return false;
  }
}

extension TranslateString on String {
  String tr(BuildContext context) {
    if (AppLocalizations.of(context) != null) {
      return AppLocalizations.of(context)!.translate(this);
    } else {
      return "";
    }
  }
}
