import 'package:flutter/material.dart';
import 'welcome_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:provider/provider.dart';
import 'settings.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dots/generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  String apiKey = dotenv.env['OPENAI_API_KEY'] ?? "Unknown";
  Instabug.init(
    token: 'f845314b22f6f51ed477a35402b0eff7',
    invocationEvents: [InvocationEvent.shake],
  );

  AppLanguageSettings appLanguageSettings = AppLanguageSettings();
  await appLanguageSettings.loadSettings();

  VoiceSettings voiceSettings = VoiceSettings();
  await voiceSettings.loadSettings();

  VisionLanguageSettings visionLanguageSettings = VisionLanguageSettings();
  await visionLanguageSettings.loadSettings();

  ReaderLanguageSettings readerLanguageSettings = ReaderLanguageSettings();
  await readerLanguageSettings.loadSettings();

  BrailleLanguageSettings brailleLanguageSettings = BrailleLanguageSettings();
  await brailleLanguageSettings.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => appLanguageSettings),
        ChangeNotifierProvider(create: (context) => voiceSettings),
        ChangeNotifierProvider(create: (context) => visionLanguageSettings),
        ChangeNotifierProvider(create: (context) => readerLanguageSettings),
        ChangeNotifierProvider(create: (context) => brailleLanguageSettings),
      ],
      child: MyApp(apiKey: apiKey),
    ),
  );
}

void setInstabugLocale(BuildContext context) {
  final selectedLanguage = Provider.of<AppLanguageSettings>(context, listen: false).selectedLanguageCode;

  switch (selectedLanguage) {
    case 'ar':
      Instabug.setLocale(IBGLocale.arabic);
      break;
    case 'fr':
      Instabug.setLocale(IBGLocale.french);
      break;
    case 'zh':
      Instabug.setLocale(IBGLocale.chineseSimplified);
      break;
    case 'hi':
      Instabug.setLocale(IBGLocale.english);
      break;
    case 'es':
      Instabug.setLocale(IBGLocale.spanish);
      break;
    case 'bn':
      Instabug.setLocale(IBGLocale.english);
      break;
    case 'pt':
      Instabug.setLocale(IBGLocale.portugueseBrazil);
      break;
    case 'ru':
      Instabug.setLocale(IBGLocale.russian);
      break;
    case 'ur':
      Instabug.setLocale(IBGLocale.english);
      break;
    case 'de':
      Instabug.setLocale(IBGLocale.german);
      break;
    case 'en':
    default:
      Instabug.setLocale(IBGLocale.english);
      break;
  }
}


class RestartWidget extends StatefulWidget {
  final Widget child;

  RestartWidget({required this.child});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}


class MyApp extends StatelessWidget {
  final String apiKey;
  MyApp({Key? key, required this.apiKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageSettings = Provider.of<AppLanguageSettings>(context);
    setInstabugLocale(context);

    return RestartWidget(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dots App',
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        locale: languageSettings.selectedLocale,
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: WelcomePage(apiKey: apiKey),
      ),
    );
  }
}