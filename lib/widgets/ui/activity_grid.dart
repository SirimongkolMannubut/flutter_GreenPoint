import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/models.dart';
import '../../constants/app_constants.dart';

class ActivityGrid extends StatelessWidget {
  final Function(Activity) onActivityTap;

  const ActivityGrid({
    super.key,
    required this.onActivityTap,
  });

  @override
  Widget build(BuildContext context) {
    final activities = _getActivities();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return _ActivityCard(
          activity: activity,
          onTap: () => onActivityTap(activity),
        ).animate(delay: (index * 100).ms)
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.3, end: 0);
      },
    );
  }

  List<Activity> _getActivities() {
    return [
      Activity(
        id: '1',
        title: 'ใช้ถุงผ้า',
        description: 'นำถุงผ้าไปช้อปปิ้งแทนถุงพลาสติก',
        icon: Icons.shopping_bag,
        points: 10,
        plasticReduction: 1,
        category: 'ถุงผ้า',
        color: AppConstants.primaryGreen,
      ),
      Activity(
        id: '2',
        title: 'ใช้กล่องอาหาร',
        description: 'นำกล่องอาหารส่วนตัวไปซื้ออาหาร',
        icon: Icons.lunch_dining,
        points: 15,
        plasticReduction: 2,
        category: 'กล่องอาหาร',
        color: Colors.orange,
      ),
      Activity(
        id: '3',
        title: 'ใช้หลอดไผ่',
        description: 'ใช้หลอดไผ่แทนหลอดพลาสติก',
        icon: Icons.local_drink,
        points: 8,
        plasticReduction: 1,
        category: 'หลอดไผ่',
        color: Colors.brown,
      ),
      Activity(
        id: '4',
        title: 'ไม่ใช้ถุงพลาสติก',
        description: 'ปฏิเสธการใช้ถุงพลาสติกทุกชนิด',
        icon: Icons.no_luggage,
        points: 20,
        plasticReduction: 3,
        category: 'การรีไซเคิล',
        color: Colors.red,
      ),
      Activity(
        id: '5',
        title: 'ใช้ขวดน้ำส่วนตัว',
        description: 'นำขวดน้ำส่วนตัวแทนซื้อน้ำขวด',
        icon: Icons.water_drop,
        points: 12,
        plasticReduction: 1,
        category: 'ขวดน้ำ',
        color: Colors.blue,
      ),
      Activity(
        id: '6',
        title: 'แยกขยะรีไซเคิล',
        description: 'แยกขยะพลาสติกเพื่อนำไปรีไซเคิล',
        icon: Icons.recycling,
        points: 25,
        plasticReduction: 5,
        category: 'การแยกขยะ',
        color: Colors.purple,
      ),
    ];
  }
}

class _ActivityCard extends StatefulWidget {
  final Activity activity;
  final VoidCallback onTap;

  const _ActivityCard({
    required this.activity,
    required this.onTap,
  });

  @override
  State<_ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<_ActivityCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _controller.forward(),
            onTapUp: (_) {
              _controller.reverse();
              widget.onTap();
            },
            onTapCancel: () => _controller.reverse(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                boxShadow: [
                  BoxShadow(
                    color: widget.activity.color.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: widget.activity.color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.activity.icon,
                      size: 40,
                      color: widget.activity.color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      widget.activity.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.kanit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.darkGreen,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppConstants.successColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '+${widget.activity.points} แต้ม',
                      style: GoogleFonts.kanit(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ลดพลาสติก ${widget.activity.plasticReduction} ชิ้น',
                    style: GoogleFonts.kanit(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}