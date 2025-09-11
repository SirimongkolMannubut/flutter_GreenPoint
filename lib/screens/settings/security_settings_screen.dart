import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import '../../constants/app_constants.dart';

class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'ความปลอดภัย'),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSecurityTile(
                context,
                'การยืนยันตัวตนด้วยลายนิ้วมือ',
                'ใช้ลายนิ้วมือเพื่อเข้าสู่แอป',
                settings.biometricEnabled,
                (value) => settings.setBiometricEnabled(value),
              ),
              _buildSecurityTile(
                context,
                'การยืนยันตัวตน 2 ขั้นตอน',
                'เพิ่มความปลอดภัยในการเข้าสู่ระบบ',
                settings.twoFactorEnabled,
                (value) => settings.setTwoFactorEnabled(value),
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.lock_reset, color: AppConstants.primaryGreen),
                  title: Text(
                    'เปลี่ยนรหัสผ่าน',
                    style: GoogleFonts.kanit(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'อัปเดตรหัสผ่านของคุณ',
                    style: GoogleFonts.kanit(color: Colors.grey[600]),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _showChangePasswordDialog(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSecurityTile(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Card(
      child: SwitchListTile(
        title: Text(
          title,
          style: GoogleFonts.kanit(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.kanit(color: Colors.grey[600]),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppConstants.primaryGreen,
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('เปลี่ยนรหัสผ่าน', style: GoogleFonts.kanit()),
        content: Text('ฟีเจอร์นี้จะพร้อมใช้งานในเร็วๆ นี้', style: GoogleFonts.kanit()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ตกลง', style: GoogleFonts.kanit()),
          ),
        ],
      ),
    );
  }
}
