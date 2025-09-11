import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/common_app_bar.dart';
import '../constants/app_constants.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'การตั้งค่าผู้ดูแล'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            'การตั้งค่าระบบ',
            [
              _buildSettingTile(
                'จัดการแต้มรางวัล',
                'ตั้งค่าอัตราการให้แต้ม',
                Icons.stars,
                () {},
              ),
              _buildSettingTile(
                'จัดการเลเวลผู้ใช้',
                'กำหนดเงื่อนไขการขึ้นเลเวล',
                Icons.trending_up,
                () {},
              ),
              _buildSettingTile(
                'การแจ้งเตือนระบบ',
                'ตั้งค่าการส่งการแจ้งเตือน',
                Icons.notifications,
                () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'การจัดการข้อมูล',
            [
              _buildSettingTile(
                'สำรองข้อมูล',
                'สำรองข้อมูลระบบ',
                Icons.backup,
                () => _showBackupDialog(context),
              ),
              _buildSettingTile(
                'นำเข้าข้อมูล',
                'นำเข้าข้อมูลจากไฟล์',
                Icons.file_upload,
                () {},
              ),
              _buildSettingTile(
                'ส่งออกรายงาน',
                'ส่งออกรายงานสถิติ',
                Icons.file_download,
                () => _showExportDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'ความปลอดภัย',
            [
              _buildSettingTile(
                'เปลี่ยนรหัสผ่าน',
                'เปลี่ยนรหัสผ่านผู้ดูแล',
                Icons.lock,
                () => _showChangePasswordDialog(context),
              ),
              _buildSettingTile(
                'ประวัติการเข้าสู่ระบบ',
                'ดูประวัติการเข้าใช้งาน',
                Icons.history,
                () {},
              ),
              _buildSettingTile(
                'การตั้งค่าความปลอดภัย',
                'จัดการการรักษาความปลอดภัย',
                Icons.security,
                () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'เกี่ยวกับระบบ',
            [
              _buildSettingTile(
                'ข้อมูลระบบ',
                'เวอร์ชัน 1.0.0',
                Icons.info,
                () => _showSystemInfoDialog(context),
              ),
              _buildSettingTile(
                'ติดต่อฝ่ายพัฒนา',
                'รายงานปัญหาหรือข้อเสนอแนะ',
                Icons.support,
                () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.kanit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppConstants.primaryGreen,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppConstants.primaryGreen),
      title: Text(title, style: GoogleFonts.kanit(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: GoogleFonts.kanit(fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showBackupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('สำรองข้อมูล', style: GoogleFonts.kanit()),
        content: Text(
          'คุณต้องการสำรองข้อมูลระบบหรือไม่?\nข้อมูลจะถูกส่งไปยังเซิร์ฟเวอร์สำรอง',
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('เริ่มสำรองข้อมูลแล้ว', style: GoogleFonts.kanit()),
                ),
              );
            },
            child: Text('สำรอง', style: GoogleFonts.kanit()),
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ส่งออกรายงาน', style: GoogleFonts.kanit()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('เลือกประเภทรายงานที่ต้องการส่งออก:', style: GoogleFonts.kanit()),
            const SizedBox(height: 16),
            ListTile(
              title: Text('รายงานผู้ใช้', style: GoogleFonts.kanit()),
              leading: Radio(value: 1, groupValue: 1, onChanged: (value) {}),
            ),
            ListTile(
              title: Text('รายงานแต้ม', style: GoogleFonts.kanit()),
              leading: Radio(value: 2, groupValue: 1, onChanged: (value) {}),
            ),
            ListTile(
              title: Text('รายงานกิจกรรม', style: GoogleFonts.kanit()),
              leading: Radio(value: 3, groupValue: 1, onChanged: (value) {}),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก', style: GoogleFonts.kanit()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('กำลังส่งออกรายงาน...', style: GoogleFonts.kanit()),
                ),
              );
            },
            child: Text('ส่งออก', style: GoogleFonts.kanit()),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('เปลี่ยนรหัสผ่าน', style: GoogleFonts.kanit()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'รหัสผ่านปัจจุบัน',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'รหัสผ่านใหม่',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'ยืนยันรหัสผ่านใหม่',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก', style: GoogleFonts.kanit()),
          ),
          ElevatedButton(
            onPressed: () {
              if (newPasswordController.text == confirmPasswordController.text) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('เปลี่ยนรหัสผ่านสำเร็จ', style: GoogleFonts.kanit()),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('รหัสผ่านไม่ตรงกัน', style: GoogleFonts.kanit()),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('เปลี่ยน', style: GoogleFonts.kanit()),
          ),
        ],
      ),
    );
  }

  void _showSystemInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ข้อมูลระบบ', style: GoogleFonts.kanit()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('ชื่อระบบ:', 'GreenPoint Admin'),
            _buildInfoRow('เวอร์ชัน:', '1.0.0'),
            _buildInfoRow('วันที่อัปเดต:', '2024-12-20'),
            _buildInfoRow('ผู้พัฒนา:', 'GreenPoint Team'),
            _buildInfoRow('ฐานข้อมูล:', 'MySQL 8.0'),
            _buildInfoRow('เซิร์ฟเวอร์:', 'AWS EC2'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ปิด', style: GoogleFonts.kanit()),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.kanit(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value, style: GoogleFonts.kanit()),
          ),
        ],
      ),
    );
  }
}
