import 'package:flutter/material.dart';
import 'package:dots/generated/l10n.dart';

class LocalizationHelper {
  static String getLocalizedString(BuildContext context, String code, {bool isModule = false}) {
    switch (code) {
      case 'ar':
        return isModule ? S.of(context).ArabicM : S.of(context).Arabic;
      case 'ar_EG':
        return S.of(context).EgyptianArabic;
      case 'en':
        return isModule ? S.of(context).EnglishM : S.of(context).English;
      case 'fr':
        return isModule ? S.of(context).FrenchM : S.of(context).French;
      case 'zh':
        return isModule ? S.of(context).MandarinChineseM : S.of(context).MandarinChinese;
      case 'hi':
        return isModule ? S.of(context).HindiM : S.of(context).Hindi;
      case 'es':
        return isModule ? S.of(context).SpanishM : S.of(context).Spanish;
      case 'bn':
        return isModule ? S.of(context).BengaliM : S.of(context).Bengali;
      case 'pt':
        return isModule ? S.of(context).PortugueseM : S.of(context).Portuguese;
      case 'ru':
        return isModule ? S.of(context).RussianM : S.of(context).Russian;
      case 'ur':
        return isModule ? S.of(context).UrduM : S.of(context).Urdu;
      case 'de':
        return isModule ? S.of(context).GermanM : S.of(context).German;
      default:
        return code;
    }
  }
}
