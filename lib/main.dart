import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'providers/providers.dart';
import 'screens/screens.dart';
import 'constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Global error handler
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('Flutter Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };
  
  // Initialize services with timeout
  await Future.wait([
    _initializeDateFormatting(),
    _loadEnvironment(),
  ]).timeout(
    const Duration(seconds: 10),
    onTimeout: () {
      debugPrint('Initialization timeout - continuing with defaults');
      return [];
    },
  );
  
  runApp(const GreenPointApp());
}

Future<void> _initializeDateFormatting() async {
  try {
    await initializeDateFormatting('th', null);
  } catch (e) {
    debugPrint('Date formatting initialization failed: $e');
    // Fallback to default locale
    try {
      await initializeDateFormatting('en', null);
    } catch (fallbackError) {
      debugPrint('Fallback date formatting failed: $fallbackError');
    }
  }
}

Future<void> _loadEnvironment() async {
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Environment file loading failed: $e');
    // Continue without .env file
  }
}

class GreenPointApp extends StatefulWidget {
  const GreenPointApp({super.key});

  @override
  State<GreenPointApp> createState() => _GreenPointAppState();
}

class _GreenPointAppState extends State<GreenPointApp> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _hideSplashAfterDelay();
  }

  Future<void> _hideSplashAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() {
        _showSplash = false;
      });
    }
  }

  Widget _buildHomeScreen(UserProvider userProvider) {
    try {
      if (userProvider.isLoading) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: AppConstants.primaryGreen,
                  strokeWidth: 3,
                ),
                const SizedBox(height: 16),
                Consumer<SettingsProvider>(
                  builder: (context, settings, child) {
                    return Text(
                      settings.translate('loading'),
                      style: GoogleFonts.kanit(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }
      
      if (_showSplash) {
        return const SplashScreen();
      }
      return userProvider.isLoggedIn ? const MainScreen() : const AuthScreen();
    } catch (e, stackTrace) {
      debugPrint('Critical error in home screen: $e');
      debugPrint('Stack trace: $stackTrace');
      
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[400],
                ),
                const SizedBox(height: 16),
                Consumer<SettingsProvider>(
                  builder: (context, settings, child) {
                    return Text(
                      settings.translate('error'),
                      style: GoogleFonts.kanit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Consumer<SettingsProvider>(
                  builder: (context, settings, child) {
                    return Text(
                      settings.translate('restart_app'),
                      style: GoogleFonts.kanit(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => const AuthScreen(),
                  child: Consumer<SettingsProvider>(
                    builder: (context, settings, child) {
                      return Text(settings.translate('restart'));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => WasteProvider(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (_) => StoreProvider(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => AdminProvider(),
          lazy: true,
        ),
      ],
      child: Builder(
        builder: (context) {
          // Initialize providers after they're created
          WidgetsBinding.instance.addPostFrameCallback((_) {
            try {
              context.read<UserProvider>().loadUser();
              context.read<WasteProvider>().loadEntries();
            } catch (e) {
              debugPrint('Provider initialization error: $e');
            }
          });
          
          return Consumer<SettingsProvider>(
            builder: (context, settingsProvider, child) {
              return MaterialApp(
                title: AppConstants.appName,
                debugShowCheckedModeBanner: false,
                locale: Locale(settingsProvider.currentLanguage),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppConstants.primaryGreen,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          textTheme: GoogleFonts.kanitTextTheme(),
          appBarTheme: AppBarTheme(
            backgroundColor: AppConstants.primaryGreen,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: GoogleFonts.kanit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          cardTheme: const CardThemeData(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.largePadding,
                vertical: AppConstants.defaultPadding,
              ),
            ),
          ),
        ),
                home: Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _buildHomeScreen(userProvider),
                    );
                  },
                ),
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2),
                    ),
                    child: child!,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
