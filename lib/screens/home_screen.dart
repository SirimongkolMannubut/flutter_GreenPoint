import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/user_provider.dart';
import '../constants/app_constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppConstants.primaryGreen,
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              _buildHeader(),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildProfileCard(userProvider),
                    const SizedBox(height: 20),
                    _buildShortcutMenu(),
                    const SizedBox(height: 20),
                    _buildPromotionBanner(),
                    const SizedBox(height: 20),
                    _buildCollectionCards(),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      expandedHeight: 100,
      floating: false,
      pinned: true,
      backgroundColor: AppConstants.primaryGreen,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppConstants.primaryGreen, AppConstants.lightGreen],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'GreenPoint',
                    style: GoogleFonts.kanit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 28),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(UserProvider userProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppConstants.primaryGreen, AppConstants.lightGreen],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'สวัสดี, ${userProvider.user?.name ?? 'ขวัญ'} 👋',
                style: GoogleFonts.kanit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'แต้มสะสม',
                    style: GoogleFonts.kanit(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    '${userProvider.totalPoints} แต้ม',
                    style: GoogleFonts.kanit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Level ${userProvider.level} ${userProvider.levelName}',
                    style: GoogleFonts.kanit(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${(userProvider.getLevelProgress() * 1000).toInt()}/1000',
                    style: GoogleFonts.kanit(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: userProvider.getLevelProgress(),
                backgroundColor: Colors.white30,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 6,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildShortcutMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildShortcutItem('Scan QR', Icons.qr_code_scanner, () {}),
        _buildShortcutItem('ร้านค้า', Icons.store, () {}),
        _buildShortcutItem('แลกของ', Icons.card_giftcard, () {}),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms);
  }

  Widget _buildShortcutItem(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: AppConstants.primaryGreen),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.kanit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppConstants.darkGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotionBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.orange, Colors.deepOrange],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'โปรโมชั่นงานกาชาด',
            style: GoogleFonts.kanit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'รับแต้ม X2 ร้านน้ำสมุนไพร',
            style: GoogleFonts.kanit(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms);
  }

  Widget _buildCollectionCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'การ์ดสะสม',
          style: GoogleFonts.kanit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppConstants.darkGreen,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCollectionCard('🌱', 'ใบไม้', Colors.green),
            _buildCollectionCard('🌍', 'โลก', Colors.blue),
            _buildCollectionCard('☕', 'กาแฟ', Colors.brown),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 600.ms);
  }

  Widget _buildCollectionCard(String emoji, String title, Color color) {
    return Container(
      width: 100,
      height: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.kanit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}