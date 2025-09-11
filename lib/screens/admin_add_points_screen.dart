import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';
import '../providers/user_provider.dart';
import '../services/storage_service.dart';
import '../widgets/common_app_bar.dart';

class AdminAddPointsScreen extends StatefulWidget {
  const AdminAddPointsScreen({super.key});

  @override
  State<AdminAddPointsScreen> createState() => _AdminAddPointsScreenState();
}

class _AdminAddPointsScreenState extends State<AdminAddPointsScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  List<Map<String, dynamic>> _allUsers = [];
  Map<String, dynamic>? _selectedUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAllUsers();
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _pointsController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _loadAllUsers() async {
    setState(() => _isLoading = true);
    try {
      final users = await StorageService.getAllUsers();
      setState(() {
        _allUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('ไม่สามารถโหลดข้อมูลผู้ใช้ได้');
    }
  }

  void _searchUser(String userId) {
    if (userId.isEmpty) {
      setState(() => _selectedUser = null);
      return;
    }

    final user = _allUsers.firstWhere(
      (user) => user['id'].toString().toLowerCase().contains(userId.toLowerCase()) ||
                user['email'].toString().toLowerCase().contains(userId.toLowerCase()),
      orElse: () => {},
    );

    setState(() {
      _selectedUser = user.isNotEmpty ? user : null;
    });
  }

  Future<void> _addPoints() async {
    if (_selectedUser == null) {
      _showError('กรุณาเลือกผู้ใช้');
      return;
    }

    final points = int.tryParse(_pointsController.text);
    if (points == null || points <= 0) {
      _showError('กรุณาใส่จำนวนแต้มที่ถูกต้อง');
      return;
    }

    if (_reasonController.text.trim().isEmpty) {
      _showError('กรุณาใส่เหตุผล');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Update user points
      final updatedUser = Map<String, dynamic>.from(_selectedUser!);
      updatedUser['totalPoints'] = (updatedUser['totalPoints'] ?? 0) + points;
      
      // Calculate new level
      final newLevel = _calculateLevel(updatedUser['totalPoints']);
      updatedUser['level'] = newLevel;

      await StorageService.updateUser(updatedUser);

      // Add to activity log
      await _addActivityLog(
        updatedUser['id'],
        updatedUser['name'],
        points,
        _reasonController.text.trim(),
      );

      setState(() => _isLoading = false);
      
      _showSuccess('เพิ่ม $points แต้มให้ ${updatedUser['name']} สำเร็จ');
      _clearForm();
      
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('เกิดข้อผิดพลาด: $e');
    }
  }

  int _calculateLevel(int points) {
    if (points < 100) return 1;
    if (points < 300) return 2;
    if (points < 600) return 3;
    if (points < 1000) return 4;
    return 5;
  }

  Future<void> _addActivityLog(String userId, String userName, int points, String reason) async {
    // This would typically save to a database or log file
    debugPrint('Admin added $points points to $userName ($userId) - Reason: $reason');
  }

  void _clearForm() {
    _userIdController.clear();
    _pointsController.clear();
    _reasonController.clear();
    setState(() => _selectedUser = null);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.kanit()),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.kanit()),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const CommonAppBar(title: 'เพิ่มแต้มให้ผู้ใช้'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchSection(),
                  const SizedBox(height: 20),
                  if (_selectedUser != null) _buildUserInfo(),
                  const SizedBox(height: 20),
                  _buildPointsForm(),
                  const SizedBox(height: 30),
                  _buildAddButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildSearchSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ค้นหาผู้ใช้',
              style: GoogleFonts.kanit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.darkGreen,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _userIdController,
              onChanged: _searchUser,
              decoration: InputDecoration(
                hintText: 'ใส่ User ID หรือ Email',
                hintStyle: GoogleFonts.kanit(),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: GoogleFonts.kanit(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ข้อมูลผู้ใช้',
              style: GoogleFonts.kanit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.darkGreen,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConstants.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppConstants.primaryGreen.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('ชื่อ:', _selectedUser!['name']),
                  _buildInfoRow('ID:', _selectedUser!['id']),
                  _buildInfoRow('Email:', _selectedUser!['email']),
                  _buildInfoRow('แต้มปัจจุบัน:', '${_selectedUser!['totalPoints'] ?? 0} แต้ม'),
                  _buildInfoRow('Level:', '${_selectedUser!['level'] ?? 1}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.kanit(
                fontWeight: FontWeight.w600,
                color: AppConstants.darkGreen,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.kanit(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'เพิ่มแต้ม',
              style: GoogleFonts.kanit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.darkGreen,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pointsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'จำนวนแต้ม',
                labelStyle: GoogleFonts.kanit(),
                hintText: 'ใส่จำนวนแต้มที่ต้องการเพิ่ม',
                hintStyle: GoogleFonts.kanit(),
                prefixIcon: const Icon(Icons.stars),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: GoogleFonts.kanit(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'เหตุผล',
                labelStyle: GoogleFonts.kanit(),
                hintText: 'ระบุเหตุผลในการเพิ่มแต้ม',
                hintStyle: GoogleFonts.kanit(),
                prefixIcon: const Icon(Icons.note),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: GoogleFonts.kanit(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _selectedUser != null ? _addPoints : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'เพิ่มแต้ม',
          style: GoogleFonts.kanit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
