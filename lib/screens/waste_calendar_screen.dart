import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/waste_provider.dart';
import '../models/waste_entry.dart';
import '../constants/app_constants.dart';
import '../widgets/waste_entry_card.dart';
import '../widgets/common_app_bar.dart';
import 'add_waste_screen.dart';

class WasteCalendarScreen extends StatefulWidget {
  const WasteCalendarScreen({super.key});

  @override
  State<WasteCalendarScreen> createState() => _WasteCalendarScreenState();
}

class _WasteCalendarScreenState extends State<WasteCalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WasteProvider>().loadEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CommonAppBar(
        title: 'ปฏิทินทิ้งขยะ',
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              setState(() {
                _selectedDate = DateTime.now();
              });
            },
          ),
        ],
      ),
      body: Consumer<WasteProvider>(
        builder: (context, wasteProvider, child) {
          if (wasteProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppConstants.primaryGreen,
              ),
            );
          }

          return Column(
            children: [
              _buildCalendarHeader(),
              _buildCalendarGrid(wasteProvider),
              _buildSelectedDateInfo(wasteProvider),
              Expanded(
                child: _buildWasteEntriesList(wasteProvider),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddWaste(),
        backgroundColor: AppConstants.primaryGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(
          'บันทึกขยะ',
          style: GoogleFonts.kanit(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _selectedDate = DateTime(
                  _selectedDate.year,
                  _selectedDate.month - 1,
                );
              });
            },
            icon: const Icon(Icons.chevron_left),
          ),
          Text(
            DateFormat('MMMM yyyy', 'th').format(_selectedDate),
            style: GoogleFonts.kanit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConstants.darkGreen,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedDate = DateTime(
                  _selectedDate.year,
                  _selectedDate.month + 1,
                );
              });
            },
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(WasteProvider wasteProvider) {
    final firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final lastDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    final firstDayWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        children: [
          // Days of week header
          Row(
            children: ['อา', 'จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส']
                .map((day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: GoogleFonts.kanit(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          // Calendar grid
          ...List.generate(6, (weekIndex) {
            return Row(
              children: List.generate(7, (dayIndex) {
                final dayNumber = weekIndex * 7 + dayIndex - firstDayWeekday + 1;
                
                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return const Expanded(child: SizedBox(height: 40));
                }

                final date = DateTime(_selectedDate.year, _selectedDate.month, dayNumber);
                final entries = wasteProvider.getEntriesForDate(date);
                final isSelected = _isSameDay(date, _selectedDate);
                final isToday = _isSameDay(date, DateTime.now());

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppConstants.primaryGreen
                            : isToday
                                ? AppConstants.lightGreen.withOpacity(0.3)
                                : null,
                        borderRadius: BorderRadius.circular(8),
                        border: entries.isNotEmpty
                            ? Border.all(color: AppConstants.accentGreen, width: 2)
                            : null,
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              dayNumber.toString(),
                              style: GoogleFonts.kanit(
                                color: isSelected
                                    ? Colors.white
                                    : isToday
                                        ? AppConstants.primaryGreen
                                        : Colors.black87,
                                fontWeight: isSelected || isToday
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (entries.isNotEmpty)
                            Positioned(
                              right: 4,
                              top: 4,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppConstants.successColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSelectedDateInfo(WasteProvider wasteProvider) {
    final entries = wasteProvider.getEntriesForDate(_selectedDate);
    final totalWeight = entries.fold(0.0, (sum, entry) => sum + entry.totalWeight);
    final totalCo2 = entries.fold(0.0, (sum, entry) => sum + entry.totalCo2Saved);
    final totalPoints = entries.fold(0, (sum, entry) => sum + entry.totalPoints);

    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('d MMMM yyyy', 'th').format(_selectedDate),
            style: GoogleFonts.kanit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.darkGreen,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'น้ำหนัก',
                  '${totalWeight.toStringAsFixed(0)} g',
                  Icons.scale,
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'CO₂ ที่ลด',
                  '${totalCo2.toStringAsFixed(2)} kg',
                  Icons.co2,
                  Colors.green,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'แต้ม',
                  totalPoints.toString(),
                  Icons.stars,
                  Colors.amber,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.kanit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.kanit(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildWasteEntriesList(WasteProvider wasteProvider) {
    final entries = wasteProvider.getEntriesForDate(_selectedDate);

    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'ยังไม่มีการบันทึกขยะในวันนี้',
              style: GoogleFonts.kanit(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'แตะปุ่ม "บันทึกขยะ" เพื่อเริ่มต้น',
              style: GoogleFonts.kanit(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return WasteEntryCard(
          entry: entry,
          onEdit: () => _navigateToEditWaste(entry),
          onDelete: () => _deleteEntry(entry.id),
        ).animate(delay: (index * 100).ms)
            .fadeIn(duration: 400.ms)
            .slideX(begin: 0.3, end: 0);
      },
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  void _navigateToAddWaste() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddWasteScreen(selectedDate: _selectedDate),
      ),
    );
  }

  void _navigateToEditWaste(WasteEntry entry) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddWasteScreen(
          selectedDate: _selectedDate,
          editEntry: entry,
        ),
      ),
    );
  }

  void _deleteEntry(String entryId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'ลบรายการ',
          style: GoogleFonts.kanit(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'คุณต้องการลบรายการนี้หรือไม่?',
          style: GoogleFonts.kanit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'ยกเลิก',
              style: GoogleFonts.kanit(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<WasteProvider>().deleteEntry(entryId);
              Navigator.pop(context);
            },
            child: Text(
              'ลบ',
              style: GoogleFonts.kanit(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}