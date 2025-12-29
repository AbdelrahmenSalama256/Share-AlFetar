import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const localizationsDelegatesList = [
  GlobalMaterialLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  AppLocalizations.delegate,
];

const supportedLocalesList = [
  Locale('ar', "EG"),
  Locale('en', "US"),
];
