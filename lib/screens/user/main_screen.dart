import 'package:flutter/material.dart';
import '../../providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_constants.dart';

import '../../models/models.dart';
import '../../widgets/widgets.dart';
import 'home_screen.dart';
import 'partner_stores_screen.dart';
import 'profile_screen.dart';
import '../rewards/rewards_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const PartnerStoresScreen(),
    const RewardsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          body: _screens[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppConstants.primaryGreen,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.kanit(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: GoogleFonts.kanit(
          fontSize: 12,
        ),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: settings.translate('home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.store),
            label: settings.translate('partner_store'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.card_giftcard),
            label: settings.translate('rewards'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: settings.translate('profile'),
          ),
        ],
      ),
        );
      },
    );
  }
}





