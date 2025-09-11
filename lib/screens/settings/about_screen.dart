import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/widgets.dart';
import '../../constants/app_constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'เกี่ยวกับแอป'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 32),
            const GreenPointLogo(size: 100),
            const SizedBox(height: 16),
            Text(
              'GreenPoint',
              style: GoogleFonts.kanit(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryGreen,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'เวอร์ชัน 1.0.0',
              style: GoogleFonts.kanit(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'เกี่ยวกับ GreenPoint',
                      style: GoogleFonts.kanit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'แอปสะสมแต้มเพื่อรณรงค์ลดการใช้พลาสติกในงานแฟร์และงานชุมชนของจังหวัด ช่วยให้ผู้ใช้สามารถติดตามการลดการใช้พลาสติกและรับรางวัลจากการมีส่วนร่วมในการอนุรักษ์สิ่งแวดล้อม',
                      style: GoogleFonts.kanit(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: AppConstants.primaryGreen),
                    title: Text('ข้อมูลแอป', style: GoogleFonts.kanit()),
                    subtitle: Text('รายละเอียดเพิ่มเติม', style: GoogleFonts.kanit()),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined, color: AppConstants.primaryGreen),
                    title: Text('นโยบายความเป็นส่วนตัว', style: GoogleFonts.kanit()),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.description_outlined, color: AppConstants.primaryGreen),
                    title: Text('เงื่อนไขการใช้งาน', style: GoogleFonts.kanit()),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '© 2024 GreenPoint. สงวนลิขสิทธิ์',
              style: GoogleFonts.kanit(
                fontSize: 12,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
