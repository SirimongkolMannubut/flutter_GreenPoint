import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/common_app_bar.dart';
import '../constants/app_constants.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Mock user data
  final List<Map<String, dynamic>> _users = [
    {
      'id': '1',
      'name': 'สมชาย ใจดี',
      'email': 'somchai@email.com',
      'points': 1250,
      'level': 'Gold',
      'joinDate': '2024-01-15',
      'isActive': true,
    },
    {
      'id': '2',
      'name': 'สมหญิง รักษ์โลก',
      'email': 'somying@email.com',
      'points': 890,
      'level': 'Silver',
      'joinDate': '2024-02-20',
      'isActive': true,
    },
    {
      'id': '3',
      'name': 'วิชัย อนุรักษ์',
      'email': 'wichai@email.com',
      'points': 2100,
      'level': 'Platinum',
      'joinDate': '2023-12-10',
      'isActive': false,
    },
  ];

  List<Map<String, dynamic>> get filteredUsers {
    if (_searchQuery.isEmpty) return _users;
    return _users.where((user) {
      return user['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
             user['email'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'จัดการผู้ใช้'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ค้นหาผู้ใช้...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: user['isActive'] ? AppConstants.primaryGreen : Colors.grey,
                      child: Text(
                        user['name'].substring(0, 1),
                        style: GoogleFonts.kanit(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      user['name'],
                      style: GoogleFonts.kanit(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['email'],
                          style: GoogleFonts.kanit(fontSize: 12),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getLevelColor(user['level']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                user['level'],
                                style: GoogleFonts.kanit(
                                  fontSize: 10,
                                  color: _getLevelColor(user['level']),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${user['points']} แต้ม',
                              style: GoogleFonts.kanit(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Row(
                            children: [
                              const Icon(Icons.visibility, size: 16),
                              const SizedBox(width: 8),
                              Text('ดูรายละเอียด', style: GoogleFonts.kanit()),
                            ],
                          ),
                          onTap: () => _showUserDetails(user),
                        ),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(
                                user['isActive'] ? Icons.block : Icons.check_circle,
                                size: 16,
                                color: user['isActive'] ? Colors.red : Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                user['isActive'] ? 'ระงับบัญชี' : 'เปิดใช้บัญชี',
                                style: GoogleFonts.kanit(),
                              ),
                            ],
                          ),
                          onTap: () => _toggleUserStatus(user),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddUserDialog,
        backgroundColor: AppConstants.primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case 'Platinum':
        return Colors.purple;
      case 'Gold':
        return Colors.orange;
      case 'Silver':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  void _showUserDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('รายละเอียดผู้ใช้', style: GoogleFonts.kanit()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('ชื่อ:', user['name']),
            _buildDetailRow('อีเมล:', user['email']),
            _buildDetailRow('แต้ม:', '${user['points']} แต้ม'),
            _buildDetailRow('เลเวล:', user['level']),
            _buildDetailRow('วันที่สมัคร:', user['joinDate']),
            _buildDetailRow('สถานะ:', user['isActive'] ? 'ใช้งาน' : 'ระงับ'),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
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

  void _toggleUserStatus(Map<String, dynamic> user) {
    setState(() {
      user['isActive'] = !user['isActive'];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          user['isActive'] ? 'เปิดใช้บัญชีแล้ว' : 'ระงับบัญชีแล้ว',
          style: GoogleFonts.kanit(),
        ),
      ),
    );
  }

  void _showAddUserDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('เพิ่มผู้ใช้ใหม่', style: GoogleFonts.kanit()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'ชื่อ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'อีเมล',
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
              if (nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                setState(() {
                  _users.add({
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'name': nameController.text,
                    'email': emailController.text,
                    'points': 0,
                    'level': 'Bronze',
                    'joinDate': DateTime.now().toString().substring(0, 10),
                    'isActive': true,
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('เพิ่มผู้ใช้สำเร็จ', style: GoogleFonts.kanit()),
                  ),
                );
              }
            },
            child: Text('เพิ่ม', style: GoogleFonts.kanit()),
          ),
        ],
      ),
    );
  }
}
