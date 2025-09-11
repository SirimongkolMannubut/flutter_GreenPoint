import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_constants.dart';
import 'greenpoint_logo.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;

  const CommonAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppConstants.primaryGreen,
      foregroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: showBackButton,
      title: Row(
        children: [
          const GreenPointLogo(
            size: 32,
            showText: true,
            textColor: Colors.white,
          ),
          if (title.isNotEmpty) ...[
            const SizedBox(width: 12),
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Colors.white70,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.kanit(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
          ],
        ],
      ),
      actions: actions,
      flexibleSpace: Container(
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}