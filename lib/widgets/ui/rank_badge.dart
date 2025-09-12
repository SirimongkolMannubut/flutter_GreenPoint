import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RankBadge extends StatefulWidget {
  final int level;
  final double size;

  const RankBadge({
    super.key,
    required this.level,
    this.size = 40,
  });

  @override
  State<RankBadge> createState() => _RankBadgeState();
}

class _RankBadgeState extends State<RankBadge>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _glowController;
  
  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rankData = _getRankData(widget.level);
    
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationController, _pulseController, _glowController]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow ring
            Transform.rotate(
              angle: _rotationController.value * 2 * 3.14159,
              child: Container(
                width: widget.size + 8,
                height: widget.size + 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      rankData['primaryColor'].withOpacity(0.3),
                      rankData['secondaryColor'].withOpacity(0.6),
                      rankData['primaryColor'].withOpacity(0.3),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.3, 0.6, 1.0],
                  ),
                ),
              ),
            ),
            // Pulsing glow
            Container(
              width: widget.size + (_pulseController.value * 6),
              height: widget.size + (_pulseController.value * 6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: rankData['primaryColor'].withOpacity(0.4 * _glowController.value),
                    blurRadius: 15 + (_glowController.value * 10),
                    spreadRadius: 2 + (_glowController.value * 3),
                  ),
                ],
              ),
            ),
            // Main badge
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.3, -0.3),
                  colors: [
                    rankData['primaryColor'],
                    rankData['secondaryColor'],
                    rankData['primaryColor'].withOpacity(0.8),
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.8),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: rankData['primaryColor'].withOpacity(0.6),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(-2, -2),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Icon with subtle animation
                  Transform.scale(
                    scale: 1.0 + (_pulseController.value * 0.1),
                    child: Icon(
                      rankData['icon'],
                      size: widget.size * 0.45,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  // Level number
                  Positioned(
                    bottom: widget.size * 0.08,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.size * 0.08,
                        vertical: widget.size * 0.03,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(widget.size * 0.08),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '${widget.level}',
                        style: GoogleFonts.kanit(
                          fontSize: widget.size * 0.18,
                          fontWeight: FontWeight.bold,
                          color: rankData['primaryColor'],
                        ),
                      ),
                    ),
                  ),
                  // Sparkle effects for high levels
                  if (widget.level >= 4) ..._buildSparkles(),
                ],
              ),
            ),
          ],
        );
      },
    ).animate()
        .scale(duration: 800.ms, curve: Curves.elasticOut)
        .then(delay: 500.ms)
        .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.5));
  }
  
  List<Widget> _buildSparkles() {
    return List.generate(3, (index) {
      final angle = (index * 120.0) + (_rotationController.value * 360);
      final radians = angle * 3.14159 / 180;
      final distance = widget.size * 0.6;
      
      return Positioned(
        left: widget.size / 2 + (distance * 0.5 * math.cos(radians)) - 3,
        top: widget.size / 2 + (distance * 0.5 * math.sin(radians)) - 3,
        child: Transform.scale(
          scale: 0.5 + (_glowController.value * 0.5),
          child: Icon(
            Icons.auto_awesome,
            size: 6,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      );
    });
  }

  Map<String, dynamic> _getRankData(int level) {
    switch (level) {
      case 1:
        return {
          'icon': Icons.eco,
          'primaryColor': const Color(0xFF4CAF50),
          'secondaryColor': const Color(0xFF8BC34A),
        };
      case 2:
        return {
          'icon': Icons.shield,
          'primaryColor': const Color(0xFF2196F3),
          'secondaryColor': const Color(0xFF03DAC6),
        };
      case 3:
        return {
          'icon': Icons.public,
          'primaryColor': const Color(0xFFFF9800),
          'secondaryColor': const Color(0xFFFFB74D),
        };
      case 4:
        return {
          'icon': Icons.star,
          'primaryColor': const Color(0xFF9C27B0),
          'secondaryColor': const Color(0xFFBA68C8),
        };
      case 5:
        return {
          'icon': Icons.diamond,
          'primaryColor': const Color(0xFFE91E63),
          'secondaryColor': const Color(0xFFF48FB1),
        };
      default:
        return {
          'icon': Icons.eco,
          'primaryColor': const Color(0xFF4CAF50),
          'secondaryColor': const Color(0xFF8BC34A),
        };
    }
  }
}