import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../providers/providers.dart';
import '../../constants/app_constants.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void _showScanOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'เลือกวิธีการสแกน',
              style: GoogleFonts.kanit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.darkGreen,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildScanOption(
                  context,
                  'สแกนด้วยกล้อง',
                  Icons.camera_alt,
                  AppConstants.primaryGreen,
                  () => _scanWithCamera(context),
                ),
                _buildScanOption(
                  context,
                  'เลือกจากแกลเลอรี่',
                  Icons.photo_library,
                  AppConstants.accentGreen,
                  () => _pickFromGallery(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildScanOption(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.kanit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _scanWithCamera(BuildContext context) async {
    Navigator.pop(context);
    
    final cameraStatus = await Permission.camera.request();
    if (cameraStatus.isGranted) {
      final result = await Navigator.push<String>(
        context,
        MaterialPageRoute(builder: (context) => const QRScannerScreen()),
      );
      
      if (result != null && context.mounted) {
        _showScanResult(context, result, 'QR Code');
      }
    } else {
      if (context.mounted) {
        _showPermissionDenied(context, 'กล้อง');
      }
    }
  }

  void _pickFromGallery(BuildContext context) async {
    Navigator.pop(context);
    
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null && context.mounted) {
        _showScanResult(context, image.path, 'รูปภาพ');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'เกิดข้อผิดพลาดในการเลือกรูปภาพ',
              style: GoogleFonts.kanit(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showScanResult(BuildContext context, String result, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppConstants.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                type == 'QR Code' ? Icons.qr_code : Icons.image,
                color: AppConstants.primaryGreen,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'ผลลัพธ์ $type',
              style: GoogleFonts.kanit(
                fontWeight: FontWeight.bold,
                color: AppConstants.darkGreen,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                result,
                style: GoogleFonts.kanit(
                  fontSize: 14,
                  color: AppConstants.darkGreen,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '✅ สแกนสำเร็จ! คุณได้รับ 10 แต้ม',
              style: GoogleFonts.kanit(
                fontSize: 14,
                color: AppConstants.primaryGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'ปิด',
              style: GoogleFonts.kanit(
                color: Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'ใช้งาน',
              style: GoogleFonts.kanit(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPermissionDenied(BuildContext context, String permission) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'กรุณาอนุญาตการใช้งาน$permission เพื่อใช้ฟีเจอร์นี้',
          style: GoogleFonts.kanit(),
        ),
        backgroundColor: Colors.orange,
        action: SnackBarAction(
          label: 'ตั้งค่า',
          textColor: Colors.white,
          onPressed: () => openAppSettings(),
        ),
      ),
    );
  }

  void _showStores() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PartnerStoresScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: 'หน้าหลัก',
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          try {
            if (userProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppConstants.primaryGreen,
                ),
              );
            }

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF2E7D32).withOpacity(0.1),
                    Colors.white,
                    const Color(0xFFF1F8E9),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
                child: Column(
                  children: [
                    _buildProfileCard(userProvider),
                    const SizedBox(height: 20),
                    _buildShortcutMenu(),
                    const SizedBox(height: 20),
                    _buildPromotionBanner(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            );
          } catch (e) {
            debugPrint('Error in HomeScreen: $e');
            return const Center(
              child: Text('เกิดข้อผิดพลาด กรุณาลองใหม่'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showScanOptions(context),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 8,
        icon: CustomQRIcon(size: 20, color: Colors.white),
        label: Text(
          'สแกน QR',
          style: GoogleFonts.kanit(
            fontWeight: FontWeight.bold,
          ),
        ),
      ).animate().scale(delay: 800.ms, duration: 400.ms),
    );
  }

  Widget _buildProfileCard(UserProvider userProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppConstants.primaryGreen, AppConstants.lightGreen, AppConstants.accentGreen],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryGreen.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: RankBadge(
                  level: userProvider.level,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'สวัสดี, ${userProvider.user?.name ?? 'ขวัญ'}!',
                      style: GoogleFonts.kanit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'ID: ${userProvider.userId}',
                      style: GoogleFonts.kanit(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'แต้มสะสม',
                    style: GoogleFonts.kanit(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    '${userProvider.totalPoints} แต้ม',
                    style: GoogleFonts.kanit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.eco,
                color: Colors.white70,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'พลาสติกที่ลดได้: ${userProvider.plasticReduced.toStringAsFixed(1)} กรัม',
                style: GoogleFonts.kanit(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildShortcutMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildShortcutItemWithCustomIcon('Scan QR', () => _showScanOptions(context)),
        _buildShortcutItem('ร้านค้า', Icons.store, () => _showStores(), '🏪'),
        _buildShortcutItem('แลกของ', Icons.card_giftcard, () {}, '🎁'),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms);
  }

  Widget _buildShortcutItemWithCustomIcon(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppConstants.primaryGreen.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppConstants.primaryGreen.withOpacity(0.1),
                    AppConstants.lightGreen.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomQRIcon(
                size: 28,
                color: AppConstants.primaryGreen,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.kanit(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppConstants.darkGreen,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutItem(String title, IconData icon, VoidCallback onTap, String emoji) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppConstants.primaryGreen.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppConstants.primaryGreen.withOpacity(0.1),
                    AppConstants.lightGreen.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 28)),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.kanit(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppConstants.darkGreen,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotionBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.orange, Colors.deepOrange, Colors.red],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('🎉', style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'โปรโมชั่นพิเศษ!',
                  style: GoogleFonts.kanit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'รับแต้ม X2 ทุกกิจกรรมสิ่งแวดล้อม',
                  style: GoogleFonts.kanit(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms);
  }


}