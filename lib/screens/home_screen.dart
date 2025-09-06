import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/user_provider.dart';
import '../constants/app_constants.dart';
import '../widgets/points_card.dart';
import '../widgets/activity_grid.dart';
import '../widgets/level_progress.dart';
import '../widgets/stats_overview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
              _buildAppBar(context, userProvider),
              SliverPadding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildWelcomeSection(userProvider)
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: 0.3, end: 0),
                    
                    const SizedBox(height: AppConstants.defaultPadding),
                    
                    PointsCard(
                      points: userProvider.totalPoints,
                      plasticReduced: userProvider.plasticReduced,
                    ).animate()
                        .fadeIn(duration: 600.ms, delay: 200.ms)
                        .slideX(begin: -0.3, end: 0),
                    
                    const SizedBox(height: AppConstants.defaultPadding),
                    
                    LevelProgress(
                      level: userProvider.level,
                      levelName: userProvider.levelName,
                      progress: userProvider.getLevelProgress(),
                    ).animate()
                        .fadeIn(duration: 600.ms, delay: 400.ms)
                        .slideX(begin: 0.3, end: 0),
                    
                    const SizedBox(height: AppConstants.defaultPadding),
                    
                    StatsOverview(
                      totalPoints: userProvider.totalPoints,
                      plasticReduced: userProvider.plasticReduced,
                      level: userProvider.level,
                    ).animate()
                        .fadeIn(duration: 600.ms, delay: 600.ms)
                        .slideY(begin: 0.3, end: 0),
                    
                    const SizedBox(height: AppConstants.largePadding),
                    
                    Text(
                      'กิจกรรมลดพลาสติก',
                      style: GoogleFonts.kanit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.darkGreen,
                      ),
                    ).animate()
                        .fadeIn(duration: 600.ms, delay: 800.ms),
                    
                    const SizedBox(height: AppConstants.defaultPadding),
                    
                    ActivityGrid(
                      onActivityTap: (activity) {
                        userProvider.addPoints(
                          activity.points,
                          activity.plasticReduction,
                        );
                        _showSuccessDialog(context, activity);
                      },
                    ).animate()
                        .fadeIn(duration: 600.ms, delay: 1000.ms)
                        .slideY(begin: 0.3, end: 0),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, UserProvider userProvider) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: AppConstants.primaryGreen,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'GreenPoint',
          style: GoogleFonts.kanit(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppConstants.primaryGreen,
                AppConstants.lightGreen,
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.person_outline, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(UserProvider userProvider) {
    final hour = DateTime.now().hour;
    String greeting = 'สวัสดี';
    if (hour < 12) {
      greeting = 'สวัสดีตอนเช้า';
    } else if (hour < 17) {
      greeting = 'สวัสดีตอนบ่าย';
    } else {
      greeting = 'สวัสดีตอนเย็น';
    }

    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppConstants.accentGreen, AppConstants.lightGreen],
        ),
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.eco,
            size: 40,
            color: Colors.white,
          ),
          const SizedBox(width: AppConstants.defaultPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting, ${userProvider.user?.name ?? 'ผู้ใช้งาน'}!',
                  style: GoogleFonts.kanit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'มาร่วมกันลดการใช้พลาสติกวันนี้',
                  style: GoogleFonts.kanit(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, dynamic activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        ),
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: AppConstants.successColor,
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(
              'เยี่ยมมาก!',
              style: GoogleFonts.kanit(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'คุณได้รับ ${activity.points} แต้ม จากการ${activity.title}',
          style: GoogleFonts.kanit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'ตกลง',
              style: GoogleFonts.kanit(
                color: AppConstants.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}