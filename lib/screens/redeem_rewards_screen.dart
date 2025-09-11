import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_constants.dart';
import '../providers/user_provider.dart';
import '../widgets/common_app_bar.dart';

class RedeemRewardsScreen extends StatefulWidget {
  const RedeemRewardsScreen({super.key});

  @override
  State<RedeemRewardsScreen> createState() => _RedeemRewardsScreenState();
}

class _RedeemRewardsScreenState extends State<RedeemRewardsScreen> {
  String selectedCategory = 'ทั้งหมด';
  final List<String> categories = ['ทั้งหมด', 'ถุงผ้า', 'คูปอง', 'ต้นไม้', 'หนังสือ', 'อุปกรณ์', 'รางวัลพิเศษ'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const CommonAppBar(title: 'แลกของรางวัล'),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return Column(
            children: [
              _buildPointsHeader(userProvider),
              _buildCategoryFilter(),
              Expanded(child: _buildRewardsList(userProvider)),
            ],
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
          colors: [Colors.purple, Colors.deepPurple],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Text('💎', style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'แต้มที่ใช้ได้',
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

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                category,
                style: GoogleFonts.kanit(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.purple,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedCategory = category;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: Colors.purple,
              checkmarkColor: Colors.white,
              side: BorderSide(color: Colors.purple),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRewardsList(UserProvider userProvider) {
    final rewards = _getFilteredRewards();
    
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: rewards.length,
      itemBuilder: (context, index) {
        final reward = rewards[index];
        final canRedeem = userProvider.totalPoints >= reward['points'];
        
        return _buildRewardGridCard(reward, canRedeem, index);
      },
    );
  }

  Widget _buildRewardGridCard(Map<String, dynamic> reward, bool canRedeem, int index) {
    return Card(
      elevation: canRedeem ? 6 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: canRedeem ? () => _showRedeemDialog(reward) : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: canRedeem 
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Colors.purple.withOpacity(0.05)],
                )
              : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: canRedeem ? Colors.purple.withOpacity(0.1) : Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    reward['emoji'],
                    style: TextStyle(
                      fontSize: 32,
                      color: canRedeem ? null : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                reward['name'],
                style: GoogleFonts.kanit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: canRedeem ? Colors.black87 : Colors.grey,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: canRedeem ? Colors.purple : Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${reward['points']} แต้ม',
                  style: GoogleFonts.kanit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: canRedeem ? Colors.purple : Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  canRedeem ? 'แลกเลย' : 'แต้มไม่พอ',
                  style: GoogleFonts.kanit(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: (index * 100).ms).fadeIn(duration: 400.ms).scale(begin: const Offset(0.8, 0.8));
  }

  List<Map<String, dynamic>> _getFilteredRewards() {
    final allRewards = [
      {'emoji': '🎁', 'name': 'ถุงผ้าเกรด A', 'points': 50, 'category': 'ถุงผ้า'},
      {'emoji': '☕', 'name': 'คูปองกาแฟ 20%', 'points': 80, 'category': 'คูปอง'},
      {'emoji': '🌱', 'name': 'ต้นไม้เล็ก', 'points': 150, 'category': 'ต้นไม้'},
      {'emoji': '📚', 'name': 'หนังสือสิ่งแวดล้อม', 'points': 200, 'category': 'หนังสือ'},
      {'emoji': '🍱', 'name': 'กล่องอาหารไผ่', 'points': 250, 'category': 'อุปกรณ์'},
      {'emoji': '🥤', 'name': 'หลอดไผ่ธรรมชาติ', 'points': 120, 'category': 'อุปกรณ์'},
      {'emoji': '🌿', 'name': 'ต้นไผ่น้อย', 'points': 180, 'category': 'ต้นไม้'},
      {'emoji': '🎫', 'name': 'คูปองร้านอาหาร', 'points': 300, 'category': 'คูปอง'},
      {'emoji': '🏆', 'name': 'เหรียญทอง', 'points': 500, 'category': 'รางวัลพิเศษ'},
      {'emoji': '💎', 'name': 'เพชรสีเขียว', 'points': 1000, 'category': 'รางวัลพิเศษ'},
    ];

    if (selectedCategory == 'ทั้งหมด') {
      return allRewards;
    }
    return allRewards.where((reward) => reward['category'] == selectedCategory).toList();
  }

  void _showRedeemDialog(Map<String, dynamic> reward) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Text(reward['emoji'], style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            Text(
              'แลก ${reward['name']}',
              style: GoogleFonts.kanit(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Text(
          'คุณต้องการใช้ ${reward['points']} แต้ม เพื่อแลก ${reward['name']} หรือไม่?',
          style: GoogleFonts.kanit(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก', style: GoogleFonts.kanit(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _redeemReward(reward);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('แลกเลย', style: GoogleFonts.kanit(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _redeemReward(Map<String, dynamic> reward) async {
    final userProvider = context.read<UserProvider>();
    final success = await userProvider.deductPoints(reward['points']);
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('แลก ${reward['name']} สำเร็จ! 🎉', style: GoogleFonts.kanit()),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }
}