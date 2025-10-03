import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../widgets/widgets.dart';
import '../../constants/app_constants.dart';

class SystemLogsScreen extends StatefulWidget {
  const SystemLogsScreen({super.key});

  @override
  State<SystemLogsScreen> createState() => _SystemLogsScreenState();
}

class _SystemLogsScreenState extends State<SystemLogsScreen> {
  List<Map<String, dynamic>> _logs = [];
  bool _isLoading = true;
  String _selectedFilter = 'ทั้งหมด';

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final logsJson = prefs.getStringList('system_logs') ?? [];
    
    final logs = logsJson.map((log) => jsonDecode(log) as Map<String, dynamic>).toList();
    logs.sort((a, b) => DateTime.parse(b['timestamp']).compareTo(DateTime.parse(a['timestamp'])));
    
    setState(() {
      _logs = logs;
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get filteredLogs {
    if (_selectedFilter == 'ทั้งหมด') return _logs;
    return _logs.where((log) => log['type'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: 'ล็อกระบบ',
        showBackButton: true,
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadLogs,
                    child: filteredLogs.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredLogs.length,
                            itemBuilder: (context, index) {
                              return _buildLogCard(filteredLogs[index]);
                            },
                          ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clearLogs,
        backgroundColor: Colors.red,
        child: const Icon(Icons.clear_all, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterBar() {
    final filters = ['ทั้งหมด', 'เข้าสู่ระบบ', 'สมัครสมาชิก', 'QR สแกน', 'อัปเดต', 'ข้อผิดพลาด'];
    
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                filter,
                style: GoogleFonts.kanit(
                  color: isSelected ? Colors.white : AppConstants.primaryGreen,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              selectedColor: AppConstants.primaryGreen,
              backgroundColor: Colors.grey[100],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogCard(Map<String, dynamic> log) {
    final timestamp = DateTime.parse(log['timestamp']);
    final type = log['type'] as String;
    final message = log['message'] as String;
    
    Color typeColor;
    IconData typeIcon;
    
    switch (type) {
      case 'เข้าสู่ระบบ':
        typeColor = Colors.green;
        typeIcon = Icons.login;
        break;
      case 'สมัครสมาชิก':
        typeColor = Colors.blue;
        typeIcon = Icons.person_add;
        break;
      case 'QR สแกน':
        typeColor = Colors.purple;
        typeIcon = Icons.qr_code_scanner;
        break;
      case 'อัปเดต':
        typeColor = Colors.orange;
        typeIcon = Icons.edit;
        break;
      case 'ข้อผิดพลาด':
        typeColor = Colors.red;
        typeIcon = Icons.error;
        break;
      default:
        typeColor = Colors.grey;
        typeIcon = Icons.info;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: typeColor.withOpacity(0.1),
          child: Icon(typeIcon, color: typeColor, size: 20),
        ),
        title: Text(
          message,
          style: GoogleFonts.kanit(fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    type,
                    style: GoogleFonts.kanit(
                      fontSize: 10,
                      color: typeColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}',
                  style: GoogleFonts.kanit(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: log.containsKey('details') 
            ? IconButton(
                icon: const Icon(Icons.info_outline, size: 16),
                onPressed: () => _showLogDetails(log),
              )
            : null,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'ไม่มีล็อกระบบ',
            style: GoogleFonts.kanit(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ล็อกจะแสดงเมื่อมีการใช้งานแอป',
            style: GoogleFonts.kanit(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogDetails(Map<String, dynamic> log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('รายละเอียดล็อก', style: GoogleFonts.kanit()),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('ประเภท:', log['type']),
              _buildDetailRow('ข้อความ:', log['message']),
              _buildDetailRow('เวลา:', log['timestamp']),
              if (log.containsKey('details'))
                _buildDetailRow('รายละเอียด:', log['details']),
              if (log.containsKey('userId'))
                _buildDetailRow('ผู้ใช้:', log['userId']),
            ],
          ),
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

  Future<void> _clearLogs() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ล้างล็อกทั้งหมด', style: GoogleFonts.kanit()),
        content: Text('คุณต้องการล้างล็อกระบบทั้งหมดหรือไม่?', style: GoogleFonts.kanit()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('ยกเลิก', style: GoogleFonts.kanit()),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('ล้าง', style: GoogleFonts.kanit()),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('system_logs');
      setState(() {
        _logs.clear();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ล้างล็อกทั้งหมดแล้ว', style: GoogleFonts.kanit()),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  static Future<void> addLog(String type, String message, {Map<String, dynamic>? details}) async {
    final prefs = await SharedPreferences.getInstance();
    final logs = prefs.getStringList('system_logs') ?? [];
    
    final logEntry = {
      'type': type,
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
      if (details != null) ...details,
    };
    
    logs.add(jsonEncode(logEntry));
    
    // Keep only last 100 logs
    if (logs.length > 100) {
      logs.removeAt(0);
    }
    
    await prefs.setStringList('system_logs', logs);
  }
}
