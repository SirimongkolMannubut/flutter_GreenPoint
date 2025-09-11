import 'package:flutter/material.dart';
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/settings_provider.dart';
import '../providers/api_user_provider.dart';
import '../constants/app_constants.dart';
import '../widgets/common_app_bar.dart';
import 'language_screen.dart';
import 'notification_settings_screen.dart';
import 'security_settings_screen.dart';
import 'about_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SettingsProvider>(context, listen: false).loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CommonAppBar(
        title: context.watch<SettingsProvider>().translate('settings'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          if (settingsProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppConstants.primaryGreen,
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildUserCard(),
                const SizedBox(height: 20),
                _buildSettingsSection(
                  settingsProvider.translate('preferences'),
                  [
                    _buildSettingItem(
                      Icons.language,
                      settingsProvider.translate('language'),
                      _getLanguageName(settingsProvider.currentLanguage),
                      () => _navigateToLanguageSettings(),
                    ),
                    _buildSettingItem(
                      Icons.notifications_outlined,
                      settingsProvider.translate('notifications'),
                      settingsProvider.notificationsEnabled 
                          ? settingsProvider.translate('enabled')
                          : settingsProvider.translate('disabled'),
                      () => _navigateToNotificationSettings(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSettingsSection(
                  settingsProvider.translate('security'),
                  [
                    _buildSettingItem(
                      Icons.security,
                      settingsProvider.translate('security'),
                      settingsProvider.translate('manage_security'),
                      () => _navigateToSecuritySettings(),
                    ),
                    _buildSettingItem(
                      Icons.fingerprint,
                      settingsProvider.translate('biometric_login'),
                      settingsProvider.biometricEnabled 
                          ? settingsProvider.translate('enabled')
                          : settingsProvider.translate('disabled'),
                      () => _toggleBiometric(settingsProvider),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSettingsSection(
                  settingsProvider.translate('support'),
                  [
                    _buildSettingItem(
                      Icons.help_outline,
                      settingsProvider.translate('help'),
                      settingsProvider.translate('faq_support'),
                      () => _showHelp(),
                    ),
                    _buildSettingItem(
                      Icons.info_outline,
                      settingsProvider.translate('about'),
                      settingsProvider.translate('app_info'),
                      () => _navigateToAbout(),
                    ),
                    _buildSettingItem(
                      Icons.star_outline,
                      settingsProvider.translate('rate_app'),
                      settingsProvider.translate('rate_on_store'),
                      () => _rateApp(),
                    ),
                    _buildSettingItem(
                      Icons.share_outlined,
                      settingsProvider.translate('share_app'),
                      settingsProvider.translate('share_with_friends'),
                      () => _shareApp(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSettingsSection(
                  settingsProvider.translate('legal'),
                  [
                    _buildSettingItem(
                      Icons.privacy_tip_outlined,
                      settingsProvider.translate('privacy_policy'),
                      settingsProvider.translate('view_privacy'),
                      () => _showPrivacyPolicy(),
                    ),
                    _buildSettingItem(
                      Icons.description_outlined,
                      settingsProvider.translate('terms_of_service'),
                      settingsProvider.translate('view_terms'),
                      () => _showTermsOfService(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildDangerSection(settingsProvider),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserCard() {
    return Consumer<UserProvider>(
      builder: (context, UserProvider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppConstants.primaryGreen, AppConstants.lightGreen],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppConstants.primaryGreen.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      UserProvider.user?.name ?? 'ผู้ใช้งาน',
                      style: GoogleFonts.kanit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      UserProvider.user?.email ?? '',
                      style: GoogleFonts.kanit(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Level ${UserProvider.level} • ${UserProvider.totalPoints} แต้ม',
                      style: GoogleFonts.kanit(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
      },
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: GoogleFonts.kanit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.darkGreen,
              ),
            ),
          ),
          ...items,
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms);
  }

  Widget _buildSettingItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppConstants.primaryGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: AppConstants.primaryGreen,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.kanit(
          fontWeight: FontWeight.w600,
          color: AppConstants.darkGreen,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.kanit(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDangerSection(SettingsProvider settingsProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              settingsProvider.translate('danger_zone'),
              style: GoogleFonts.kanit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.refresh,
                color: Colors.red,
                size: 20,
              ),
            ),
            title: Text(
              settingsProvider.translate('reset_settings'),
              style: GoogleFonts.kanit(
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            subtitle: Text(
              settingsProvider.translate('reset_all_settings'),
              style: GoogleFonts.kanit(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.red,
            ),
            onTap: () => _showResetDialog(settingsProvider),
          ),
          Consumer<UserProvider>(
            builder: (context, UserProvider, child) {
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
                title: Text(
                  settingsProvider.translate('logout'),
                  style: GoogleFonts.kanit(
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
                subtitle: Text(
                  settingsProvider.translate('sign_out_account'),
                  style: GoogleFonts.kanit(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.red,
                ),
                onTap: () => _showLogoutDialog(UserProvider, settingsProvider),
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms);
  }

  String _getLanguageName(String code) {
    final languages = context.read<SettingsProvider>().getSupportedLanguages();
    return languages.firstWhere((lang) => lang['code'] == code)['name'] ?? code;
  }

  void _navigateToLanguageSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LanguageScreen()),
    );
  }

  void _navigateToNotificationSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()),
    );
  }

  void _navigateToSecuritySettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SecuritySettingsScreen()),
    );
  }

  void _navigateToAbout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AboutScreen()),
    );
  }

  void _toggleBiometric(SettingsProvider settingsProvider) async {
    try {
      await settingsProvider.setBiometricEnabled(!settingsProvider.biometricEnabled);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            settingsProvider.biometricEnabled 
                ? settingsProvider.translate('biometric_enabled')
                : settingsProvider.translate('biometric_disabled'),
            style: GoogleFonts.kanit(),
          ),
          backgroundColor: AppConstants.primaryGreen,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            settingsProvider.translate('biometric_error'),
            style: GoogleFonts.kanit(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showHelp() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
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
              'ช่วยเหลือ',
              style: GoogleFonts.kanit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppConstants.darkGreen,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildHelpItem('วิธีการสะสมแต้ม', 'สแกน QR Code ที่ร้านค้าพาร์ทเนอร์'),
                  _buildHelpItem('การแลกของรางวัล', 'ใช้แต้มที่สะสมได้เพื่อแลกของรางวัล'),
                  _buildHelpItem('การเปลี่ยนรหัสผ่าน', 'ไปที่ตั้งค่า > ความปลอดภัย'),
                  _buildHelpItem('ติดต่อฝ่ายสนับสนุน', 'support@greenpoint.com'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: GoogleFonts.kanit(
          fontWeight: FontWeight.w600,
          color: AppConstants.darkGreen,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            answer,
            style: GoogleFonts.kanit(
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  void _rateApp() async {
    const url = 'https://play.google.com/store/apps/details?id=com.example.flutter_greenpoint';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _shareApp() {
    Share.share(
      'ดาวน์โหลดแอป GreenPoint เพื่อสะสมแต้มจากการลดการใช้พลาสติก!\nhttps://play.google.com/store/apps/details?id=com.example.flutter_greenpoint',
      subject: 'GreenPoint - แอปสะสมแต้มเพื่อสิ่งแวดล้อม',
    );
  }

  void _showPrivacyPolicy() async {
    const url = 'https://greenpoint.com/privacy';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _showTermsOfService() async {
    const url = 'https://greenpoint.com/terms';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _showResetDialog(SettingsProvider settingsProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'รีเซ็ตการตั้งค่า',
          style: GoogleFonts.kanit(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: Text(
          'คุณต้องการรีเซ็ตการตั้งค่าทั้งหมดหรือไม่? การดำเนินการนี้ไม่สามารถย้อนกลับได้',
          style: GoogleFonts.kanit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'ยกเลิก',
              style: GoogleFonts.kanit(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await settingsProvider.resetAllSettings();
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'รีเซ็ตการตั้งค่าสำเร็จ',
                    style: GoogleFonts.kanit(),
                  ),
                  backgroundColor: AppConstants.primaryGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'รีเซ็ต',
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

  void _showLogoutDialog(UserProvider UserProvider, SettingsProvider settingsProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          settingsProvider.translate('logout'),
          style: GoogleFonts.kanit(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: Text(
          settingsProvider.translate('logout_confirmation'),
          style: GoogleFonts.kanit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              settingsProvider.translate('cancel'),
              style: GoogleFonts.kanit(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              UserProvider.logout();
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              settingsProvider.translate('logout'),
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
}
