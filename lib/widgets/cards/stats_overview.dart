import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../constants/app_constants.dart';

class StatsOverview extends StatelessWidget {
  final int totalPoints;
  final int plasticReduced;
  final int level;

  const StatsOverview({
    super.key,
    required this.totalPoints,
    required this.plasticReduced,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'สถิติการใช้งาน',
            style: GoogleFonts.kanit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.darkGreen,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'แต้มรวม',
                  totalPoints.toString(),
                  Icons.stars,
                  AppConstants.primaryGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'พลาสติกที่ลด',
                  '$plasticReduced ชิ้น',
                  Icons.recycling,
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'ระดับปัจจุบัน',
                  'Level $level',
                  Icons.military_tech,
                  Colors.amber,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'CO₂ ที่ลด',
                  '${(plasticReduced * 0.5).toStringAsFixed(1)} kg',
                  Icons.co2,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildWeeklyChart(),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.smallRadius),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.kanit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.kanit(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'กิจกรรมรายสัปดาห์',
          style: GoogleFonts.kanit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppConstants.darkGreen,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 50,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const days = ['จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส', 'อา'];
                      return Text(
                        days[value.toInt()],
                        style: GoogleFonts.kanit(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: _generateBarData(),
              gridData: const FlGridData(show: false),
            ),
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _generateBarData() {
    final weeklyData = [15, 25, 30, 20, 35, 40, 28];
    
    return weeklyData.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: AppConstants.primaryGreen,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }
}