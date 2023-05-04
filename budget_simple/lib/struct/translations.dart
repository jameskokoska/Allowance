import 'dart:async';
import 'dart:convert';
import 'package:budget_simple/struct/database_global.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, dynamic>> openAppTranslations() async {
  String input = await rootBundle
      .loadString("assets/translations/translationsAppKeyed.json");
  dynamic map = jsonDecode(input);
  return map;
}

String translateText(String string) {
  const String sheet = "Sheet1";
  String locale = "en";
  if (language.startsWith("en")) {
    locale = "en";
  } else if (language.startsWith("fr")) {
    locale = "fr";
  } else if (language.startsWith("es")) {
    locale = "es";
  } else if (language.startsWith("zh")) {
    locale = "zh";
  } else if (language.startsWith("hi")) {
    locale = "hi";
  } else if (language.startsWith("ar")) {
    locale = "ar";
  } else if (language.startsWith("pt")) {
    locale = "pt";
  } else if (language.startsWith("ru")) {
    locale = "ru";
  } else if (language.startsWith("ja")) {
    locale = "ja";
  } else if (language.startsWith("de")) {
    locale = "de";
  } else if (language.startsWith("ko")) {
    locale = "ko";
  } else if (language.startsWith("tr")) {
    locale = "tr";
  } else if (language.startsWith("it")) {
    locale = "it";
  } else if (language.startsWith("vi")) {
    locale = "vi";
  } else if (language.startsWith("pl")) {
    locale = "pl";
  } else if (language.startsWith("nl")) {
    locale = "nl";
  } else if (language.startsWith("th")) {
    locale = "th";
  } else if (language.startsWith("cs")) {
    locale = "cs";
  }
  if (dataSetTranslationsApp[sheet] != null &&
      dataSetTranslationsApp[sheet][string] != null &&
      dataSetTranslationsApp[sheet][string][locale] != null) {
    return dataSetTranslationsApp[sheet][string][locale];
  }
  return string;
}
