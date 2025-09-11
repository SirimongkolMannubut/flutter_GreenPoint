import 'package:flutter/material.dart';
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_constants.dart';
import '../providers/api_user_provider.dart';
import '../widgets/common_app_bar.dart';
import 'dart:math';

class MyCardsScreen extends StatefulWidget {
  const MyCardsScreen({super.key});

  @override
  State<MyCardsScreen> createState() => _MyCardsScreenState();
}

class _MyCardsScreenState extends State<MyCardsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> myCards = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadMyCards();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadMyCards() {
    // Sample cards data
    myCards = [
      {
        'id': 'A001',
        'name': 'Green Warrior',
        'grade': 'A',
        'rarity': 'Legendary',
        'power': 95,
        'description': 'นักรบสีเขียวผู้พิทักษ์โลก',
        'color': Colors.green,
        'icon': '🌟',
        'date': DateTime.now().subtract(const Duration(days: 5)),
      },
      {
        'id': 'B002',
        'name': 'Eco Guardian',
        'grade': 'B',
        'rarity': 'Epic',
        'power': 78,
        'description': 'ผู้พิทักษ์ระบบนิเวศ',
        'color': Colors.blue,
        'icon': '🛡️',
        'date': DateTime.now().subtract(const Duration(days: 12)),
      },
      {
        'id': 'C003',
        'name': 'Plant Master',
        'grade': 'C',
        'rarity': 'Rare',
        'power': 65,
        'description': 'เจ้าแห่งพืชพรรณ',
        'color': Colors.orange,
        'icon': '🌿',
        'date': DateTime.now().subtract(const Duration(days: 20)),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const CommonAppBar(title: 'การ์ดของฉัน'),
      body: Column(
        children: [
          _buildStatsHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMyCardsTab(),
                _buildCardPacksTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.indigo, Colors.purple],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Text('🃏', style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'การ์ดทั้งหมด',
                  style: GoogleFonts.kanit(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  '${myCards.length} ใบ',
                  style: GoogleFonts.kanit(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Collection',
                  style: GoogleFonts.kanit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3, end: 0);
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        labelStyle: GoogleFonts.kanit(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: 'การ์ดของฉัน'),
          Tab(text: 'ซองสุ่มการ์ด'),
        ],
      ),
    );
  }

  Widget _buildMyCardsTab() {
    if (myCards.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🃏', style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              'ยังไม่มีการ์ด',
              style: GoogleFonts.kanit(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ไปซื้อซองสุ่มการ์ดกันเถอะ!',
              style: GoogleFonts.kanit(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: myCards.length,
      itemBuilder: (context, index) {
        final card = myCards[index];
        return _buildCardItem(card, index);
      },
    );
  }

  Widget _buildCardItem(Map<String, dynamic> card, int index) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showCardDetails(card),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                card['color'].withOpacity(0.1),
                card['color'].withOpacity(0.3),
              ],
            ),
            border: Border.all(color: card['color'], width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: card['color'],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Grade ${card['grade']}',
                        style: GoogleFonts.kanit(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      card['icon'],
                      style: const TextStyle(fontSize: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        card['name'],
                        style: GoogleFonts.kanit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: card['color'],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        card['description'],
                        style: GoogleFonts.kanit(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      card['rarity'],
                      style: GoogleFonts.kanit(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: card['color'],
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.flash_on, size: 12, color: Colors.amber),
                        Text(
                          '${card['power']}',
                          style: GoogleFonts.kanit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate(delay: (index * 100).ms).fadeIn(duration: 400.ms).scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildCardPacksTab() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🎁 ซองสุ่มการ์ด',
                style: GoogleFonts.kanit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.darkGreen,
                ),
              ),
              const SizedBox(height: 16),
              _buildCardPack(
                'ซองเบื้องต้น',
                'การ์ดเกรด C-B',
                100,
                Colors.green,
                '🌱',
                userProvider,
              ),
              _buildCardPack(
                'ซองขั้นสูง',
                'การ์ดเกรด B-A',
                250,
                Colors.blue,
                '💎',
                userProvider,
              ),
              _buildCardPack(
                'ซองตำนาน',
                'การ์ดเกรด A-S',
                500,
                Colors.purple,
                '⭐',
                userProvider,
              ),
              _buildCardPack(
                'ซองพิเศษ',
                'การ์ดหายาก 100%',
                1000,
                Colors.orange,
                '🔥',
                userProvider,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCardPack(String name, String description, int price, Color color, String emoji, UserProvider userProvider) {
    final canBuy = userProvider.totalPoints >= price;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: canBuy ? 6 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: canBuy ? () => _buyCardPack(name, price, color, emoji) : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: canBuy 
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, color.withOpacity(0.1)],
                )
              : null,
          ),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: canBuy 
                      ? [color.withOpacity(0.2), color.withOpacity(0.4)]
                      : [Colors.grey.withOpacity(0.2), Colors.grey.withOpacity(0.4)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    emoji,
                    style: TextStyle(
                      fontSize: 36,
                      color: canBuy ? null : Colors.grey,
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: canBuy ? color : Colors.grey,
                      ),
                    ),
                    Text(
                      description,
                      style: GoogleFonts.kanit(
                        fontSize: 14,
                        color: canBuy ? Colors.grey[600] : Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: canBuy ? color : Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$price แต้ม',
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: canBuy ? color : Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  canBuy ? 'ซื้อ' : 'ไม่พอ',
                  style: GoogleFonts.kanit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCardDetails(Map<String, dynamic> card) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                card['color'].withOpacity(0.1),
                card['color'].withOpacity(0.3),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(card['icon'], style: const TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text(
                card['name'],
                style: GoogleFonts.kanit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: card['color'],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                card['description'],
                style: GoogleFonts.kanit(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem('เกรด', card['grade'], card['color']),
                  _buildStatItem('พลัง', '${card['power']}', Colors.amber),
                  _buildStatItem('หายาก', card['rarity'], Colors.purple),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: card['color'],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('ปิด', style: GoogleFonts.kanit(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.kanit(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: GoogleFonts.kanit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void _buyCardPack(String name, int price, Color color, String emoji) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            Text(
              'ซื้อ $name',
              style: GoogleFonts.kanit(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Text(
          'คุณต้องการใช้ $price แต้ม เพื่อซื้อ $name หรือไม่?',
          style: GoogleFonts.kanit(),
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
              _openCardPack(name, price, color);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('ซื้อเลย', style: GoogleFonts.kanit(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _openCardPack(String packName, int price, Color color) async {
    final userProvider = context.read<UserProvider>();
    final success = await userProvider.deductPoints(price);
    
    if (success) {
      // Generate random card
      final newCard = _generateRandomCard(packName);
      setState(() {
        myCards.add(newCard);
      });
      
      // Show card reveal animation
      _showCardReveal(newCard);
    }
  }

  Map<String, dynamic> _generateRandomCard(String packName) {
    final random = Random();
    final cardNames = ['Eco Warrior', 'Green Guardian', 'Nature Spirit', 'Earth Protector', 'Bio Defender'];
    final grades = ['A', 'B', 'C', 'D', 'E', 'F'];
    final rarities = ['Common', 'Rare', 'Epic', 'Legendary'];
    final colors = [Colors.green, Colors.blue, Colors.purple, Colors.orange, Colors.red, Colors.teal];
    final icons = ['🌟', '🛡️', '🌿', '⚡', '🔥', '💎'];
    
    return {
      'id': 'CARD${DateTime.now().millisecondsSinceEpoch}',
      'name': cardNames[random.nextInt(cardNames.length)],
      'grade': grades[random.nextInt(grades.length)],
      'rarity': rarities[random.nextInt(rarities.length)],
      'power': 50 + random.nextInt(50),
      'description': 'การ์ดพิเศษจาก $packName',
      'color': colors[random.nextInt(colors.length)],
      'icon': icons[random.nextInt(icons.length)],
      'date': DateTime.now(),
    };
  }

  void _showCardReveal(Map<String, dynamic> card) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: card['color'].withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🎉 ได้การ์ดใหม่! 🎉',
                style: GoogleFonts.kanit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: card['color'],
                ),
              ),
              const SizedBox(height: 20),
              Text(card['icon'], style: const TextStyle(fontSize: 80)),
              const SizedBox(height: 16),
              Text(
                card['name'],
                style: GoogleFonts.kanit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: card['color'],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: card['color'],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Grade ${card['grade']} • ${card['rarity']}',
                  style: GoogleFonts.kanit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: card['color'],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('เยี่ยม!', style: GoogleFonts.kanit(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ).animate().scale(duration: 600.ms).fadeIn(),
    );
  }
}
