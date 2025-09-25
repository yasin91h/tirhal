import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:tirhal/core/provider/DriversProvider.dart';
import 'package:tirhal/core/provider/RideRequestProvider.dart';
import 'package:tirhal/core/provider/UserLocationProvider.dart';
import 'package:tirhal/core/provider/geocoding_provider.dart';
import 'package:tirhal/core/provider/onboarding_provider.dart';
import 'package:tirhal/core/provider/navigation_provider.dart';
import 'package:tirhal/core/providers/language_provider.dart';
import 'package:tirhal/core/providers/payment_provider.dart';
import 'package:tirhal/core/providers/theme_provider.dart';
import 'package:tirhal/core/theme/app_theme.dart';
import 'package:tirhal/core/localization/app_localizations.dart';
import 'package:tirhal/features/Onboarding/OnboardingScreen.dart';
import 'package:tirhal/features/auth/auth_provider.dart';
import 'package:tirhal/features/auth/auth_screen.dart';
import 'package:tirhal/features/home/home_provider.dart';
import 'package:tirhal/features/login_Screen/Login_Screen.dart';
import 'package:tirhal/features/login_Screen/Login_provider.dart';
import 'package:tirhal/features/main_screen/mainscreen.dart';
import 'package:tirhal/features/profile/profile_provider.dart';
import 'package:tirhal/features/history/ride_historyprovider.dart';
import 'package:tirhal/core/providers/location_search_provider.dart';
import 'package:tirhal/core/provider/ride_tracking_provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Keep splash screen until app is ready
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ChangeNotifierProvider(create: (_) => HomeProvider()),
      ChangeNotifierProvider(create: (_) => OnboardingProvider()),
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => LoginProvider()),
      ChangeNotifierProvider(create: (_) => UserLocationProvider()),
      ChangeNotifierProvider(create: (_) => GeocodingProvider()),
      ChangeNotifierProvider(create: (_) => DriversProvider()),
      ChangeNotifierProvider(create: (_) => RideRequestProvider()),
      ChangeNotifierProvider(create: (_) => RideHistoryProvider()),
      ChangeNotifierProvider(create: (_) => LocationSearchProvider()),
      ChangeNotifierProvider(create: (_) => RideTrackingProvider()),
      ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => PaymentProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize auth and location when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final languageProvider =
          Provider.of<LanguageProvider>(context, listen: false);
      final locationProvider =
          Provider.of<UserLocationProvider>(context, listen: false);

      // Initialize providers state from shared preferences
      await authProvider.initializeAuth();
      await loginProvider.initializeLogin();
      await languageProvider.initializeLanguage();

      // Update location
      locationProvider.updateLocation();

      // Remove splash screen after initialization
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ThemeProvider, AuthProvider, LanguageProvider>(
      builder: (context, themeProvider, authProvider, languageProvider, child) {
        return MaterialApp(
          routes: {
            "/MainScreen": (context) => MainScreen(),
            "/OnboardingScreen": (context) => const OnboardingScreen(),
            "/AuthScreen": (context) => const AuthScreen(phoneNumber: ''),
            "/LoginScreen": (context) => const LoginScreen(),
          },
          debugShowCheckedModeBanner: false,

          // Localization configuration
          locale: languageProvider.selectedLocale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'), // English
            Locale('ar', 'SA'), // Arabic
          ],

          // Text direction configuration for RTL support
          builder: (context, child) {
            return Directionality(
              textDirection: languageProvider.isRTL
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: child!,
            );
          },

          // Theme configuration
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.flutterThemeMode,

          // Check if user is logged in to determine home screen
          home:
              authProvider.isLoggedIn ? MainScreen() : const OnboardingScreen(),
        );
      },
    );
  }
}
