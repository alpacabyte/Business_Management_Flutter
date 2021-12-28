import 'package:flutter/material.dart';

class LocalizationData extends ChangeNotifier {
  Locale? _locale;
  String localeName = "tr";

  void changeLocale(Locales locales) {
    if (locales == Locales.en) {
      _locale = const Locale("en");
      localeName = "en";
    } else if (locales == Locales.tr) {
      _locale = const Locale("tr");
      localeName = "tr";
    }

    notifyListeners();
  }

  Locale? get locale => _locale;
}

enum Locales {
  tr,
  en,
}
