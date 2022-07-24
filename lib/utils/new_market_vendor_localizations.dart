import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

 class NewMarkitVendorLocalizations {
   NewMarkitVendorLocalizations(this.locale);

  final Locale locale;

  static NewMarkitVendorLocalizations? of(BuildContext context) {
    return Localizations.of<NewMarkitVendorLocalizations>(
        context, NewMarkitVendorLocalizations);
  }

  static  Map<String, Map<String, String>> _localizedValues =new  Map();

  Future<bool> load() async {
    String data =
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> _result = jsonDecode(data);
    Map<String, String> _values = new Map();

    _result.forEach((String key, dynamic value) {
      _values[key] = value.toString();
    });
    _localizedValues[this.locale.languageCode] = _values;
    return true;
  }

  String find(String key) {
    return _localizedValues[locale.languageCode]![key] ?? '';
  }
}

class NewMarkitVendorLocalizationsDelegate
    extends LocalizationsDelegate<NewMarkitVendorLocalizations> {
  const NewMarkitVendorLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en'].contains(locale.languageCode);

  @override
  Future<NewMarkitVendorLocalizations> load(Locale locale) async {
    NewMarkitVendorLocalizations localizations =  NewMarkitVendorLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(NewMarkitVendorLocalizationsDelegate old) => false;
}
