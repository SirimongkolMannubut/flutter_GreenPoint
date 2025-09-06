import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/waste_provider.dart';
import '../models/waste_entry.dart';
import '../constants/app_constants.dart';

class AddWasteScreen extends StatefulWidget {
  final DateTime selectedDate;
  final WasteEntry? editEntry;

  const AddWasteScreen({
    super.key,
    required this.selectedDate,
    this.editEntry,
  });

  @override
  State<AddWasteScreen> createState() => _AddWasteScreenState();
}

class _AddWasteScreenState extends State<AddWasteScreen> {
  final _noteController = TextEditingController();
  final List<WasteItem> _selectedItems = [];
  List<WasteItem> _availableItems = [];

  @override
  void initState() {
    super.initState();
    _availableItems = context.read<WasteProvider>().getAvailableWasteItems();
    
    if (widget.editEntry != null) {
      _selectedItems.addAll(widget.editEntry!.items);
      _noteController.text = widget.editEntry!.note ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.editEntry != null ? 'แก้ไขรายการ' : 'บันทึกขยะ',
          style: GoogleFonts.kanit(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppConstants.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildSummaryCard(),
          Expanded(
            child: _buildWasteItemsList(),
          ),
          _buildNoteSection(),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final totalWeight = _selectedItems.fold(0.0, (sum, item) => sum + item.weight);
    final totalCo2 = _selectedItems.fold(0.0, (sum, item) => sum + item.co2Impact);
    final totalPoints = _selectedItems.fold(0, (sum, item) => sum + item.points);

    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppConstants.primaryGreen, AppConstants.lightGreen],
        ),
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
      ),
      child: Column(
        children: [
          Text(
            'สรุปรายการ',
            style: GoogleFonts.kanit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'รายการ',
                  '${_selectedItems.length} ชิ้น',
                  Icons.list,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'น้ำหนัก',
                  '${totalWeight.toStringAsFixed(0)} g',
                  Icons.scale,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'CO₂ ลด',
                  '${totalCo2.toStringAsFixed(2)} kg',
                  Icons.co2,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'แต้ม',
                  totalPoints.toString(),
                  Icons.stars,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3, end: 0);
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.kanit(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.kanit(
            fontSize: 10,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildWasteItemsList() {
    final groupedItems = <WasteType, List<WasteItem>>{};
    for (final item in _availableItems) {
      groupedItems.putIfAbsent(item.type, () => []).add(item);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      itemCount: groupedItems.length,
      itemBuilder: (context, index) {
        final type = groupedItems.keys.elementAt(index);
        final items = groupedItems[type]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                _getWasteTypeName(type),
                style: GoogleFonts.kanit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.darkGreen,
                ),
              ),
            ),
            ...items.map((item) => _buildWasteItemCard(item)),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildWasteItemCard(WasteItem item) {
    final isSelected = _selectedItems.any((selected) => selected.id == item.id);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedItems.removeWhere((selected) => selected.id == item.id);
            } else {
              _selectedItems.add(item);
            }
          });
        },
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            border: isSelected
                ? Border.all(color: AppConstants.primaryGreen, width: 2)
                : null,
            color: isSelected
                ? AppConstants.primaryGreen.withOpacity(0.1)
                : null,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  item.icon,
                  color: item.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: GoogleFonts.kanit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      item.description,
                      style: GoogleFonts.kanit(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildItemInfo('${item.weight.toStringAsFixed(0)}g', Icons.scale),
                        const SizedBox(width: 12),
                        _buildItemInfo('${item.co2Impact.toStringAsFixed(2)}kg CO₂', Icons.co2),
                        const SizedBox(width: 12),
                        _buildItemInfo('${item.points} แต้ม', Icons.stars),
                      ],
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: AppConstants.primaryGreen,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.3, end: 0);
  }

  Widget _buildItemInfo(String text, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.grey[600]),
        const SizedBox(width: 2),
        Text(
          text,
          style: GoogleFonts.kanit(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildNoteSection() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      child: TextField(
        controller: _noteController,
        decoration: InputDecoration(
          labelText: 'หมายเหตุ (ไม่บังคับ)',
          labelStyle: GoogleFonts.kanit(),
          hintText: 'เพิ่มรายละเอียดเพิ่มเติม...',
          hintStyle: GoogleFonts.kanit(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            borderSide: const BorderSide(color: AppConstants.primaryGreen),
          ),
        ),
        maxLines: 3,
        style: GoogleFonts.kanit(),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      child: ElevatedButton(
        onPressed: _selectedItems.isNotEmpty ? _saveEntry : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          ),
        ),
        child: Text(
          widget.editEntry != null ? 'อัปเดตรายการ' : 'บันทึกรายการ',
          style: GoogleFonts.kanit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _saveEntry() {
    final entry = WasteEntry.create(
      _selectedItems,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
    );

    if (widget.editEntry != null) {
      final updatedEntry = WasteEntry(
        id: widget.editEntry!.id,
        date: widget.editEntry!.date,
        items: entry.items,
        note: entry.note,
        totalWeight: entry.totalWeight,
        totalCo2Saved: entry.totalCo2Saved,
        totalPoints: entry.totalPoints,
      );
      context.read<WasteProvider>().updateEntry(updatedEntry);
    } else {
      context.read<WasteProvider>().addEntry(entry);
    }

    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.editEntry != null ? 'อัปเดตรายการเรียบร้อย' : 'บันทึกรายการเรียบร้อย',
          style: GoogleFonts.kanit(),
        ),
        backgroundColor: AppConstants.successColor,
      ),
    );
  }

  String _getWasteTypeName(WasteType type) {
    switch (type) {
      case WasteType.plastic:
        return 'พลาสติก';
      case WasteType.paper:
        return 'กระดาษ';
      case WasteType.glass:
        return 'แก้ว';
      case WasteType.metal:
        return 'โลหะ';
      case WasteType.organic:
        return 'อินทรีย์';
      case WasteType.electronic:
        return 'อิเล็กทรอนิกส์';
      case WasteType.hazardous:
        return 'อันตราย';
      case WasteType.textile:
        return 'ผ้า';
    }
  }
}