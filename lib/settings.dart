import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'faq_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dots/generated/l10n.dart';
import 'localization_helper.dart'; // Import the helper

import 'main.dart';

class AppLanguageSettings with ChangeNotifier {
  Locale _selectedLocale = Locale('en', '');
  List<Map<String, String>> _appLanguages = [
    {'name': 'Arabic', 'code': 'ar'},
    {'name': 'English', 'code': 'en'},
    {'name': 'French', 'code': 'fr'},
    {'name': 'Mandarin Chinese', 'code': 'zh'},
    {'name': 'Hindi', 'code': 'hi'},
    {'name': 'Spanish', 'code': 'es'},
    {'name': 'Bengali', 'code': 'bn'},
    {'name': 'Portuguese', 'code': 'pt'},
    {'name': 'Russian', 'code': 'ru'},
    {'name': 'Urdu', 'code': 'ur'},
    {'name': 'German', 'code': 'de'},
  ];

  Locale get selectedLocale => _selectedLocale;
  String get selectedLanguageCode => _selectedLocale.languageCode;
  List<Map<String, String>> get appLanguages => _appLanguages;

  void setLocale(String languageCode) {
    _selectedLocale = Locale(languageCode, '');
    saveSettings();
    notifyListeners();
  }

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('selected_language_code');
    if (languageCode != null) {
      _selectedLocale = Locale(languageCode, '');
      notifyListeners();
    }
  }

  Future<void> saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language_code', _selectedLocale.languageCode);
  }
}

class VoiceSettings with ChangeNotifier {
  bool _isMaleVoice = true;

  bool get isMaleVoice => _isMaleVoice;

  void toggleVoice(bool value) {
    _isMaleVoice = value;
    saveSettings();
    notifyListeners();
  }
  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isMaleVoice = prefs.getBool('is_male_voice') ?? true;
    notifyListeners();
  }

  Future<void> saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_male_voice', _isMaleVoice);
  }
}

class VisionLanguageSettings with ChangeNotifier {
  String _selectedVisionLanguageCode = 'en';
  List<Map<String, String>> _visionLanguages = [
    {'name': 'Arabic', 'code': 'ar'},
    {'name': 'Egyptian Arabic', 'code': 'ar_EG'},
    {'name': 'English', 'code': 'en'},
    {'name': 'French', 'code': 'fr'},
    {'name': 'Mandarin Chinese', 'code': 'zh'},
    {'name': 'Hindi', 'code': 'hi'},
    {'name': 'Spanish', 'code': 'es'},
    {'name': 'Bengali', 'code': 'bn'},
    {'name': 'Portuguese', 'code': 'pt'},
    {'name': 'Russian', 'code': 'ru'},
    {'name': 'Urdu', 'code': 'ur'},
    {'name': 'German', 'code': 'de'},
  ];

  String get selectedVisionLanguageCode => _selectedVisionLanguageCode;

  String get selectedVisionLanguageName {
    return _visionLanguages
        .firstWhere(
          (lang) => lang['code'] == _selectedVisionLanguageCode,
      orElse: () => {'name': 'English'},
    )['name']!;
  }

  List<Map<String, String>> get visionLanguages => _visionLanguages;

  void setVisionLanguage(String languageCode) {
    _selectedVisionLanguageCode = languageCode;
    saveSettings();
    notifyListeners();
  }

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedVisionLanguageCode = prefs.getString('vision_language') ?? 'en';
    notifyListeners();
  }

  Future<void> saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('vision_language', _selectedVisionLanguageCode);
  }
}


class ReaderLanguageSettings with ChangeNotifier {
  String _selectedReaderLanguageCode = 'en';
  List<Map<String, String>> _readerLanguages = [
    {'name': 'Arabic', 'code': 'ar'},
    {'name': 'Egyptian Arabic', 'code': 'ar_EG'},
    {'name': 'English', 'code': 'en'},
    {'name': 'French', 'code': 'fr'},
    {'name': 'Mandarin Chinese', 'code': 'zh'},
    {'name': 'Hindi', 'code': 'hi'},
    {'name': 'Spanish', 'code': 'es'},
    {'name': 'Bengali', 'code': 'bn'},
    {'name': 'Portuguese', 'code': 'pt'},
    {'name': 'Russian', 'code': 'ru'},
    {'name': 'Urdu', 'code': 'ur'},
    {'name': 'German', 'code': 'de'},
  ];

