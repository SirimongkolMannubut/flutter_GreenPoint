import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:math';

class EmailService {
  static const String _senderEmail = 'greenpoint.app@gmail.com';
  static const String _senderPassword = 'YOUR_16_DIGIT_APP_PASSWORD'; // แทนที่ด้วย App Password 16 หลักจาก Gmail
  
  static Future<String> sendVerificationCode(String recipientEmail, String userName) async {
    final verificationCode = _generateVerificationCode();
    
    try {
      final smtpServer = gmail(_senderEmail, _senderPassword);
      
      final message = Message()
        ..from = Address(_senderEmail, 'GreenPoint App')
        ..recipients.add(recipientEmail)
        ..subject = 'รหัสยืนยัน GreenPoint - ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'
        ..html = _buildEmailTemplate(userName, verificationCode);

      await send(message, smtpServer);
      return verificationCode;
    } catch (e) {
      print('Email sending error: $e');
      throw Exception('ไม่สามารถส่งอีเมลได้: $e');
    }
  }

  static String _generateVerificationCode() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  static String _buildEmailTemplate(String userName, String code) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <style>
            body { font-family: 'Kanit', Arial, sans-serif; background-color: #f5f5f5; margin: 0; padding: 20px; }
            .container { max-width: 600px; margin: 0 auto; background: white; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.1); }
            .header { background: linear-gradient(135deg, #4CAF50, #81C784); padding: 30px; text-align: center; }
            .logo { font-size: 32px; margin-bottom: 10px; }
            .header h1 { color: white; margin: 0; font-size: 28px; }
            .content { padding: 30px; }
            .code-box { background: linear-gradient(135deg, #E8F5E8, #F1F8E9); border: 2px solid #4CAF50; border-radius: 12px; padding: 20px; text-align: center; margin: 20px 0; }
            .code { font-size: 36px; font-weight: bold; color: #2E7D32; letter-spacing: 8px; margin: 10px 0; }
            .footer { background: #f8f8f8; padding: 20px; text-align: center; color: #666; font-size: 14px; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <div class="logo">🌱</div>
                <h1>GreenPoint</h1>
                <p style="color: rgba(255,255,255,0.9); margin: 0;">แอปสะสมแต้มเพื่อสิ่งแวดล้อม</p>
            </div>
            
            <div class="content">
                <h2 style="color: #2E7D32;">สวัสดี $userName! 👋</h2>
                <p>ยินดีต้อนรับสู่ GreenPoint! กรุณาใช้รหัสยืนยันด้านล่างเพื่อเข้าสู่ระบบ:</p>
                
                <div class="code-box">
                    <p style="margin: 0; color: #2E7D32; font-weight: bold;">รหัสยืนยันของคุณ</p>
                    <div class="code">$code</div>
                    <p style="margin: 0; color: #666; font-size: 14px;">รหัสนี้จะหมดอายุใน 10 นาที</p>
                </div>
                
                <p style="color: #666;">หากคุณไม่ได้ลงทะเบียนกับ GreenPoint กรุณาเพิกเฉยต่ออีเมลนี้</p>
                
                <div style="background: #E8F5E8; padding: 15px; border-radius: 8px; margin: 20px 0;">
                    <p style="margin: 0; color: #2E7D32; font-weight: bold;">💡 เคล็ดลับ:</p>
                    <p style="margin: 5px 0 0 0; color: #2E7D32; font-size: 14px;">เริ่มสะสมแต้มได้ทันทีหลังจากยืนยันอีเมล โดยการลดการใช้พลาสติกในชีวิตประจำวัน!</p>
                </div>
            </div>
            
            <div class="footer">
                <p>© 2024 GreenPoint App - ร่วมกันสร้างโลกที่เป็นมิตรกับสิ่งแวดล้อม 🌍</p>
                <p>หากมีปัญหาการใช้งาน กรุณาติดต่อ: support@greenpoint.app</p>
            </div>
        </div>
    </body>
    </html>
    ''';
  }
}