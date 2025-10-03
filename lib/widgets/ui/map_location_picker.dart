import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../constants/app_constants.dart';

class MapLocationPicker extends StatefulWidget {
  final LatLng? initialLocation;
  final Function(LatLng, String) onLocationSelected;

  const MapLocationPicker({
    super.key,
    this.initialLocation,
    required this.onLocationSelected,
  });

  @override
  State<MapLocationPicker> createState() => _MapLocationPickerState();
}

class _MapLocationPickerState extends State<MapLocationPicker> {
  MapController? _controller;
  LatLng _selectedLocation = LatLng(13.7563, 100.5018);
  String _address = 'กำลังค้นหาที่อยู่...';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = MapController();
    if (widget.initialLocation != null) {
      _selectedLocation = widget.initialLocation!;
    }
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    if (!mounted) return;
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
            _selectedLocation = LatLng(position.latitude, position.longitude);
            
            if (_controller != null) {
              _controller!.move(_selectedLocation, 15.0);
            }
          }
        } catch (e) {
          debugPrint('Geolocator error: $e');
        }
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
    
    await _getAddressFromLatLng(_selectedLocation);
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getAddressFromLatLng(LatLng location) async {
    if (mounted) {
      setState(() {
        _address = 'Lat: ${location.latitude.toStringAsFixed(4)}, Lng: ${location.longitude.toStringAsFixed(4)}';
      });
    }
  }

  void _onMapTapped(LatLng location) {
    setState(() {
      _selectedLocation = location;
      _address = 'กำลังค้นหาที่อยู่...';
    });
    _getAddressFromLatLng(location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เลือกตำแหน่งร้านค้า',
          style: GoogleFonts.kanit(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppConstants.primaryGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _controller,
            options: MapOptions(
              initialCenter: _selectedLocation,
              initialZoom: 15.0,
              onTap: (tapPosition, point) => _onMapTapped(point),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.flutter_greenpoint',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedLocation,
                    child: Icon(
                      Icons.location_on,
                      color: AppConstants.primaryGreen,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.store,
                          color: AppConstants.primaryGreen,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'ตำแหน่งร้านค้า',
                          style: GoogleFonts.kanit(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _address,
                      style: GoogleFonts.kanit(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppConstants.primaryGreen.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.my_location,
                                size: 16,
                                color: AppConstants.primaryGreen,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'พิกัด:',
                                style: GoogleFonts.kanit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppConstants.primaryGreen,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Lat: ${_selectedLocation.latitude.toStringAsFixed(6)}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Lng: ${_selectedLocation.longitude.toStringAsFixed(6)}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 14,
                            color: Colors.blue[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'แตะบนแผนที่เพื่อเปลี่ยนตำแหน่ง',
                            style: GoogleFonts.kanit(
                              fontSize: 11,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppConstants.primaryGreen,
                ),
              ),
            ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          widget.onLocationSelected(_selectedLocation, _address);
          Navigator.pop(context);
        },
        backgroundColor: AppConstants.primaryGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.check),
        label: Text(
          'ยืนยันตำแหน่งร้าน',
          style: GoogleFonts.kanit(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}