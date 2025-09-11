import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/common_app_bar.dart';
import '../services/analytics_service.dart';
import '../constants/app_constants.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
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
      appBar: const CommonAppBar(title: 'สถิติการใช้งาน'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStats,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOverviewCards(),
                    const SizedBox(height: 24),
                    _buildUsageChart(),
                    const SizedBox(height: 24),
                    _buildDetailedStats(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildOverviewCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ภาพรวมการใช้งาน',
          style: GoogleFonts.kanit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildMetricCard('ผู้ใช้ทั้งหมด', '${_stats['totalUsers']}', Icons.people, Colors.blue),
            _buildMetricCard('การเข้าสู่ระบบ', '${_stats['loginCount']}', Icons.login, Colors.green),
            _buildMetricCard('สแกน QR', '${_stats['qrScans']}', Icons.qr_code_scanner, Colors.purple),
            _buildMetricCard('อัปเดตโปรไฟล์', '${_stats['profileUpdates']}', Icons.edit, Colors.orange),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.kanit(
                fontSize: 24,
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

  Widget _buildUsageChart() {
    final chartData = [
      _stats['loginCount'] as int,
      _stats['qrScans'] as int,
      _stats['profileUpdates'] as int,
      _stats['settingsChanges'] as int,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'การใช้งานฟีเจอร์',
              style: GoogleFonts.kanit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: chartData.reduce((a, b) => a > b ? a : b).toDouble() * 1.2,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const titles = ['เข้าสู่ระบบ', 'สแกน QR', 'อัปเดต', 'ตั้งค่า'];
                          return Text(
                            titles[value.toInt()],
                            style: GoogleFonts.kanit(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: chartData.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.toDouble(),
                          color: [Colors.blue, Colors.purple, Colors.orange, Colors.green][entry.key],
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'สถิติรายละเอียด',
              style: GoogleFonts.kanit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow('ผู้ใช้ที่สมัครสมาชิก', '${_stats['registrationCount']}', Icons.person_add),
            _buildStatRow('จำนวนครั้งที่เข้าสู่ระบบ', '${_stats['loginCount']}', Icons.login),
            _buildStatRow('การสแกน QR Code', '${_stats['qrScans']}', Icons.qr_code_scanner),
            _buildStatRow('การอัปเดตโปรไฟล์', '${_stats['profileUpdates']}', Icons.edit),
            _buildStatRow('การเปลี่ยนการตั้งค่า', '${_stats['settingsChanges']}', Icons.settings),
            _buildStatRow('แต้มรวมทั้งหมด', '${_stats['totalPoints']}', Icons.stars),
            _buildStatRow('พลาสติกที่ลดได้', '${(_stats['plasticReduced'] as double).toStringAsFixed(2)} กก.', Icons.eco),
            _buildStatRow('กิจกรรมทั้งหมด', '${_stats['totalActivities']}', Icons.event),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppConstants.primaryGreen),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.kanit(fontSize: 14),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.kanit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }
}
