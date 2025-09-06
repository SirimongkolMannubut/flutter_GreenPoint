import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_constants.dart';

class LevelProgress extends StatelessWidget {
  final int level;
  final String levelName;
  final double progress;

  const LevelProgress({
    super.key,
    required this.level,
    required this.levelName,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildLevelIcon(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ระดับ $levelName',
                      style: GoogleFonts.kanit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.darkGreen,
                      ),
                    ),
                    Text(
                      _getNextLevelText(),
                      style: GoogleFonts.kanit(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: GoogleFonts.kanit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getLevelColor(),
              ),
              minHeight: 8,
            ),
          ).animate()
              .fadeIn(duration: 800.ms)
              .slideX(begin: -1, end: 0),
        ],
      ),
    );
  }

  Widget _buildLevelIcon() {
    IconData iconData;
    Color iconColor;

    switch (level) {
      case 1:
        iconData = Icons.military_tech;
        iconColor = Colors.brown;
        break;
      case 2:
        iconData = Icons.military_tech;
        iconColor = Colors.grey;
        break;
      case 3:
        iconData = Icons.military_tech;
        iconColor = Colors.amber;
        break;
      case 4:
        iconData = Icons.diamond;
        iconColor = Colors.cyan;
        break;
      case 5:
        iconData = Icons.diamond;
        iconColor = Colors.blue;
        break;
      default:
        iconData = Icons.military_tech;
        iconColor = Colors.brown;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        size: 32,
        color: iconColor,
      ),
    ).animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 2000.ms);
  }

  Color _getLevelColor() {
    switch (level) {
      case 1:
        return Colors.brown;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.amber;
      case 4:
        return Colors.cyan;
      case 5:
        return Colors.blue;
      default:
        return Colors.brown;
    }
  }

  String _getNextLevelText() {
    if (level >= 5) {
      return 'คุณถึงระดับสูงสุดแล้ว!';
    }

    final nextLevels = ['Silver', 'Gold', 'Platinum', 'Diamond'];
    final nextLevel = nextLevels[level - 1];
    
    final thresholds = [100, 500, 1000, 2500];
    final nextThreshold = thresholds[level - 1];
    
    return 'อีก ${(nextThreshold * (1 - progress)).toInt()} แต้ม ถึง $nextLevel';
  }
}