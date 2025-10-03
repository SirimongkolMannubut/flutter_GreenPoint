import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/widgets.dart';
import '../../services/services.dart';
import '../../constants/app_constants.dart';

class FeatureUsageScreen extends StatefulWidget {
  const FeatureUsageScreen({super.key});

  @override
  State<FeatureUsageScreen> createState() => _FeatureUsageScreenState();
}

class _FeatureUsageScreenState extends State<FeatureUsageScreen> {
  List<Map<String, dynamic>> _featureUsage = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFeatureUsage();
  }

  Future<void> _loadFeatureUsage() async {
    final usage = await AnalyticsService.getFeatureUsage();
    setState(() {
      _featureUsage = usage;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: 'การใช้งานฟีเจอร์',
        showBackButton: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadFeatureUsage,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'สถิติการใช้งานฟีเจอร์ต่างๆ',
                    style: GoogleFonts.kanit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._featureUsage.map((feature) => _buildFeatureCard(feature)),
                  const SizedBox(height: 24),
                  _buildUsageTips(),
                ],
              ),
            ),
    );
  }

  Widget _buildFeatureCard(Map<String, dynamic> feature) {
    final count = feature['count'] as int;
    final maxCount = _featureUsage.map((f) => f['count'] as int).reduce((a, b) => a > b ? a : b);
    final percentage = maxCount > 0 ? (count / maxCount) : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  feature['icon'] as IconData,
                  color: AppConstants.primaryGreen,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    feature['feature'] as String,
                    style: GoogleFonts.kanit(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$count ครั้ง',
                    style: GoogleFonts.kanit(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryGreen),
            ),
            const SizedBox(height: 8),
            Text(
              '${(percentage * 100).toStringAsFixed(1)}% ของการใช้งานสูงสุด',
              style: GoogleFonts.kanit(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageTips() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Colors.orange,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'เคล็ดลับการวิเคราะห์',
                  style: GoogleFonts.kanit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTipItem('การสมัครสมาชิกสูง = ผู้ใช้ใหม่เข้ามาเยอะ'),
            _buildTipItem('การเข้าสู่ระบบสูง = ผู้ใช้กลับมาใช้งานบ่อย'),
            _buildTipItem('สแกน QR สูง = ฟีเจอร์หลักได้รับความนิยม'),
            _buildTipItem('อัปเดตโปรไฟล์สูง = ผู้ใช้มีส่วนร่วมกับแอป'),
            _buildTipItem('เปลี่ยนการตั้งค่าสูง = ผู้ใช้ปรับแต่งตามความต้องการ'),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: AppConstants.primaryGreen,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: GoogleFonts.kanit(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
