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
        Image.asset(
          'assets/images/LogogreenPoint.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
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