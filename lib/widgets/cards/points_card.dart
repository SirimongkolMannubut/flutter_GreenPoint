import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_constants.dart';

class PointsCard extends StatelessWidget {
  final int points;
  final int plasticReduced;

  const PointsCard({
    super.key,
    required this.points,
    required this.plasticReduced,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.primaryGreen,
            AppConstants.lightGreen,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.largeRadius),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryGreen.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.eco,
                size: 32,
                color: Colors.white,
              ).animate(onPlay: (controller) => controller.repeat())
                  .rotate(duration: 2000.ms),
              const SizedBox(width: 12),
              Text(
                'แต้มสะสม',
                style: GoogleFonts.kanit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '$points',
            style: GoogleFonts.kanit(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ).animate()
              .fadeIn(duration: 800.ms)
              .scale(begin: const Offset(0.5, 0.5)),
          Text(
            'แต้ม',
            style: GoogleFonts.kanit(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.recycling,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'ลดพลาสติก $plasticReduced ชิ้น',
                  style: GoogleFonts.kanit(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}