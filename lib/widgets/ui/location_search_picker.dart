import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/app_constants.dart';

class LocationSearchPicker extends StatefulWidget {
  final Function(double lat, double lng, String address) onLocationSelected;

  const LocationSearchPicker({
    super.key,
    required this.onLocationSelected,
  });

  @override
  State<LocationSearchPicker> createState() => _LocationSearchPickerState();
}

class _LocationSearchPickerState extends State<LocationSearchPicker> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchLocation(String query) async {
    if (query.length < 3) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // ใช้ Nominatim API (OpenStreetMap) สำหรับค้นหาตำแหน่ง
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?format=json&q=$query&limit=10&countrycodes=th&addressdetails=1'
      );
      
      final response = await http.get(url, headers: {
        'User-Agent': 'GreenPoint-App/1.0',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _searchResults = data.map((item) => {
            'display_name': item['display_name'] ?? '',
            'lat': double.tryParse(item['lat'] ?? '0') ?? 0.0,
            'lon': double.tryParse(item['lon'] ?? '0') ?? 0.0,
            'address': item['address'] ?? {},
          }).toList();
        });
      }
    } catch (e) {
      debugPrint('Error searching location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาดในการค้นหา', style: GoogleFonts.kanit()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatAddress(Map<String, dynamic> address) {
    List<String> parts = [];
    
    if (address['house_number'] != null) parts.add(address['house_number']);
    if (address['road'] != null) parts.add(address['road']);
    if (address['suburb'] != null) parts.add(address['suburb']);
    if (address['city_district'] != null) parts.add(address['city_district']);
    if (address['city'] != null) parts.add(address['city']);
    if (address['state'] != null) parts.add(address['state']);
    if (address['postcode'] != null) parts.add(address['postcode']);
    
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ค้นหาตำแหน่ง',
          style: GoogleFonts.kanit(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppConstants.primaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              onChanged: _searchLocation,
              decoration: InputDecoration(
                hintText: 'ค้นหาที่อยู่, ตำบล, อำเภอ, จังหวัด...',
                hintStyle: GoogleFonts.kanit(color: Colors.grey[500]),
                prefixIcon: Icon(Icons.search, color: AppConstants.primaryGreen),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchResults = [];
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppConstants.primaryGreen),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppConstants.primaryGreen, width: 2),
                ),
              ),
              style: GoogleFonts.kanit(),
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          Expanded(
            child: _searchResults.isEmpty && !_isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchController.text.isEmpty
                              ? 'พิมพ์ชื่อสถานที่เพื่อค้นหา'
                              : 'ไม่พบผลการค้นหา',
                          style: GoogleFonts.kanit(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (_searchController.text.isEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'เช่น "ตลาดจตุจักร" หรือ "บางนา กรุงเทพ"',
                            style: GoogleFonts.kanit(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final result = _searchResults[index];
                      final address = result['address'] as Map<String, dynamic>;
                      
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppConstants.primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.location_on,
                              color: AppConstants.primaryGreen,
                            ),
                          ),
                          title: Text(
                            result['display_name'],
                            style: GoogleFonts.kanit(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (address.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  _formatAddress(address),
                                  style: GoogleFonts.kanit(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                              const SizedBox(height: 4),
                              Text(
                                'พิกัด: ${result['lat'].toStringAsFixed(4)}, ${result['lon'].toStringAsFixed(4)}',
                                style: GoogleFonts.kanit(
                                  fontSize: 11,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: AppConstants.primaryGreen,
                          ),
                          onTap: () {
                            widget.onLocationSelected(
                              result['lat'],
                              result['lon'],
                              result['display_name'],
                            );
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}