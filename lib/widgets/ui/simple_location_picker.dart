import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../constants/app_constants.dart';

class SimpleLocationPicker extends StatefulWidget {
  final Function(double, double, String) onLocationSelected;
  
  const SimpleLocationPicker({
    super.key,
    required this.onLocationSelected,
  });

  @override
  State<SimpleLocationPicker> createState() => _SimpleLocationPickerState();
}

class _SimpleLocationPickerState extends State<SimpleLocationPicker> {
  double _latitude = 13.7563;
  double _longitude = 100.5018;
  String _address = 'กรุงเทพมหานคร, ประเทศไทย';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    
    try {
      var status = await Permission.location.status;
      if (status.isDenied) {
        status = await Permission.location.request();
      }
      
      if (status.isGranted) {
        try {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            timeLimit: const Duration(seconds: 10),
          );
          if (mounted) {
            setState(() {
              _latitude = position.latitude;
              _longitude = position.longitude;
              _address = 'ตำแหน่งปัจจุบัน';
            });
          }
        } catch (e) {
          debugPrint('Geolocator error: $e');
        }
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
    
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ระบุตำแหน่งร้านค้า',
          style: GoogleFonts.kanit(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppConstants.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: AppConstants.primaryGreen),
                        const SizedBox(width: 8),
                        Text(
                          'ตำแหน่งร้านค้า',
                          style: GoogleFonts.kanit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _latitude.toStringAsFixed(6),
                      decoration: InputDecoration(
                        labelText: 'ละติจูด (Latitude)',
                        labelStyle: GoogleFonts.kanit(),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _latitude = double.tryParse(value) ?? _latitude;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _longitude.toStringAsFixed(6),
                      decoration: InputDecoration(
                        labelText: 'ลองติจูด (Longitude)',
                        labelStyle: GoogleFonts.kanit(),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _longitude = double.tryParse(value) ?? _longitude;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _address,
                      decoration: InputDecoration(
                        labelText: 'ที่อยู่',
                        labelStyle: GoogleFonts.kanit(),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onChanged: (value) {
                        _address = value;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _isLoading ? null : _getCurrentLocation,
                        icon: _isLoading 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.my_location),
                        label: Text(
                          _isLoading ? 'กำลังค้นหา...' : 'ใช้ตำแหน่งปัจจุบัน',
                          style: GoogleFonts.kanit(),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppConstants.primaryGreen,
                          side: BorderSide(color: AppConstants.primaryGreen),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  widget.onLocationSelected(_latitude, _longitude, _address);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'ยืนยันตำแหน่ง',
                  style: GoogleFonts.kanit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}