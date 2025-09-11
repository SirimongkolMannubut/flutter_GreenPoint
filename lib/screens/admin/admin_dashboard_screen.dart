import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import '../../constants/app_constants.dart';
import '../../services/services.dart';
import 'user_management_screen.dart';
import 'admin_settings_screen.dart';
import '../analytics/analytics_screen.dart';
import '../analytics/feature_usage_screen.dart';
import '../analytics/system_logs_screen.dart';
import 'admin_add_points_screen.dart';
import 'admin_add_store_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await AnalyticsService.getRealTimeStats();
    setState(() {
      _stats = stats;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'แดชบอร์ดผู้ดูแล',
          style: GoogleFonts.kanit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppConstants.primaryGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<AdminProvider>(
              builder: (context, adminProvider, child) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppConstants.primaryGreen,
                          child: Text(
                            adminProvider.currentAdmin?.name.substring(0, 1) ?? 'A',
                            style: GoogleFonts.kanit(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'สวัสดี, ${adminProvider.currentAdmin?.name ?? 'ผู้ดูแล'}',
                                style: GoogleFonts.kanit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                adminProvider.currentAdmin?.email ?? '',
                                style: GoogleFonts.kanit(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppConstants.primaryGreen.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  adminProvider.currentAdmin?.role ?? 'admin',
                                  style: GoogleFonts.kanit(
                                    fontSize: 12,
                                    color: AppConstants.primaryGreen,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              'สถิติรวม',
              style: GoogleFonts.kanit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'ผู้ใช้ทั้งหมด',
                      '${_stats['totalUsers']}',
                      Icons.people,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'แต้มรวม',
                      '${_stats['totalPoints']}',
                      Icons.stars,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'พลาสติกที่ลด',
                      '${(_stats['plasticReduced'] as double).toStringAsFixed(1)} กก.',
                      Icons.eco,
                      AppConstants.primaryGreen,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'กิจกรรม',
                      '${_stats['totalActivities']}',
                      Icons.event,
                      Colors.purple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'สแกน QR',
                      '${_stats['qrScans']}',
                      Icons.qr_code_scanner,
                      Colors.indigo,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'การเข้าสู่ระบบ',
                      '${_stats['loginCount']}',
                      Icons.login,
                      Colors.teal,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            Text(
              'เมนูจัดการ',
              style: GoogleFonts.kanit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.kanit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.kanit(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    final menuItems = [
      {'title': 'จัดการผู้ใช้', 'icon': Icons.people, 'color': Colors.blue, 'screen': const UserManagementScreen()},
      {'title': 'เพิ่มแต้มผู้ใช้', 'icon': Icons.stars, 'color': Colors.amber, 'screen': const AdminAddPointsScreen()},
      {'title': 'เพิ่มร้านค้า', 'icon': Icons.store, 'color': Colors.green, 'screen': const AdminAddStoreScreen()},
      {'title': 'สถิติการใช้งาน', 'icon': Icons.analytics, 'color': Colors.indigo, 'screen': const AnalyticsScreen()},
      {'title': 'การใช้ฟีเจอร์', 'icon': Icons.bar_chart, 'color': Colors.purple, 'screen': const FeatureUsageScreen()},
      {'title': 'ล็อกระบบ', 'icon': Icons.history, 'color': Colors.orange, 'screen': const SystemLogsScreen()},
      {'title': 'การตั้งค่า', 'icon': Icons.settings, 'color': Colors.grey, 'screen': const AdminSettingsScreen()},
      {'title': 'รีเฟรชข้อมูล', 'icon': Icons.refresh, 'color': Colors.teal, 'screen': null, 'action': 'refresh'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return Card(
          child: InkWell(
            onTap: () async {
              if (item['action'] == 'refresh') {
                setState(() {
                  _isLoading = true;
                });
                await _loadStats();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('รีเฟรชข้อมูลสำเร็จ', style: GoogleFonts.kanit()),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (item['screen'] != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => item['screen'] as Widget),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item['title']} จะพร้อมใช้งานในเร็วๆ นี้'),
                  ),
                );
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item['icon'] as IconData,
                    size: 32,
                    color: item['color'] as Color,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['title'] as String,
                    style: GoogleFonts.kanit(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ออกจากระบบ', style: GoogleFonts.kanit()),
        content: Text('คุณต้องการออกจากระบบผู้ดูแลหรือไม่?', style: GoogleFonts.kanit()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก', style: GoogleFonts.kanit()),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AdminProvider>().logoutAdmin();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text('ออกจากระบบ', style: GoogleFonts.kanit()),
          ),
        ],
      ),
    );
  }
}
