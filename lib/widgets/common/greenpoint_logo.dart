import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_constants.dart';

class GreenPointLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? textColor;

  const GreenPointLogo({
    super.key,
    this.size = 40,
    this.showText = true,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppConstants.primaryGreen,
                AppConstants.lightGreen,
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppConstants.primaryGreen.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '🌱',
              style: TextStyle(fontSize: size * 0.6),
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(width: 8),
          Text(
            'GreenPoint',
            style: GoogleFonts.kanit(
              fontSize: size * 0.5,
              fontWeight: FontWeight.bold,
              color: textColor ?? AppConstants.primaryGreen,
            ),
          ),
        ],
      ],
    );
  }
}