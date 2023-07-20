import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobileapp/events/enums/alert_level.dart';
import 'package:mobileapp/events/system/alert.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/localizations/app_localization_delegate.dart';
import 'package:mobileapp/localizations/language.dart';
import 'package:mobileapp/models/app_config.dart';
import 'package:mobileapp/models/app_env.dart';
import 'package:mobileapp/screens/v1/views/full_app_screen.dart';
import 'package:mobileapp/services/kbus.dart';
import 'package:mobileapp/states/app_global_bloc.dart';
import 'package:mobileapp/theme/app_notifier.dart';
import 'package:mobileapp/theme/app_theme.dart';
import 'package:provider/provider.dart';

main() async {
  runMain(const AppConfig(
      backendHost: "https://api.keypuzzle.xyz",
      keygenEndpoint: "https://keygen-eu-alpha.keypuzzle.xyz",
      isSegwit: true,
      isMainnet: false,
      appEnv: AppEnv.DEV));
}

runMain(AppConfig appConfig) async {
  WidgetsFlutterBinding.ensureInitialized();
  AppTheme.init();
  runApp(ChangeNotifierProvider<AppNotifier>(
    create: (context) => AppNotifier(),
    child: ChangeNotifierProvider<AppNotifier>(
      create: (context) => AppNotifier(),
      child: MyApp(appConfig: appConfig),
    ),
  ));
}

class MyApp extends StatefulWidget {
  final AppConfig appConfig;

  const MyApp({super.key, required this.appConfig});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var authenticated = false;
  var requireRestart = false;
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      requireRestart = true;
      key = UniqueKey();
    });
  }

  @override
  void initState() {
    super.initState();
    reload();
  }

  void reload() async {
    await setup(widget.appConfig);
    bool canCheckBiometrics =
        await getIt<LocalAuthentication>().canCheckBiometrics;
    if (canCheckBiometrics) {
      bool authenticated = await getIt<LocalAuthentication>().authenticate(
        localizedReason: 'Scan your biometric to authenticate',
      );
      if (authenticated) {
        setState(() {
          this.authenticated = true;
        });
      } else {
        getIt<KbusClient>().fireE(
            MyApp,
            Alert(
                level: AlertLevel.ERROR,
                message: "Biometric authentication failed"));
      }
    } else {
      getIt<KbusClient>().fireE(
          MyApp,
          Alert(
              level: AlertLevel.ERROR,
              message:
                  "Authentication is required. Please enable passcode or biometric feature on your phone."));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      key: key,
      builder: (BuildContext context, AppNotifier value, Widget? child) {
        return BlocProvider(
            create: (_) => getIt<AppGlobalBloc>(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.theme,
              builder: (context, child) {
                return Directionality(
                  textDirection: AppTheme.textDirection,
                  child: child!,
                );
              },
              localizationsDelegates: [
                AppLocalizationsDelegate(context),
                // Add this line
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: Language.getLocales(),
              home: authenticated && !requireRestart
                  ? const FullAppScreen()
                  : StartScreen(requireRestart: requireRestart),
              // home: LoginScreen(),
            ));
      },
    );
  }
}

class StartScreen extends StatelessWidget {
  final bool requireRestart;

  const StartScreen({super.key, required this.requireRestart});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        builder: (context, child) {
          return Directionality(
            textDirection: AppTheme.textDirection,
            child: child!,
          );
        },
        localizationsDelegates: [
          AppLocalizationsDelegate(context),
          // Add this line
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: Language.getLocales(),
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                requireRestart
                    ? const Text(
                        "Please restart the app",
                        style: TextStyle(fontSize: 20),
                      )
                    : const CircularProgressIndicator(),
              ],
            ),
          ),
        ));
  }
}
