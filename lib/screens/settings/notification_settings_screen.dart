import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import '../../constants/app_constants.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: 'การแจ้งเตือน',
        showBackButton: true,
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildNotificationTile(
                context,
                'การแจ้งเตือนทั่วไป',
                'รับการแจ้งเตือนเกี่ยวกับแอป',
                settings.notificationsEnabled,
                (value) => settings.setNotificationsEnabled(value),
              ),
              _buildNotificationTile(
                context,
                'การแจ้งเตือนแบบ Push',
                'แจ้งเตือนผ่านระบบ Push',
                settings.pushNotificationsEnabled,
                (value) => settings.setPushNotificationsEnabled(value),
              ),
              _buildNotificationTile(
                context,
                'การแจ้งเตือนทางอีเมล',
                'แจ้งเตือนผ่านอีเมล',
                settings.emailNotificationsEnabled,
                (value) => settings.setEmailNotificationsEnabled(value),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNotificationTile(
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
}
