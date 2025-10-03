import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../widgets/widgets.dart';
import '../../constants/app_constants.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).loadAllUsers();
    });
  }

  String _getUserLevel(int points) {
    if (points >= 2500) return 'Diamond';
    if (points >= 1000) return 'Platinum';
    if (points >= 500) return 'Gold';
    if (points >= 100) return 'Silver';
    return 'Bronze';
  }

  List<User> getFilteredUsers(List<User> users) {
    if (_searchQuery.isEmpty) return users;
    return users.where((user) {
      return user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             user.email.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _copyUserId(String userId) {
    Clipboard.setData(ClipboardData(text: userId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('คัดลอก User ID แล้ว', style: GoogleFonts.kanit()),
        backgroundColor: AppConstants.primaryGreen,
      ),
    );
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
            onPressed: () => Provider.of<AdminProvider>(context, listen: false).loadAllUsers(),
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
            child: Consumer<AdminProvider>(
              builder: (context, adminProvider, child) {
                final filteredUsers = getFilteredUsers(adminProvider.allUsers);
                
                if (adminProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (filteredUsers.isEmpty) {
                  return Center(
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
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppConstants.primaryGreen,
                          child: Text(
                            user.name.substring(0, 1).toUpperCase(),
                            style: GoogleFonts.kanit(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          user.name,
                          style: GoogleFonts.kanit(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.email,
                              style: GoogleFonts.kanit(fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _getLevelColor(_getUserLevel(user.totalPoints)).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _getUserLevel(user.totalPoints),
                                    style: GoogleFonts.kanit(
                                      fontSize: 10,
                                      color: _getLevelColor(_getUserLevel(user.totalPoints)),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${user.totalPoints} แต้ม',
                                  style: GoogleFonts.kanit(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'ID: ${user.id}',
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
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  const Icon(Icons.copy, size: 16),
                                  const SizedBox(width: 8),
                                  Text('คัดลอก User ID', style: GoogleFonts.kanit()),
                                ],
                              ),
                              onTap: () => _copyUserId(user.id),
                            ),
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  const Icon(Icons.delete, size: 16, color: Colors.red),
                                  const SizedBox(width: 8),
                                  Text('ลบผู้ใช้', style: GoogleFonts.kanit(color: Colors.red)),
                                ],
                              ),
                              onTap: () => _showDeleteUserDialog(user),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
      case 'Diamond':
        return Colors.purple;
      case 'Platinum':
        return Colors.grey;
      case 'Gold':
        return Colors.orange;
      case 'Silver':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  void _showUserDetails(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('รายละเอียดผู้ใช้', style: GoogleFonts.kanit()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('ชื่อ:', user.name),
            _buildDetailRow('อีเมล:', user.email),
            _buildDetailRow('User ID:', user.id),
            _buildDetailRow('แต้ม:', '${user.totalPoints} แต้ม'),
            _buildDetailRow('เลเวล:', _getUserLevel(user.totalPoints)),
            _buildDetailRow('พลาสติกที่ลด:', '${user.plasticReduced} กรัม'),
            _buildDetailRow('วันที่สมัคร:', user.joinDate.toString().substring(0, 10)),
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

  void _showDeleteUserDialog(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ลบผู้ใช้', style: GoogleFonts.kanit()),
        content: Text('คุณต้องการลบผู้ใช้ "${user.name}" หรือไม่?', style: GoogleFonts.kanit()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก', style: GoogleFonts.kanit()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteUser(user);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('ลบ', style: GoogleFonts.kanit(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteUser(User user) async {
    final success = await Provider.of<AdminProvider>(context, listen: false).deleteUser(user.id);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success 
            ? 'ลบผู้ใช้ "${user.name}" แล้ว'
            : 'ไม่สามารถลบผู้ใช้ได้',
          style: GoogleFonts.kanit()
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }
}