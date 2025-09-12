import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AchievementBadge extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  final int progress;
  final int target;

  const AchievementBadge({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.isUnlocked,
    this.progress = 0,
    this.target = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isUnlocked
              ? [
                  color.withOpacity(0.8),
                  color.withOpacity(0.6),
                ]
              : [
                  Colors.grey.withOpacity(0.3),
                  Colors.grey.withOpacity(0.1),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked ? color : Colors.grey.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBadgeIcon(),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.kanit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isUnlocked ? Colors.white : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: GoogleFonts.kanit(
                fontSize: 12,
                color: isUnlocked ? Colors.white.withOpacity(0.9) : Colors.grey[500],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (!isUnlocked && target > 1) ...[
              const SizedBox(height: 8),
              _buildProgressIndicator(),
            ],
          ],
        ),
      ),
    ).animate()
        .fadeIn(duration: 600.ms)
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0))
        .then(delay: isUnlocked ? 500.ms : 0.ms)
        .shimmer(duration: isUnlocked ? 2000.ms : 0.ms);
  }

  Widget _buildBadgeIcon() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isUnlocked ? Colors.white.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: isUnlocked ? Colors.white.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Icon(
        icon,
        size: 30,
        color: isUnlocked ? Colors.white : Colors.grey[400],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final progressPercent = progress / target;
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$progress',
              style: GoogleFonts.kanit(
                fontSize: 10,
                color: Colors.grey[500],
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$target',
              style: GoogleFonts.kanit(
                fontSize: 10,
                color: Colors.grey[500],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progressPercent,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(color.withOpacity(0.7)),
            ),
          ),
        ),
      ],
    );
  }
}

class AchievementGrid extends StatelessWidget {
  final int currentPoints;
  final int totalActivities;
  final int qrScans;
  final double plasticReduced;

  const AchievementGrid({
    super.key,
    required this.currentPoints,
    required this.totalActivities,
    required this.qrScans,
    required this.plasticReduced,
  });

  @override
  Widget build(BuildContext context) {
    final achievements = _getAchievements();
    
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.emoji_events,
                color: Colors.amber,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'ความสำเร็จ',
                style: GoogleFonts.kanit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              return AchievementBadge(
                title: achievement['title'],
                description: achievement['description'],
                icon: achievement['icon'],
                color: achievement['color'],
                isUnlocked: achievement['isUnlocked'],
                progress: achievement['progress'],
                target: achievement['target'],
              );
            },
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getAchievements() {
    return [
      {
        'title': 'ก้าวแรก',
        'description': 'ทำกิจกรรมครั้งแรก',
        'icon': Icons.directions_walk,
        'color': const Color(0xFF4CAF50),
        'isUnlocked': totalActivities >= 1,
        'progress': totalActivities,
        'target': 1,
      },
      {
        'title': 'นักสะสม',
        'description': 'สะสมแต้ม 100 แต้ม',
        'icon': Icons.savings,
        'color': const Color(0xFF2196F3),
        'isUnlocked': currentPoints >= 100,
        'progress': currentPoints,
        'target': 100,
      },
      {
        'title': 'นักสแกน',
        'description': 'สแกน QR Code 10 ครั้ง',
        'icon': Icons.qr_code_scanner,
        'color': const Color(0xFF9C27B0),
        'isUnlocked': qrScans >= 10,
        'progress': qrScans,
        'target': 10,
      },
      {
        'title': 'ผู้พิทักษ์โลก',
        'description': 'ลดพลาสติก 1 กิโลกรัม',
        'icon': Icons.public,
        'color': const Color(0xFF4CAF50),
        'isUnlocked': plasticReduced >= 1000,
        'progress': plasticReduced.toInt(),
        'target': 1000,
      },
      {
        'title': 'นักรบสีเขียว',
        'description': 'ทำกิจกรรม 50 ครั้ง',
        'icon': Icons.eco,
        'color': const Color(0xFF8BC34A),
        'isUnlocked': totalActivities >= 50,
        'progress': totalActivities,
        'target': 50,
      },
      {
        'title': 'เซียนแต้ม',
        'description': 'สะสมแต้ม 1,000 แต้ม',
        'icon': Icons.star,
        'color': const Color(0xFFFF9800),
        'isUnlocked': currentPoints >= 1000,
        'progress': currentPoints,
        'target': 1000,
      },
    ];
  }
}