import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'providers/user_provider.dart';
import 'providers/waste_provider.dart';
import 'providers/store_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/main_screen.dart';
import 'constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await initializeDateFormatting('th', null);
  } catch (e) {
    debugPrint('Error initializing date formatting: $e');
  }
  
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Error loading .env file: $e');
  }
  
  runApp(const GreenPointApp());
}

class GreenPointApp extends StatelessWidget {
  const GreenPointApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()..loadUser()),
        ChangeNotifierProvider(create: (_) => WasteProvider()..loadEntries()),
        ChangeNotifierProvider(create: (_) => StoreProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
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
            try {
              if (userProvider.isLoading) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(
                      color: AppConstants.primaryGreen,
                    ),
                  ),
                );
              }
              return userProvider.isLoggedIn ? const MainScreen() : const AuthScreen();
            } catch (e) {
              debugPrint('Error in home builder: $e');
              return const AuthScreen();
            }
          },
        ),
      ),
    );
  }
}
