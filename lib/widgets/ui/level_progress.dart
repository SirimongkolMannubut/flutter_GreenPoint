import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_constants.dart';

class LevelProgress extends StatelessWidget {
  final int currentPoints;
  final bool showAnimation;

  const LevelProgress({
    super.key,
    required this.currentPoints,
    this.showAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    final levelData = _getLevelData(currentPoints);
    
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            levelData['primaryColor'].withOpacity(0.1),
            levelData['secondaryColor'].withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: levelData['primaryColor'].withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: levelData['primaryColor'].withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildLevelHeader(levelData),
            const SizedBox(height: 20),
            _buildProgressBar(levelData),
            const SizedBox(height: 16),
            _buildLevelInfo(levelData),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelHeader(Map<String, dynamic> levelData) {
    return Row(
      children: [
        _buildLevelBadge(levelData),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Level ${levelData['level']}',
                    style: GoogleFonts.kanit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: levelData['primaryColor'],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (levelData['level'] >= 5)
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20,
                    ).animate(onPlay: (controller) => controller.repeat())
                        .shimmer(duration: 1500.ms),
                ],
              ),
              Text(
                levelData['description'],
                style: GoogleFonts.kanit(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: levelData['primaryColor'],
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: levelData['primaryColor'].withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            '${currentPoints} แต้ม',
            style: GoogleFonts.kanit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLevelBadge(Map<String, dynamic> levelData) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            levelData['primaryColor'],
            levelData['secondaryColor'],
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: levelData['primaryColor'].withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            levelData['icon'],
            size: 35,
            color: Colors.white,
          ),
          Positioned(
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${levelData['level']}',
                style: GoogleFonts.kanit(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: levelData['primaryColor'],
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate()
        .scale(duration: 600.ms, curve: Curves.elasticOut)
        .then()
        .shimmer(duration: 2000.ms, delay: 1000.ms);
  }

  Widget _buildProgressBar(Map<String, dynamic> levelData) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${levelData['currentLevelPoints']}',
              style: GoogleFonts.kanit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            Text(
              '${levelData['nextLevelPoints']}',
              style: GoogleFonts.kanit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 12,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(6),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: levelData['progress'],
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                levelData['primaryColor'],
              ),
            ),
          ),
        ).animate()
            .fadeIn(duration: 800.ms)
            .slideX(begin: -1, end: 0, curve: Curves.easeOutBack),
      ],
    );
  }

  Widget _buildLevelInfo(Map<String, dynamic> levelData) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: levelData['primaryColor'].withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.trending_up,
            color: levelData['primaryColor'],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              levelData['nextLevelText'],
              style: GoogleFonts.kanit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          if (levelData['level'] < 5)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: levelData['primaryColor'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+${levelData['pointsToNext']}',
                style: GoogleFonts.kanit(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: levelData['primaryColor'],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getLevelData(int points) {
    if (points < 100) {
      return {
        'level': 1,
        'name': 'มือใหม่',
        'description': 'เริ่มต้นการเดินทางสู่โลกสีเขียว',
        'icon': Icons.eco,
        'primaryColor': const Color(0xFF4CAF50),
        'secondaryColor': const Color(0xFF8BC34A),
        'currentLevelPoints': 0,
        'nextLevelPoints': 100,
        'progress': points / 100,
        'pointsToNext': 100 - points,
        'nextLevelText': 'อีก ${100 - points} แต้ม ถึงระดับ นักสู้สีเขียว',
      };
    } else if (points < 500) {
      return {
        'level': 2,
        'name': 'นักสู้สีเขียว',
        'description': 'กำลังสร้างผลกระทบเชิงบวก',
        'icon': Icons.shield,
        'primaryColor': const Color(0xFF2196F3),
        'secondaryColor': const Color(0xFF03DAC6),
        'currentLevelPoints': 100,
        'nextLevelPoints': 500,
        'progress': (points - 100) / 400,
        'pointsToNext': 500 - points,
        'nextLevelText': 'อีก ${500 - points} แต้ม ถึงระดับ ผู้พิทักษ์โลก',
      };
    } else if (points < 1500) {
      return {
        'level': 3,
        'name': 'ผู้พิทักษ์โลก',
        'description': 'ผู้นำการเปลี่ยนแปลงในชุมชน',
        'icon': Icons.public,
        'primaryColor': const Color(0xFFFF9800),
        'secondaryColor': const Color(0xFFFFB74D),
        'currentLevelPoints': 500,
        'nextLevelPoints': 1500,
        'progress': (points - 500) / 1000,
        'pointsToNext': 1500 - points,
        'nextLevelText': 'อีก ${1500 - points} แต้ม ถึงระดับ ฮีโร่สิ่งแวดล้อม',
      };
    } else if (points < 3000) {
      return {
        'level': 4,
        'name': 'ฮีโร่สิ่งแวดล้อม',
        'description': 'ผู้เปลี่ยนโลกด้วยพลังแห่งธรรมชาติ',
        'icon': Icons.star,
        'primaryColor': const Color(0xFF9C27B0),
        'secondaryColor': const Color(0xFFBA68C8),
        'currentLevelPoints': 1500,
        'nextLevelPoints': 3000,
        'progress': (points - 1500) / 1500,
        'pointsToNext': 3000 - points,
        'nextLevelText': 'อีก ${3000 - points} แต้ม ถึงระดับ ตำนานสีเขียว',
      };
    } else {
      return {
        'level': 5,
        'name': 'ตำนานสีเขียว',
        'description': 'ผู้ที่ได้รับการยกย่องสูงสุด',
        'icon': Icons.diamond,
        'primaryColor': const Color(0xFFE91E63),
        'secondaryColor': const Color(0xFFF48FB1),
        'currentLevelPoints': 3000,
        'nextLevelPoints': 3000,
        'progress': 1.0,
        'pointsToNext': 0,
        'nextLevelText': 'คุณได้ถึงระดับสูงสุดแล้ว! 🎉',
      };
    }
  }
}