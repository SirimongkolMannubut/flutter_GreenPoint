import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/user_provider.dart';
import '../constants/app_constants.dart';
import '../widgets/greenpoint_logo.dart';
import '../services/google_auth_service.dart';
import '../services/email_service.dart';
import 'main_screen.dart';
import 'admin_login_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppConstants.primaryGreen,
              AppConstants.lightGreen,
              AppConstants.accentGreen,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 60),
                _buildLogo(),
                const SizedBox(height: 40),
                _buildAuthForm(),
                const SizedBox(height: 20),
                _buildToggleButton(),
                const SizedBox(height: 16),
                _buildAdminButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: const GreenPointLogo(
            size: 80,
            showText: false,
          ),
        ).animate().scale(duration: 800.ms).then().shimmer(duration: 1500.ms),
        const SizedBox(height: 24),
        Text(
          'GreenPoint',
          style: GoogleFonts.kanit(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ).animate().fadeIn(duration: 600.ms, delay: 400.ms),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'สะสมแต้มเพื่อโลกใส 🌍',
            style: GoogleFonts.kanit(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ).animate().fadeIn(duration: 600.ms, delay: 600.ms),
      ],
    );
  }

  Widget _buildAuthForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isLogin ? 'เข้าสู่ระบบ' : 'สมัครสมาชิก',
              style: GoogleFonts.kanit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppConstants.darkGreen,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (!_isLogin) ...[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'ชื่อ-นามสกุล',
                  labelStyle: GoogleFonts.kanit(),
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppConstants.primaryGreen),
                  ),
                ),
                style: GoogleFonts.kanit(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อ-นามสกุล';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
            ],
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'อีเมล',
                labelStyle: GoogleFonts.kanit(),
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppConstants.primaryGreen),
                ),
              ),
              style: GoogleFonts.kanit(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกอีเมล';
                }
                if (!value.contains('@')) {
                  return 'รูปแบบอีเมลไม่ถูกต้อง';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'รหัสผ่าน',
                labelStyle: GoogleFonts.kanit(),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppConstants.primaryGreen),
                ),
              ),
              style: GoogleFonts.kanit(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกรหัสผ่าน';
                }
                if (value.length < 6) {
                  return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleAuth,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _isLogin ? 'เข้าสู่ระบบ' : 'สมัครสมาชิก',
                style: GoogleFonts.kanit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey[300])),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'หรือ',
                    style: GoogleFonts.kanit(color: Colors.grey[600]),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey[300])),
              ],
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _handleGoogleSignIn,
              icon: Image.network(
                'https://developers.google.com/identity/images/g-logo.png',
                height: 20,
                width: 20,
              ),
              label: Text(
                'เข้าสู่ระบบด้วย Google',
                style: GoogleFonts.kanit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: Colors.grey[300]!),
              ),
            ),
          ],
        ),
      ),
    ).animate().slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 800.ms);
  }

  Widget _buildToggleButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          _isLogin = !_isLogin;
          _nameController.clear();
          _emailController.clear();
          _passwordController.clear();
        });
      },
      child: Text(
        _isLogin ? 'ยังไม่มีบัญชี? สมัครสมาชิก' : 'มีบัญชีแล้ว? เข้าสู่ระบบ',
        style: GoogleFonts.kanit(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildAdminButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminLoginScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white70),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '🔐 เข้าสู่ระบบผู้ดูแล',
          style: GoogleFonts.kanit(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  void _handleAuth() async {
    if (_formKey.currentState!.validate()) {
      if (!_isLogin) {
        await _handleEmailVerification();
      } else {
        await _performLogin();
      }
    }
  }

  Future<void> _handleEmailVerification() async {
    try {
      final email = _emailController.text.trim();
      final name = _nameController.text.trim();
      
      _showLoadingDialog('กำลังส่งรหัสยืนยัน...');
      
      final verificationCode = await EmailService.sendVerificationCode(email, name);
      
      Navigator.pop(context); // Close loading dialog
      
      final enteredCode = await _showVerificationDialog();
      
      if (enteredCode == verificationCode) {
        await _performRegistration();
      } else {
        _showErrorSnackBar('รหัสยืนยันไม่ถูกต้อง');
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog if open
      _showErrorSnackBar('ไม่สามารถส่งอีเมลยืนยันได้: ${e.toString()}');
    }
  }

  Future<void> _performLogin() async {
    try {
      debugPrint('Attempting login with email: ${_emailController.text.trim()}');
      
      final userProvider = context.read<UserProvider>();
      final success = await userProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      debugPrint('Login result: $success');

      if (success && mounted) {
        debugPrint('Login successful, navigating to main screen');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else if (mounted) {
        debugPrint('Login failed, showing error');
        _showErrorSnackBar('ลองใหม่อีกครั้ง หรือใช้: test@greenpoint.com / 123456');
      }
    } catch (e, stackTrace) {
      debugPrint('Login error: $e');
      debugPrint('Stack trace: $stackTrace');
      _showErrorSnackBar('เกิดข้อผิดพลาด: $e');
    }
  }

  Future<void> _performRegistration() async {
    try {
      final userProvider = context.read<UserProvider>();
      final success = await userProvider.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        _showSuccessSnackBar('สมัครสมาชิกสำเร็จ!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else if (mounted) {
        _showErrorSnackBar('เกิดข้อผิดพลาดในการสมัครสมาชิก');
      }
    } catch (e) {
      _showErrorSnackBar('เกิดข้อผิดพลาด กรุณาลองใหม่');
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      _showLoadingDialog('กำลังเข้าสู่ระบบด้วย Google...');
      
      final result = await GoogleAuthService.signInWithGoogle();
      
      Navigator.pop(context); // Close loading dialog
      
      if (result == null) {
        _showErrorSnackBar('เกิดข้อผิดพลาดในการเข้าสู่ระบบด้วย Google');
        return;
      }
      
      if (result['cancelled'] == true) {
        // User cancelled, don't show error
        return;
      }
      
      if (mounted) {
        final userProvider = context.read<UserProvider>();
        
        debugPrint('Google Sign-In result: $result');
        
        final success = await userProvider.loginWithGoogle(
          result['name'] ?? 'Google User',
          result['email'] ?? '',
          result['id'] ?? '',
        );
        
        if (success) {
          _showSuccessSnackBar('เข้าสู่ระบบด้วย Google สำเร็จ!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else {
          _showErrorSnackBar('เกิดข้อผิดพลาดในการบันทึกข้อมูล');
        }
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog if open
      _showErrorSnackBar('เกิดข้อผิดพลาดในการเข้าสู่ระบบด้วย Google');
    }
  }

  Future<String?> _showVerificationDialog() async {
    final codeController = TextEditingController();
    
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'ยืนยันอีเมล',
          style: GoogleFonts.kanit(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'กรุณากรอกรหัสยืนยัน 6 หลักที่ส่งไปยังอีเมลของคุณ',
              style: GoogleFonts.kanit(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: GoogleFonts.kanit(fontSize: 24, letterSpacing: 8),
              decoration: InputDecoration(
                hintText: '000000',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLength: 6,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: Text('ยกเลิก', style: GoogleFonts.kanit()),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, codeController.text),
            child: Text('ยืนยัน', style: GoogleFonts.kanit()),
          ),
        ],
      ),
    );
  }

  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.kanit(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.kanit()),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.kanit()),
        backgroundColor: Colors.green,
      ),
    );
  }
}