  String get selectedReaderLanguageCode => _selectedReaderLanguageCode;

  String get selectedReaderLanguageName {
    return _readerLanguages
        .firstWhere(
          (lang) => lang['code'] == _selectedReaderLanguageCode,
      orElse: () => {'name': 'English'},
    )['name']!;
  }

  List<Map<String, String>> get readerLanguages => _readerLanguages;

  void setReaderLanguage(String languageCode) {
    _selectedReaderLanguageCode = languageCode;
    saveSettings();
    notifyListeners();
  }

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedReaderLanguageCode = prefs.getString('reader_language') ?? 'en';
    notifyListeners();
  }

  Future<void> saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('reader_language', _selectedReaderLanguageCode);
  }
}


class BrailleLanguageSettings with ChangeNotifier {
  String _selectedBrailleLanguageCode = 'en';
  List<Map<String, String>> _brailleLanguages = [
    {'name': 'Arabic', 'code': 'ar', 'flag': 'images/united-arab-emirates.png'},
    {'name': 'Egyptian Arabic', 'code': 'ar_EG', 'flag': 'images/egypt.png'},
    {'name': 'English', 'code': 'en', 'flag': 'images/united-kingdom.png'},
    {'name': 'French', 'code': 'fr', 'flag': 'images/france.png'},
    {'name': 'Mandarin Chinese', 'code': 'zh', 'flag': 'images/china.png'},
    {'name': 'Hindi', 'code': 'hi', 'flag': 'images/india.png'},
    {'name': 'Spanish', 'code': 'es', 'flag': 'images/spain.png'},
    {'name': 'Bengali', 'code': 'bn', 'flag': 'images/bangladesh.png'},
    {'name': 'Portuguese', 'code': 'pt', 'flag': 'images/portugal.png'},
    {'name': 'Russian', 'code': 'ru', 'flag': 'images/russia.png'},
    {'name': 'Urdu', 'code': 'ur', 'flag': 'images/pakistan.png'},
    {'name': 'German', 'code': 'de', 'flag': 'images/germany.png'},
  ];

  String get selectedBrailleLanguageCode => _selectedBrailleLanguageCode;

  String get selectedBrailleLanguageName {
    return _brailleLanguages
        .firstWhere(
          (lang) => lang['code'] == _selectedBrailleLanguageCode,
      orElse: () => {'name': 'English'},
    )['name']!;
  }

  List<Map<String, String>> get brailleLanguages => _brailleLanguages;

