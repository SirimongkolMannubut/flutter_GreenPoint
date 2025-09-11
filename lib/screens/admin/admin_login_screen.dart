import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import '../../constants/app_constants.dart';
import 'admin_dashboard_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final success = await context.read<AdminProvider>().loginAdmin(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppConstants.primaryGreen,
              AppConstants.lightGreen,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const GreenPointLogo(size: 80),
                        const SizedBox(height: 16),
                        Text(
                          'ระบบผู้ดูแล',
                          style: GoogleFonts.kanit(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.primaryGreen,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'เข้าสู่ระบบสำหรับผู้ดูแล',
                          style: GoogleFonts.kanit(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'อีเมล',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
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
                            prefixIcon: const Icon(Icons.lock_outlined),
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
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกรหัสผ่าน';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Consumer<AdminProvider>(
                          builder: (context, adminProvider, child) {
                            if (adminProvider.error != null) {
                              return Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.red[50],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.red[200]!),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.error_outline, color: Colors.red[700]),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            adminProvider.error!,
                                            style: GoogleFonts.kanit(
                                              color: Colors.red[700],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Consumer<AdminProvider>(
                            builder: (context, adminProvider, child) {
                              return ElevatedButton(
                                onPressed: adminProvider.isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: adminProvider.isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : Text(
                                        'เข้าสู่ระบบ',
                                        style: GoogleFonts.kanit(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'กลับไปหน้าหลัก',
                            style: GoogleFonts.kanit(
                              color: AppConstants.primaryGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
