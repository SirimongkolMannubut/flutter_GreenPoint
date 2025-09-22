import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/widgets.dart';
import '../../constants/app_constants.dart';
import '../../services/data/storage_service.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final users = await StorageService.getAllUsers();
      setState(() {
        _users = users.map((user) => {
          ...user,
          'level': _getUserLevel(user['totalPoints'] ?? 0),
          'isActive': user['isActive'] ?? true,
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ไม่สามารถโหลดข้อมูลผู้ใช้ได้', style: GoogleFonts.kanit()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getUserLevel(int points) {
    if (points >= 2000) return 'Platinum';
    if (points >= 1000) return 'Gold';
    if (points >= 500) return 'Silver';
    return 'Bronze';
  }

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
      appBar: AppBar(
        title: Text(
          'จัดการผู้ใช้',
          style: GoogleFonts.kanit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppConstants.primaryGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsers,
          ),
        ],
      ),
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredUsers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'ไม่พบผู้ใช้งาน',
                              style: GoogleFonts.kanit(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
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
                                  (user['name'] ?? 'U').substring(0, 1).toUpperCase(),
                                  style: GoogleFonts.kanit(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                user['name'] ?? 'ไม่ระบุชื่อ',
                                style: GoogleFonts.kanit(fontWeight: FontWeight.w500),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user['email'] ?? 'ไม่ระบุอีเมล',
                                    style: GoogleFonts.kanit(fontSize: 12),
                                  ),
                                  const SizedBox(height: 4),
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
                                        '${user['totalPoints'] ?? 0} แต้ม',
                                        style: GoogleFonts.kanit(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      if (user['id'] != null)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            'ID: ${user['id']}',
                                            style: GoogleFonts.kanit(
                                              fontSize: 10,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w500,
                                            ),
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
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
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
            _buildDetailRow('ชื่อ:', user['name'] ?? 'ไม่ระบุ'),
            _buildDetailRow('อีเมล:', user['email'] ?? 'ไม่ระบุ'),
            _buildDetailRow('User ID:', user['id'] ?? 'ไม่ระบุ'),
            _buildDetailRow('แต้ม:', '${user['totalPoints'] ?? 0} แต้ม'),
            _buildDetailRow('เลเวล:', user['level'] ?? 'Bronze'),
            _buildDetailRow('พลาสติกที่ลด:', '${user['plasticReduced'] ?? 0} กรัม'),
            _buildDetailRow('วันที่สมัคร:', user['joinDate'] != null 
                ? user['joinDate'].toString().substring(0, 10) 
                : 'ไม่ระบุ'),
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
}