import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_constants.dart';
import '../../widgets/widgets.dart';
import 'stores_map_screen.dart';

class PartnerStoresScreen extends StatefulWidget {
  const PartnerStoresScreen({super.key});

  @override
  State<PartnerStoresScreen> createState() => _PartnerStoresScreenState();
}

class _PartnerStoresScreenState extends State<PartnerStoresScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoreProvider>().loadStores();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const CommonAppBar(
        title: 'ร้านค้าพาร์ทเนอร์',
        showBackButton: true,
      ),
      body: Consumer<StoreProvider>(
        builder: (context, storeProvider, child) {
          if (storeProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppConstants.primaryGreen,
              ),
            );
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ทั้งหมด ${storeProvider.stores.length} ร้าน',
                      style: GoogleFonts.kanit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.darkGreen,
                      ),
                    ),
                    if (storeProvider.stores.isEmpty)
                      IconButton(
                        onPressed: () => storeProvider.loadStores(),
                        icon: const Icon(Icons.refresh, color: AppConstants.primaryGreen),
                      ),
                  ],
                ),
              ),
              _buildSearchBar(storeProvider),
              _buildCategoryFilter(storeProvider),
              Expanded(
                child: _buildMainMap(storeProvider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(StoreProvider storeProvider) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: TextField(
        onChanged: storeProvider.searchStores,
        decoration: InputDecoration(
          hintText: 'ค้นหาร้านค้า...',
          hintStyle: GoogleFonts.kanit(),
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        style: GoogleFonts.kanit(),
      ),
    );
  }

  Widget _buildCategoryFilter(StoreProvider storeProvider) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
              side: const BorderSide(color: AppConstants.primaryGreen),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStoresList(StoreProvider storeProvider) {
    if (storeProvider.stores.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.store_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'ไม่พบร้านค้า',
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
        return _buildStoreCard(store, index);
      },
    );
  }

  Widget _buildStoreCard(store, int index) {
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
                      color: AppConstants.primaryGreen.withOpacity(0.1),
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
                        Text(
                          store.category,
                          style: GoogleFonts.kanit(
                            fontSize: 14,
                            color: AppConstants.primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.orange[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              store.rating.toString(),
                              style: GoogleFonts.kanit(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (store.discount != null && store.discount!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'ส่วนลด',
                        style: GoogleFonts.kanit(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey[600],
                  ),
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
              if (store.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: store.tags.take(3).map<Widget>((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.kanit(
                          fontSize: 10,
                          color: AppConstants.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate(delay: (index * 100).ms).fadeIn(duration: 400.ms).slideX(begin: 0.3, end: 0);
  }

  void _showStoreDetails(store) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppConstants.primaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              store.emoji,
                              style: const TextStyle(fontSize: 40),
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
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstants.darkGreen,
                                ),
                              ),
                              Text(
                                store.category,
                                style: GoogleFonts.kanit(
                                  fontSize: 16,
                                  color: AppConstants.primaryGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 20,
                                    color: Colors.orange[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    store.rating.toString(),
                                    style: GoogleFonts.kanit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.orange[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'รายละเอียด',
                      style: GoogleFonts.kanit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.darkGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      store.description,
                      style: GoogleFonts.kanit(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildDetailRow(Icons.location_on, 'ที่อยู่', store.address),
                    _buildDetailRow(Icons.phone, 'โทรศัพท์', store.phone),
                    if (store.openHours != null && store.openHours!.isNotEmpty)
                      _buildDetailRow(Icons.access_time, 'เวลาเปิด-ปิด', store.openHours!),
                    const SizedBox(height: 16),
                    _buildStoreMap(store),
                    const SizedBox(height: 16),
                    _buildNavigationButton(store),
                    if (store.discount != null && store.discount!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.local_offer, color: Colors.red[600], size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'โปรโมชั่นพิเศษ',
                                  style: GoogleFonts.kanit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              store.discount!,
                              style: GoogleFonts.kanit(
                                fontSize: 14,
                                color: Colors.red[700],
                              ),
                            ),
                            if (store.pointsRequired > 0) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'ใช้ ${store.pointsRequired} แต้ม',
                                  style: GoogleFonts.kanit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                    if (store.tags.isNotEmpty) ...[
                      const SizedBox(height: 24),
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
                        runSpacing: 8,
                        children: store.tags.map<Widget>((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppConstants.primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              tag,
                              style: GoogleFonts.kanit(
                                fontSize: 12,
                                color: AppConstants.primaryGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.kanit(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.kanit(
                    fontSize: 14,
                    color: AppConstants.darkGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreMap(store) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Colors.grey[100],
          child: InkWell(
            onTap: () {
              final url = 'https://www.openstreetmap.org/#map=16/${store.latitude}/${store.longitude}';
              launchUrl(Uri.parse(url));
            },
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map, size: 48, color: AppConstants.primaryGreen),
                      const SizedBox(height: 8),
                      Text(
                        'ตำแหน่งของ ${store.name}',
                        style: GoogleFonts.kanit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.darkGreen,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'แตะเพื่อดูแผนที่',
                        style: GoogleFonts.kanit(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.open_in_new,
                      size: 16,
                      color: AppConstants.primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainMap(StoreProvider storeProvider) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Container(
              color: Colors.grey[100],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 64, color: AppConstants.primaryGreen),
                    const SizedBox(height: 16),
                    Text(
                      'แผนที่ร้านค้าพาร์ทเนอร์',
                      style: GoogleFonts.kanit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.darkGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (storeProvider.stores.isNotEmpty)
                      Text(
                        'พบ ${storeProvider.stores.length} ร้านค้า',
                        style: GoogleFonts.kanit(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        final lat = storeProvider.stores.isNotEmpty ? storeProvider.stores.first.latitude : 13.7563;
                        final lng = storeProvider.stores.isNotEmpty ? storeProvider.stores.first.longitude : 100.5018;
                        final url = 'https://www.openstreetmap.org/#map=15/$lat/$lng';
                        launchUrl(Uri.parse(url));
                      },
                      icon: const Icon(Icons.open_in_new),
                      label: Text('เปิดแผนที่', style: GoogleFonts.kanit()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryGreen,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (storeProvider.stores.isNotEmpty)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Container(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: storeProvider.stores.length,
                    itemBuilder: (context, index) {
                      final store = storeProvider.stores[index];
                      return Container(
                        width: 200,
                        margin: const EdgeInsets.only(right: 8),
                        child: Card(
                          child: InkWell(
                            onTap: () => _showStoreDetails(store),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(store.emoji, style: const TextStyle(fontSize: 20)),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          store.name,
                                          style: GoogleFonts.kanit(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    store.category,
                                    style: GoogleFonts.kanit(
                                      fontSize: 12,
                                      color: AppConstants.primaryGreen,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, size: 12, color: Colors.grey[600]),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          store.address,
                                          style: GoogleFonts.kanit(
                                            fontSize: 10,
                                            color: Colors.grey[600],
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(store) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _openNavigation(store),
        icon: const Icon(Icons.navigation),
        label: Text(
          'นำทางไปร้านค้า',
          style: GoogleFonts.kanit(fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _openNavigation(store) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('พิกัด: ${store.latitude}, ${store.longitude}', style: GoogleFonts.kanit()),
        backgroundColor: AppConstants.primaryGreen,
        action: SnackBarAction(
          label: 'คัดลอก',
          textColor: Colors.white,
          onPressed: () {
            Clipboard.setData(ClipboardData(text: '${store.latitude},${store.longitude}'));
          },
        ),
      ),
    );
    
    // เปิด Google Maps โดยตรง
    final url = 'https://www.google.com/maps/search/?api=1&query=${store.latitude},${store.longitude}';
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication).catchError((e) {
      // ถ้าเปิดไม่ได้ให้แสดงข้อความ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ไม่สามารถเปิดแผนที่ได้ พิกัดถูกคัดลอกแล้ว', style: GoogleFonts.kanit()),
          backgroundColor: Colors.orange,
        ),
      );
      Clipboard.setData(ClipboardData(text: '${store.latitude},${store.longitude}'));
    });
  }
}
