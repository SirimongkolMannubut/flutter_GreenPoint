import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_constants.dart';
import '../providers/user_provider.dart';
import '../widgets/common_app_bar.dart';
import 'redeem_rewards_screen.dart';
import 'my_cards_screen.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const CommonAppBar(
        title: 'ของรางวัล',
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildPointsHeader(userProvider),
                _buildMainButtons(),
                _buildRecommendedSection(),
                _buildAllRewardsSection(userProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPointsHeader(UserProvider userProvider) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.orange, Colors.deepOrange],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Text('🏆', style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'แต้มของคุณ',
                  style: GoogleFonts.kanit(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  '${userProvider.totalPoints} แต้ม',
                  style: GoogleFonts.kanit(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Level ${userProvider.level}',
              style: GoogleFonts.kanit(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3, end: 0);
  }

  Widget _buildMainButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildMainButton(
              icon: Icons.card_giftcard,
              title: 'Redeem Rewards',
              subtitle: 'แลกของรางวัล',
              color: AppConstants.primaryGreen,
              onTap: () => _showAllRewards(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildMainButton(
              icon: Icons.credit_card,
              title: 'My Cards',
              subtitle: 'การ์ดของฉัน',
              color: Colors.blue,
              onTap: () => _showMyCards(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 140, // Fixed height to make buttons equal
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.kanit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.kanit(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms).scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildRecommendedSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '🔥 แนะนำ',
                style: GoogleFonts.kanit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.darkGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'แลกคูปองส่วนลดร้านดังนี้',
            style: GoogleFonts.kanit(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              border: Border.all(color: Colors.amber[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.local_cafe, color: Colors.brown, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'คูปองกาแฟ 20% OFF',
                        style: GoogleFonts.kanit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[800],
                        ),
                      ),
                      Text(
                        'ใช้ได้กับร้านกาแฟชั้นนำ',
                        style: GoogleFonts.kanit(
                          fontSize: 12,
                          color: Colors.brown[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '80 แต้ม',
                          style: GoogleFonts.kanit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.brown[600], size: 16),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms);
  }

  Widget _buildAllRewardsSection(UserProvider userProvider) {
    final rewards = _getRewardsList();
    
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ของรางวัลทั้งหมด',
            style: GoogleFonts.kanit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConstants.darkGreen,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rewards.length,
            itemBuilder: (context, index) {
              final reward = rewards[index];
              final canRedeem = userProvider.totalPoints >= reward['points'];
              
              return _buildRewardCard(
                reward['emoji'],
                reward['name'],
                reward['description'],
                reward['points'],
                canRedeem,
                index,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard(String emoji, String name, String description, int points, bool canRedeem, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: canRedeem ? 4 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: canRedeem ? () => _showRedeemDialog(emoji, name, points) : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: canRedeem ? AppConstants.primaryGreen.withOpacity(0.1) : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    emoji,
                    style: TextStyle(
                      fontSize: 28,
                      color: canRedeem ? null : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.kanit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: canRedeem ? Colors.black87 : Colors.grey,
                      ),
                    ),
                    Text(
                      description,
                      style: GoogleFonts.kanit(
                        fontSize: 12,
                        color: canRedeem ? Colors.grey[600] : Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: canRedeem ? AppConstants.primaryGreen : Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$points แต้ม',
                        style: GoogleFonts.kanit(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: canRedeem ? AppConstants.primaryGreen : Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  canRedeem ? 'แลก' : 'ไม่พอ',
                  style: GoogleFonts.kanit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: (index * 100).ms).fadeIn(duration: 400.ms).slideX(begin: 0.3, end: 0);
  }

  List<Map<String, dynamic>> _getRewardsList() {
    return [
      {
        'emoji': '🎁',
        'name': 'ถุงผ้าเกรด A',
        'description': 'ถุงผ้าคุณภาพดี ใช้แทนถุงพลาสติก',
        'points': 50,
      },
      {
        'emoji': '☕',
        'name': 'คูปองส่วนลดกาแฟ',
        'description': 'ส่วนลด 20% ร้านกาแฟชั้นนำ',
        'points': 100,
      },
      {
        'emoji': '🌱',
        'name': 'ต้นไม้เล็ก',
        'description': 'ต้นไม้ในกระถางเล็ก ปลูกง่าย',
        'points': 150,
      },
      {
        'emoji': '📚',
        'name': 'หนังสือสิ่งแวดล้อม',
        'description': 'หนังสือความรู้เรื่องสิ่งแวดล้อม',
        'points': 200,
      },
      {
        'emoji': '🍱',
        'name': 'กล่องอาหารไผ่',
        'description': 'กล่องอาหารจากไผ่ 100%',
        'points': 250,
      },
      {
        'emoji': '🏆',
        'name': 'เหรียญรางวัลพิเศษ',
        'description': 'เหรียญรางวัลผู้อนุรักษ์สิ่งแวดล้อม',
        'points': 500,
      },
    ];
  }

  void _showAllRewards() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RedeemRewardsScreen()),
    );
  }

  void _showMyCards() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyCardsScreen()),
    );
  }

  void _showRedeemDialog(String emoji, String name, int points) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'แลก $name',
                style: GoogleFonts.kanit(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Text(
          'คุณต้องการใช้ $points แต้ม เพื่อแลก $name หรือไม่?',
          style: GoogleFonts.kanit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก', style: GoogleFonts.kanit()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _redeemReward(name, points);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryGreen,
              foregroundColor: Colors.white,
            ),
            child: Text('แลกเลย', style: GoogleFonts.kanit()),
          ),
        ],
      ),
    );
  }

  Future<void> _redeemReward(String name, int points) async {
    final userProvider = context.read<UserProvider>();
    
    final success = await userProvider.deductPoints(points);
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('แลก $name สำเร็จ! ใช้ไป $points แต้ม', style: GoogleFonts.kanit()),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('แต้มไม่เพียงพอ', style: GoogleFonts.kanit()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}