  void setBrailleLanguage(String languageCode) {
    _selectedBrailleLanguageCode = languageCode;
    saveSettings();
    notifyListeners();
  }

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedBrailleLanguageCode = prefs.getString('braille_language') ?? 'en';
    notifyListeners();
  }

  Future<void> saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('braille_language', _selectedBrailleLanguageCode);
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    // Reload settings when the app language changes
    Provider.of<AppLanguageSettings>(context, listen: false).addListener(_reloadSettings);
  }

  @override
  void dispose() {
    // Remove listener to avoid memory leaks
    Provider.of<AppLanguageSettings>(context, listen: false).removeListener(_reloadSettings);
    super.dispose();
  }

  void _reloadSettings() {
    setState(() {
      // This will rebuild the UI and update the language settings display
    });
  }


  @override
  Widget build(BuildContext context) {
    final appLanguages = [
      {'name': S.of(context).Arabic, 'code': 'ar'},
      {'name': S.of(context).English, 'code': 'en'},
      {'name': S.of(context).French, 'code': 'fr'},
      {'name': S.of(context).MandarinChinese, 'code': 'zh'},
      {'name': S.of(context).Hindi, 'code': 'hi'},
      {'name': S.of(context).Spanish, 'code': 'es'},
      {'name': S.of(context).Bengali, 'code': 'bn'},
      {'name': S.of(context).Portuguese, 'code': 'pt'},
      {'name': S.of(context).Russian, 'code': 'ru'},
      {'name': S.of(context).Urdu, 'code': 'ur'},
      {'name': S.of(context).German, 'code': 'de'},
    ];

    return Theme(
        data: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        // You can specify other theme properties here if needed
    ),
    child: Scaffold(
      appBar: AppBar(
    title: Row(
    children: [
    Image.asset(
      'images/settingsico.png',
      height: 32,
      width: 32,
    ),
    SizedBox(width: 10),
    Text(
    S.of(context).SettingsTitle,
    style: TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.bold,
    fontFamily: 'SF-Pro',
    letterSpacing: 0.4,
    ),
    ),
    ],
    ),
    ),
    body: Container(
    color: Colors.white,
    child: SettingsList(
    sections: [
          SettingsSection(
            title: Text("App Language",style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'SF-Pro',
              letterSpacing: 0.4,
            ),
            ),
            tiles: [
              SettingsTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Default Language",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'SF-Pro',
                        letterSpacing: 0.4,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                          child: Container(
                            //padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            width: 155,
                        child: DropdownButton<String>(
                          value: Provider.of<AppLanguageSettings>(context).selectedLanguageCode,
                          onChanged: (String? newValue) async {
                            if (newValue != null) {
                              Provider.of<AppLanguageSettings>(context, listen: false).setLocale(newValue);
                              await Provider.of<AppLanguageSettings>(context, listen: false).saveSettings();
                              RestartWidget.restartApp(context);
                            }
                          },
                          items: appLanguages.map<DropdownMenuItem<String>>((language) {
                            return DropdownMenuItem<String>(
                              value: language['code'],
                              child: Text(
                                language['name']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'SF-Pro',
                                  letterSpacing: 0.4,
                                ),
                              ),
                            );
                          }).toList(),
                          icon: Icon(Icons.keyboard_arrow_down_rounded, size: 28),
                          iconEnabledColor: Colors.black,
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    ),
                  ],
                ),
                leading: Icon(Icons.language_rounded),
                onPressed: null, // Set to null to disable default onPressed behavior
              ),
            ],
          ),
          SettingsSection(
            title: Text("Default Module Language" ,style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'SF-Pro',
            letterSpacing: 0.4,
          ),
    ),
            tiles: [
              SettingsTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).Vision,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'SF-Pro',
                        letterSpacing: 0.4,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: Provider.of<VisionLanguageSettings>(context).selectedVisionLanguageCode,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              Provider.of<VisionLanguageSettings>(context, listen: false).setVisionLanguage(newValue);
                            }
                          },
                          items: Provider.of<VisionLanguageSettings>(context).visionLanguages.map<DropdownMenuItem<String>>((language) {
                            return DropdownMenuItem<String>(
                              value: language['code'],
                              child: Text(
                                LocalizationHelper.getLocalizedString(context, language['code']!, isModule: true),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'SF-Pro',
                                  letterSpacing: 0.4,
                                ),
                              ),
                            );
                          }).toList(),
                          icon: Icon(Icons.keyboard_arrow_down_rounded, size: 28),
                          iconEnabledColor: Colors.black,
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
                leading: Container(
                    width: 22, // Adjust the width as needed
                    height: 22, // Adjust the height as needed
                    child: Image.asset('images/visionico2.png'),
                ),
                onPressed: null, // Set to null to disable default onPressed behavior
              ),

              SettingsTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).BrailleTranslation,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'SF-Pro',
                        letterSpacing: 0.4,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                      BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      offset: Offset(0, 1),
                      ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: Provider.of<BrailleLanguageSettings>(context).selectedBrailleLanguageCode,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              Provider.of<BrailleLanguageSettings>(context, listen: false).setBrailleLanguage(newValue);
                            }
                          },
                          items: Provider.of<BrailleLanguageSettings>(context).brailleLanguages.map<DropdownMenuItem<String>>((language) {
                            return DropdownMenuItem<String>(
                              value: language['code'],
                              child: Row(
                                children: [
                                  Text(
                                    LocalizationHelper.getLocalizedString(context, language['code']!, isModule: true),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontFamily: 'SF-Pro',
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          icon: Icon(Icons.keyboard_arrow_down_rounded, size: 28),
                          iconEnabledColor: Colors.black,
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
                leading: Container(
                  width: 22, // Adjust the width as needed
                  height: 22, // Adjust the height as needed
                  child: Image.asset('images/brailletransico.png'),
                ),
                onPressed: null, // Set to null to disable default onPressed behavior
              ),
              SettingsTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).Reader,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'SF-Pro',
                        letterSpacing: 0.4,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Container(
                          child: DropdownButton<String>(
                            value: Provider.of<ReaderLanguageSettings>(context).selectedReaderLanguageCode,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                Provider.of<ReaderLanguageSettings>(context, listen: false).setReaderLanguage(newValue);
                              }
                            },
                            items: Provider.of<ReaderLanguageSettings>(context).readerLanguages.map<DropdownMenuItem<String>>((language) {
                              return DropdownMenuItem<String>(
                                value: language['code'],
                                child: Text(LocalizationHelper.getLocalizedString(context, language['code']!, isModule: true),
                              style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'SF-Pro',
                              letterSpacing: 0.4,
                              ),
                              ),
                              );
                            }).toList(),
                            icon: Icon(Icons.keyboard_arrow_down_rounded, size: 28),
                            iconEnabledColor: Colors.black,
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                leading: Container(
                  width: 22, // Adjust the width as needed
                  height: 22, // Adjust the height as needed
                  child: Image.asset('images/pictranslateico.png'),
                ),
                onPressed: null, // Set to null to disable default onPressed behavior
              ),

            ],
          ),
          SettingsSection(
            title: Text(S.of(context).SpeechOutSub,style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'SF-Pro',
              letterSpacing: 0.4,
            ),
            ),
            tiles: [
              SettingsTile.switchTile(
                title: Text(Provider.of<VoiceSettings>(context).isMaleVoice ? S.of(context).MaleVRB : S.of(context).FemalVRB,style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'SF-Pro',
                  letterSpacing: 0.4,
                ),
                ),
                leading: Icon(
                  Provider.of<VoiceSettings>(context).isMaleVoice ? Icons.man_2_sharp : Icons.woman,
                ),
                initialValue: Provider.of<VoiceSettings>(context).isMaleVoice,
                onToggle: (value) {
                  Provider.of<VoiceSettings>(context, listen: false).toggleVoice(value);
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text(S.of(context).SuppSub,style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'SF-Pro',
              letterSpacing: 0.4,
            ),
            ),
            tiles: [
              SettingsTile(
                title: Text(S.of(context).FAQ,style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'SF-Pro',
                  letterSpacing: 0.4,
                ),
                ),
                leading: Icon(Icons.help_rounded),
                onPressed: (context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FAQPage()),
                  );
                },
              ),
              SettingsTile(
                title: Text(S.of(context).SendFeedBT,style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'SF-Pro',
                  letterSpacing: 0.4,
                ),
                ),
                leading: Icon(Icons.feedback_rounded),
                onPressed: (context) {
                  // Invoke Instabug feedback reporting
                  BugReporting.show(
                    ReportType.feedback,
                    [InvocationOption.emailFieldHidden],
                  );
                },
              ),
              SettingsTile(
                title: Text(S.of(context).RepABugBT,style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'SF-Pro',
                  letterSpacing: 0.4,
                ),
                ),
                leading: Icon(Icons.bug_report_rounded),
                onPressed: (context) {
                  // Invoke Instabug bug reporting with the desired options
                  BugReporting.show(
                    ReportType.bug,
                    [InvocationOption.emailFieldHidden, InvocationOption.commentFieldRequired],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ),
    ),
    );
  }
}
