import 'package:universal_io/io.dart';

Map<String, String> languagesDictionary = {
  "en": "English",
  "fr": "Français",
  "es": "Español",
  "zh": "中文",
  "hi": "हिन्दी",
  "ar": "العربية",
  "pt": "Português",
  "ru": "Русский",
  "ja": "日本語",
  "de": "Deutsch",
  "ko": "한국어",
  "tr": "Türkçe",
  "it": "Italiano",
  "vi": "Tiếng Việt",
  "pl": "Polski",
  "nl": "Nederlands",
  "th": "ไทย",
  "cs": "Čeština"
};

String? getDeviceLanguage() {
  try {
    if (languagesDictionary[Platform.localeName.split("_")[0]] != null) {
      return Platform.localeName.split("_")[0];
    }
  } catch (e) {
    return "en";
  }
  return null;
}
