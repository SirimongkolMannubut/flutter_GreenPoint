import 'package:flutter/material.dart';
import '../../providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_constants.dart';

import '../../models/models.dart';
import '../../widgets/widgets.dart';
import 'home_screen.dart';


import 'profile_screen.dart';
import '../rewards/rewards_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const PartnerStoreScreen(),
    const RewardsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          body: _screens[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppConstants.primaryGreen,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.kanit(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: GoogleFonts.kanit(
          fontSize: 12,
        ),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: settings.translate('home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.store),
            label: settings.translate('partner_store'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.card_giftcard),
            label: settings.translate('rewards'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: settings.translate('profile'),
          ),
        ],
      ),
        );
      },
    );
  }
}

class PartnerStoreScreen extends StatefulWidget {
  const PartnerStoreScreen({super.key});

  @override
  State<PartnerStoreScreen> createState() => _PartnerStoreScreenState();
}

class _PartnerStoreScreenState extends State<PartnerStoreScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CommonAppBar(
        title: 'ร้านค้าพาร์ทเนอร์',
      ),
      body: Column(
        children: [
          _buildTabBar(),
          _buildSearchAndFilter(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildStoreList(),
                _buildMapView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppConstants.primaryGreen,
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        indicatorWeight: 3,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white60,
        labelStyle: GoogleFonts.kanit(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        unselectedLabelStyle: GoogleFonts.kanit(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        tabs: const [
          Tab(
            icon: Icon(Icons.store, size: 20),
            text: 'รายชื่อร้าน',
          ),
          Tab(
            icon: Icon(Icons.map_outlined, size: 20),
            text: 'แผนที่ร้าน',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 12),
          _buildCategoryFilter(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Consumer<StoreProvider>(
      builder: (context, storeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => storeProvider.searchStores(value),
            decoration: InputDecoration(
              hintText: 'ค้นหาร้านค้า...',
              hintStyle: GoogleFonts.kanit(color: Colors.grey[500]),
              prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey[500]),
                      onPressed: () {
                        _searchController.clear();
                        storeProvider.searchStores('');
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            style: GoogleFonts.kanit(),
          ),
        );
      },
    );
  }

  Widget _buildCategoryFilter() {
    return Consumer<StoreProvider>(
      builder: (context, storeProvider, child) {
        return SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: storeProvider.categories.length,
            itemBuilder: (context, index) {
              final category = storeProvider.categories[index];
              final isSelected = category == storeProvider.selectedCategory;
              
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(
                    category,
                    style: GoogleFonts.kanit(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppConstants.primaryGreen,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    storeProvider.filterByCategory(category);
                  },
                  backgroundColor: Colors.white,
                  selectedColor: AppConstants.primaryGreen,
                  checkmarkColor: Colors.white,
                  side: BorderSide(color: AppConstants.primaryGreen),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildStoreList() {
    return Consumer<StoreProvider>(
      builder: (context, storeProvider, child) {
        if (storeProvider.stores.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('🔍', style: const TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                Text(
                  'ไม่พบร้านค้าที่ค้นหา',
                  style: GoogleFonts.kanit(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: storeProvider.stores.length,
          itemBuilder: (context, index) {
            final store = storeProvider.stores[index];
            return _buildStoreCard(store).animate(delay: (index * 100).ms)
                .fadeIn(duration: 400.ms)
                .slideX(begin: 0.3, end: 0);
          },
        );
      },
    );
  }

  Widget _buildStoreCard(PartnerStore store) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _showStoreDetails(store),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppConstants.primaryGreen.withOpacity(0.1), AppConstants.lightGreen.withOpacity(0.1)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        store.emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          store.name,
                          style: GoogleFonts.kanit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.darkGreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              store.rating.toString(),
                              style: GoogleFonts.kanit(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.amber[700],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppConstants.primaryGreen.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                store.category,
                                style: GoogleFonts.kanit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppConstants.primaryGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                store.description,
                style: GoogleFonts.kanit(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.grey[500], size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      store.address,
                      style: GoogleFonts.kanit(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.orange, Colors.deepOrange],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      store.discount,
                      style: GoogleFonts.kanit(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    '${store.pointsRequired} แต้ม',
                    style: GoogleFonts.kanit(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.primaryGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapView() {
    return Consumer<StoreProvider>(
      builder: (context, storeProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppConstants.primaryGreen.withOpacity(0.1),
                      AppConstants.lightGreen.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppConstants.primaryGreen.withOpacity(0.2)),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('🗺️', style: const TextStyle(fontSize: 48)),
                      const SizedBox(height: 12),
                      Text(
                        'แผนที่ตั้งร้านค้าพาร์ทเนอร์',
                        style: GoogleFonts.kanit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.darkGreen,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ร้านค้าที่เข้าร่วมโครงการ GreenPoint',
                        style: GoogleFonts.kanit(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryGreen,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'ทั้งหมด ${storeProvider.stores.length} ร้าน',
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
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'รายชื่อร้านทั้งหมด',
                    style: GoogleFonts.kanit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.darkGreen,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${storeProvider.stores.length} ร้าน',
                    style: GoogleFonts.kanit(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: storeProvider.stores.length,
                  itemBuilder: (context, index) {
                    final store = storeProvider.stores[index];
                    return _buildMapStoreItem(store, index);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMapStoreItem(PartnerStore store, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppConstants.primaryGreen.withOpacity(0.1),
                AppConstants.lightGreen.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(store.emoji, style: const TextStyle(fontSize: 24)),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                store.name,
                style: GoogleFonts.kanit(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppConstants.darkGreen,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppConstants.primaryGreen,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '#${index + 1}',
                style: GoogleFonts.kanit(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                Text(
                  store.rating.toString(),
                  style: GoogleFonts.kanit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.amber[700],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  store.category,
                  style: GoogleFonts.kanit(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              store.address,
              style: GoogleFonts.kanit(
                fontSize: 11,
                color: Colors.grey[500],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              color: AppConstants.primaryGreen,
              size: 20,
            ),
            Text(
              'ดูแผนที่',
              style: GoogleFonts.kanit(
                fontSize: 10,
                color: AppConstants.primaryGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        onTap: () => _showStoreDetails(store),
      ),
    ).animate(delay: (index * 50).ms)
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.2, end: 0);
  }

  void _showStoreDetails(PartnerStore store) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildStoreDetailsSheet(store),
    );
  }

  Widget _buildStoreDetailsSheet(PartnerStore store) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(store.emoji, style: const TextStyle(fontSize: 40)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              store.name,
                              style: GoogleFonts.kanit(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.darkGreen,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  store.rating.toString(),
                                  style: GoogleFonts.kanit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.amber[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildDetailSection('คำอธิบาย', store.description),
                  _buildDetailSection('ที่อยู่', store.address),
                  _buildDetailSection('โทรศัพท์', store.phone),
                  _buildDetailSection('เวลาเปิด', store.openHours),
                  _buildDetailSection('ส่วนลด', store.discount),
                  const SizedBox(height: 20),
                  Text(
                    'แท็ก',
                    style: GoogleFonts.kanit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.darkGreen,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: store.tags.map((tag) => Chip(
                      label: Text(
                        tag,
                        style: GoogleFonts.kanit(
                          fontSize: 12,
                          color: AppConstants.primaryGreen,
                        ),
                      ),
                      backgroundColor: AppConstants.primaryGreen.withOpacity(0.1),
                      side: BorderSide(color: AppConstants.primaryGreen.withOpacity(0.3)),
                    )).toList(),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.directions),
                          label: Text(
                            'นำทาง',
                            style: GoogleFonts.kanit(fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.phone),
                          label: Text(
                            'โทร',
                            style: GoogleFonts.kanit(fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.kanit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppConstants.darkGreen,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: GoogleFonts.kanit(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}



