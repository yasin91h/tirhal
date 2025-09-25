import 'package:flutter/material.dart';
import 'package:tirhal/core/localization/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  /// Easy access to localized strings
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Check if current locale is RTL
  bool get isRTL => Localizations.localeOf(this).languageCode == 'ar';

  /// Get text direction based on locale
  TextDirection get textDirection =>
      isRTL ? TextDirection.rtl : TextDirection.ltr;
}
