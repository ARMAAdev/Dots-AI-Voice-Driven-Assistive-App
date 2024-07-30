// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `images/dots.png`
  String get dotslogo {
    return Intl.message(
      'images/dots.png',
      name: 'dotslogo',
      desc: '',
      args: [],
    );
  }

  /// `Dots`
  String get appTitle {
    return Intl.message(
      'Dots',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to dots`
  String get item1Header {
    return Intl.message(
      'Welcome to dots',
      name: 'item1Header',
      desc: '',
      args: [],
    );
  }

  /// `Braille at Your Fingertips`
  String get item1Description {
    return Intl.message(
      'Braille at Your Fingertips',
      name: 'item1Description',
      desc: '',
      args: [],
    );
  }

  /// `Transcribe`
  String get item2Header {
    return Intl.message(
      'Transcribe',
      name: 'item2Header',
      desc: '',
      args: [],
    );
  }

  /// `Capture braille characters using your device's camera and transcribe them into plain text.`
  String get item2Description {
    return Intl.message(
      'Capture braille characters using your device\'s camera and transcribe them into plain text.',
      name: 'item2Description',
      desc: '',
      args: [],
    );
  }

  /// `Translate`
  String get item3Header {
    return Intl.message(
      'Translate',
      name: 'item3Header',
      desc: '',
      args: [],
    );
  }

  /// `Translate the transcribed braille text into your preferred language for better understanding.`
  String get item3Description {
    return Intl.message(
      'Translate the transcribed braille text into your preferred language for better understanding.',
      name: 'item3Description',
      desc: '',
      args: [],
    );
  }

  /// `Read`
  String get item4Header {
    return Intl.message(
      'Read',
      name: 'item4Header',
      desc: '',
      args: [],
    );
  }

  /// `Convert the translated text into speech and listen to it read aloud for accessibility.`
  String get item4Description {
    return Intl.message(
      'Convert the translated text into speech and listen to it read aloud for accessibility.',
      name: 'item4Description',
      desc: '',
      args: [],
    );
  }

  /// `Listen`
  String get item5Header {
    return Intl.message(
      'Listen',
      name: 'item5Header',
      desc: '',
      args: [],
    );
  }

  /// `Enjoy the convenience of having braille content read to you in your preferred language.`
  String get item5Description {
    return Intl.message(
      'Enjoy the convenience of having braille content read to you in your preferred language.',
      name: 'item5Description',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get GetStarted {
    return Intl.message(
      'Get Started',
      name: 'GetStarted',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get Home {
    return Intl.message(
      'Home',
      name: 'Home',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get History {
    return Intl.message(
      'History',
      name: 'History',
      desc: '',
      args: [],
    );
  }

  /// `Braille Translation`
  String get BrailleTranslation {
    return Intl.message(
      'Braille Translation',
      name: 'BrailleTranslation',
      desc: '',
      args: [],
    );
  }

  /// `Vision`
  String get Vision {
    return Intl.message(
      'Vision',
      name: 'Vision',
      desc: '',
      args: [],
    );
  }

  /// `Reader`
  String get Reader {
    return Intl.message(
      'Reader',
      name: 'Reader',
      desc: '',
      args: [],
    );
  }

  /// `Read & Translate`
  String get ReadTranslate {
    return Intl.message(
      'Read & Translate',
      name: 'ReadTranslate',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get Settings {
    return Intl.message(
      'Settings',
      name: 'Settings',
      desc: '',
      args: [],
    );
  }

  /// `Speech`
  String get Speech {
    return Intl.message(
      'Speech',
      name: 'Speech',
      desc: '',
      args: [],
    );
  }

  /// `Braille`
  String get Braille {
    return Intl.message(
      'Braille',
      name: 'Braille',
      desc: '',
      args: [],
    );
  }

  /// `عربي`
  String get Arabic {
    return Intl.message(
      'عربي',
      name: 'Arabic',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get English {
    return Intl.message(
      'English',
      name: 'English',
      desc: '',
      args: [],
    );
  }

  /// `Française`
  String get French {
    return Intl.message(
      'Française',
      name: 'French',
      desc: '',
      args: [],
    );
  }

  /// `普通话`
  String get MandarinChinese {
    return Intl.message(
      '普通话',
      name: 'MandarinChinese',
      desc: '',
      args: [],
    );
  }

  /// `हिंदी`
  String get Hindi {
    return Intl.message(
      'हिंदी',
      name: 'Hindi',
      desc: '',
      args: [],
    );
  }

  /// `española`
  String get Spanish {
    return Intl.message(
      'española',
      name: 'Spanish',
      desc: '',
      args: [],
    );
  }

  /// `বাংলা`
  String get Bengali {
    return Intl.message(
      'বাংলা',
      name: 'Bengali',
      desc: '',
      args: [],
    );
  }

  /// `Português`
  String get Portuguese {
    return Intl.message(
      'Português',
      name: 'Portuguese',
      desc: '',
      args: [],
    );
  }

  /// `русский`
  String get Russian {
    return Intl.message(
      'русский',
      name: 'Russian',
      desc: '',
      args: [],
    );
  }

  /// `اردو`
  String get Urdu {
    return Intl.message(
      'اردو',
      name: 'Urdu',
      desc: '',
      args: [],
    );
  }

  /// `Deutsch`
  String get German {
    return Intl.message(
      'Deutsch',
      name: 'German',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get ArabicM {
    return Intl.message(
      'Arabic',
      name: 'ArabicM',
      desc: '',
      args: [],
    );
  }

  /// `Egyptian Arabic`
  String get EgyptianArabic {
    return Intl.message(
      'Egyptian Arabic',
      name: 'EgyptianArabic',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get EnglishM {
    return Intl.message(
      'English',
      name: 'EnglishM',
      desc: '',
      args: [],
    );
  }

  /// `French`
  String get FrenchM {
    return Intl.message(
      'French',
      name: 'FrenchM',
      desc: '',
      args: [],
    );
  }

  /// `Mandarin Chinese`
  String get MandarinChineseM {
    return Intl.message(
      'Mandarin Chinese',
      name: 'MandarinChineseM',
      desc: '',
      args: [],
    );
  }

  /// `Hindi`
  String get HindiM {
    return Intl.message(
      'Hindi',
      name: 'HindiM',
      desc: '',
      args: [],
    );
  }

  /// `Spanish`
  String get SpanishM {
    return Intl.message(
      'Spanish',
      name: 'SpanishM',
      desc: '',
      args: [],
    );
  }

  /// `Bengali`
  String get BengaliM {
    return Intl.message(
      'Bengali',
      name: 'BengaliM',
      desc: '',
      args: [],
    );
  }

  /// `Portuguese`
  String get PortugueseM {
    return Intl.message(
      'Portuguese',
      name: 'PortugueseM',
      desc: '',
      args: [],
    );
  }

  /// `Russian`
  String get RussianM {
    return Intl.message(
      'Russian',
      name: 'RussianM',
      desc: '',
      args: [],
    );
  }

  /// `Urdu`
  String get UrduM {
    return Intl.message(
      'Urdu',
      name: 'UrduM',
      desc: '',
      args: [],
    );
  }

  /// `German`
  String get GermanM {
    return Intl.message(
      'German',
      name: 'GermanM',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get CameraBT {
    return Intl.message(
      'Camera',
      name: 'CameraBT',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get GalleryBT {
    return Intl.message(
      'Gallery',
      name: 'GalleryBT',
      desc: '',
      args: [],
    );
  }

  /// `Braille-Unicode`
  String get BrailleUnicode {
    return Intl.message(
      'Braille-Unicode',
      name: 'BrailleUnicode',
      desc: '',
      args: [],
    );
  }

  /// `Translation`
  String get Translation {
    return Intl.message(
      'Translation',
      name: 'Translation',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get Copy {
    return Intl.message(
      'Copy',
      name: 'Copy',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get Share {
    return Intl.message(
      'Share',
      name: 'Share',
      desc: '',
      args: [],
    );
  }

  /// `Play audio`
  String get PlayAudio {
    return Intl.message(
      'Play audio',
      name: 'PlayAudio',
      desc: '',
      args: [],
    );
  }

  /// `Text copied to the clipboard`
  String get Textcopiedtoclipboard {
    return Intl.message(
      'Text copied to the clipboard',
      name: 'Textcopiedtoclipboard',
      desc: '',
      args: [],
    );
  }

  /// `Extracted Text`
  String get ExtractedText {
    return Intl.message(
      'Extracted Text',
      name: 'ExtractedText',
      desc: '',
      args: [],
    );
  }

  /// `Select App Language`
  String get SelectAppLang {
    return Intl.message(
      'Select App Language',
      name: 'SelectAppLang',
      desc: '',
      args: [],
    );
  }

  /// `FAQ`
  String get FAQ {
    return Intl.message(
      'FAQ',
      name: 'FAQ',
      desc: '',
      args: [],
    );
  }

  /// `Upload and Analyze`
  String get uploadVision {
    return Intl.message(
      'Upload and Analyze',
      name: 'uploadVision',
      desc: '',
      args: [],
    );
  }

  /// `Upload and Translate`
  String get uploadBT {
    return Intl.message(
      'Upload and Translate',
      name: 'uploadBT',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get SettingsTitle {
    return Intl.message(
      'Settings',
      name: 'SettingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `APP Language`
  String get AppLangSub {
    return Intl.message(
      'APP Language',
      name: 'AppLangSub',
      desc: '',
      args: [],
    );
  }

  /// `Defult Language`
  String get DefultLangBT {
    return Intl.message(
      'Defult Language',
      name: 'DefultLangBT',
      desc: '',
      args: [],
    );
  }

  /// `Defult Module Language`
  String get DefultModLangBT {
    return Intl.message(
      'Defult Module Language',
      name: 'DefultModLangBT',
      desc: '',
      args: [],
    );
  }

  /// `Speech Output`
  String get SpeechOutSub {
    return Intl.message(
      'Speech Output',
      name: 'SpeechOutSub',
      desc: '',
      args: [],
    );
  }

  /// `Male Voice`
  String get MaleVRB {
    return Intl.message(
      'Male Voice',
      name: 'MaleVRB',
      desc: '',
      args: [],
    );
  }

  /// `Female Voice`
  String get FemalVRB {
    return Intl.message(
      'Female Voice',
      name: 'FemalVRB',
      desc: '',
      args: [],
    );
  }

  /// `Support`
  String get SuppSub {
    return Intl.message(
      'Support',
      name: 'SuppSub',
      desc: '',
      args: [],
    );
  }

  /// `Send Feedback`
  String get SendFeedBT {
    return Intl.message(
      'Send Feedback',
      name: 'SendFeedBT',
      desc: '',
      args: [],
    );
  }

  /// `Report A Bug`
  String get RepABugBT {
    return Intl.message(
      'Report A Bug',
      name: 'RepABugBT',
      desc: '',
      args: [],
    );
  }

  /// `SelectVision`
  String get SelectVision {
    return Intl.message(
      'SelectVision',
      name: 'SelectVision',
      desc: '',
      args: [],
    );
  }

  /// `SelectBraille`
  String get SelectBraille {
    return Intl.message(
      'SelectBraille',
      name: 'SelectBraille',
      desc: '',
      args: [],
    );
  }

  /// `Select Reader`
  String get SelectReader {
    return Intl.message(
      'Select Reader',
      name: 'SelectReader',
      desc: '',
      args: [],
    );
  }

  /// `How do I use the Vision module?`
  String get question1 {
    return Intl.message(
      'How do I use the Vision module?',
      name: 'question1',
      desc: '',
      args: [],
    );
  }

  /// `To use the Vision module, simply tap on the Vision icon in the main menu. Point your device's camera at the object or whatever you want to analyze and the app will provide comprehensive analysis about it.`
  String get answer1 {
    return Intl.message(
      'To use the Vision module, simply tap on the Vision icon in the main menu. Point your device\'s camera at the object or whatever you want to analyze and the app will provide comprehensive analysis about it.',
      name: 'answer1',
      desc: '',
      args: [],
    );
  }

  /// `How do I translate text to Braille?`
  String get question2 {
    return Intl.message(
      'How do I translate text to Braille?',
      name: 'question2',
      desc: '',
      args: [],
    );
  }

  /// `To translate text to Braille, go to the Braille Translate module from the main menu. Scan the braille you want to translate, and the app will display the corresponding text translation in your desired language.`
  String get answer2 {
    return Intl.message(
      'To translate text to Braille, go to the Braille Translate module from the main menu. Scan the braille you want to translate, and the app will display the corresponding text translation in your desired language.',
      name: 'answer2',
      desc: '',
      args: [],
    );
  }

  /// `How can I change the app language?`
  String get question3 {
    return Intl.message(
      'How can I change the app language?',
      name: 'question3',
      desc: '',
      args: [],
    );
  }

  /// `To change the app language, go to the Settings page and tap on the 'App Language' option. Select your preferred language from the list, and the app will update its language accordingly.`
  String get answer3 {
    return Intl.message(
      'To change the app language, go to the Settings page and tap on the \'App Language\' option. Select your preferred language from the list, and the app will update its language accordingly.',
      name: 'answer3',
      desc: '',
      args: [],
    );
  }

  /// `Can I customize the speech output voice?`
  String get question4 {
    return Intl.message(
      'Can I customize the speech output voice?',
      name: 'question4',
      desc: '',
      args: [],
    );
  }

  /// `Yes, you can customize the speech output voice in the Settings page. Under the 'Speech Output' section, you can toggle between a male and female voice.`
  String get answer4 {
    return Intl.message(
      'Yes, you can customize the speech output voice in the Settings page. Under the \'Speech Output\' section, you can toggle between a male and female voice.',
      name: 'answer4',
      desc: '',
      args: [],
    );
  }

  /// `How can I provide feedback or report a bug?`
  String get question5 {
    return Intl.message(
      'How can I provide feedback or report a bug?',
      name: 'question5',
      desc: '',
      args: [],
    );
  }

  /// `To provide feedback or report a bug, go to the Settings page and tap on either the 'Send Feedback' or 'Report a Bug' option. Fill in the necessary details and submit your feedback or bug report.`
  String get answer5 {
    return Intl.message(
      'To provide feedback or report a bug, go to the Settings page and tap on either the \'Send Feedback\' or \'Report a Bug\' option. Fill in the necessary details and submit your feedback or bug report.',
      name: 'answer5',
      desc: '',
      args: [],
    );
  }

  /// `Is my data secure when using this app?`
  String get question6 {
    return Intl.message(
      'Is my data secure when using this app?',
      name: 'question6',
      desc: '',
      args: [],
    );
  }

  /// `Yes, we take data security and privacy seriously. All data processed by the app is kept strictly confidential and is not shared with any third parties.`
  String get answer6 {
    return Intl.message(
      'Yes, we take data security and privacy seriously. All data processed by the app is kept strictly confidential and is not shared with any third parties.',
      name: 'answer6',
      desc: '',
      args: [],
    );
  }

  /// `Can I use this app offline?`
  String get question7 {
    return Intl.message(
      'Can I use this app offline?',
      name: 'question7',
      desc: '',
      args: [],
    );
  }

  /// `All of the app"s modules, including Vision, Braille Translate, and Reader, require an active internet connection to function properly. This is because the app relies on cloud-based services to process and provide accurate results. However, you can still open the app and access your previous history while offline. This means you can view your past scans, translations, and other data without an internet connection. Keep in mind that performing new scans, translations, or accessing any features that require real-time processing will not be possible offline.`
  String get answer7 {
    return Intl.message(
      'All of the app"s modules, including Vision, Braille Translate, and Reader, require an active internet connection to function properly. This is because the app relies on cloud-based services to process and provide accurate results. However, you can still open the app and access your previous history while offline. This means you can view your past scans, translations, and other data without an internet connection. Keep in mind that performing new scans, translations, or accessing any features that require real-time processing will not be possible offline.',
      name: 'answer7',
      desc: '',
      args: [],
    );
  }

  /// `How often is the app updated with new features?`
  String get question8 {
    return Intl.message(
      'How often is the app updated with new features?',
      name: 'question8',
      desc: '',
      args: [],
    );
  }

  /// `We regularly update the app with new features and improvements based on user feedback and technological advancements. Keep an eye out for app updates to access the latest features.`
  String get answer8 {
    return Intl.message(
      'We regularly update the app with new features and improvements based on user feedback and technological advancements. Keep an eye out for app updates to access the latest features.',
      name: 'answer8',
      desc: '',
      args: [],
    );
  }

  /// `Is the app available in multiple languages?`
  String get question9 {
    return Intl.message(
      'Is the app available in multiple languages?',
      name: 'question9',
      desc: '',
      args: [],
    );
  }

  /// `Yes, the app supports multiple languages. You can change the app language in the Settings page to your preferred language.`
  String get answer9 {
    return Intl.message(
      'Yes, the app supports multiple languages. You can change the app language in the Settings page to your preferred language.',
      name: 'answer9',
      desc: '',
      args: [],
    );
  }

  /// `How can I contact support if I need further assistance?`
  String get question10 {
    return Intl.message(
      'How can I contact support if I need further assistance?',
      name: 'question10',
      desc: '',
      args: [],
    );
  }

  /// `If you need further assistance or have any question's, you can contact our support team by sending an email to dotsapp@gmail.com, We'll be happy to help you!`
  String get answer10 {
    return Intl.message(
      'If you need further assistance or have any question\'s, you can contact our support team by sending an email to dotsapp@gmail.com, We\'ll be happy to help you!',
      name: 'answer10',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'bn'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'pt'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'ur'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
