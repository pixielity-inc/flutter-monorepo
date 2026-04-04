/// Abstract contract for the localization service.
abstract interface class LocalizationContract {
  /// The currently active locale (e.g. 'en', 'fr').
  String get locale;

  /// Translate a [key] with optional named [args] for interpolation.
  String translate(String key, {Map<String, String>? args});

  /// Set the active locale to [locale].
  Future<void> setLocale(String locale);

  /// Returns true if a translation exists for [key] in the current locale.
  bool has(String key);
}
