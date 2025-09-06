import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/waste_entry.dart';
import '../constants/app_constants.dart';

class WasteEntryCard extends StatelessWidget {
  final WasteEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const WasteEntryCard({
    super.key,
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormat('HH:mm').format(entry.date),
                  style: GoogleFonts.kanit(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 20),
                  color: AppConstants.primaryGreen,
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, size: 20),
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Waste items
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: entry.items.map((item) => Chip(
                avatar: Icon(
                  item.icon,
                  size: 16,
                  color: item.color,
                ),
                label: Text(
                  item.name,
                  style: GoogleFonts.kanit(fontSize: 12),
                ),
                backgroundColor: item.color.withOpacity(0.1),
                side: BorderSide(color: item.color.withOpacity(0.3)),
              )).toList(),
            ),
            
            const SizedBox(height: 12),
            
            // Summary stats
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'น้ำหนัก',
                    '${entry.totalWeight.toStringAsFixed(0)} g',
                    Icons.scale,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'CO₂ ลด',
                    '${entry.totalCo2Saved.toStringAsFixed(2)} kg',
                    Icons.co2,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'แต้ม',
                    entry.totalPoints.toString(),
                    Icons.stars,
                    Colors.amber,
                  ),
                ),
              ],
            ),
            
            if (entry.note != null && entry.note!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  entry.note!,
                  style: GoogleFonts.kanit(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.kanit(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.kanit(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}