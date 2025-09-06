import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:manzoma/core/localization/app_localizations.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<FlutterLocalization> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => [kEN, kAR].contains(locale.languageCode);

  @override
  Future<FlutterLocalization> load(Locale locale) async {
    final enJson = await rootBundle.loadString('lib/core/localization/en.json');
    final arJson = await rootBundle.loadString('lib/core/localization/ar.json');

    final localization = FlutterLocalization.instance;
    localization.init(
      mapLocales: [
        MapLocale(kEN, jsonDecode(enJson)),
        MapLocale(kAR, jsonDecode(arJson)),
      ],
      initLanguageCode: locale.languageCode,
    );
    return localization;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<FlutterLocalization> old) => false;
}
