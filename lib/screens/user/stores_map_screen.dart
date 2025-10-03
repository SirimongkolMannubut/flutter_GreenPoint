import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_constants.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class StoresMapScreen extends StatefulWidget {
  const StoresMapScreen({super.key});

  @override
  State<StoresMapScreen> createState() => _StoresMapScreenState();
}

class _StoresMapScreenState extends State<StoresMapScreen> {
  MapController? _controller;
  List<Marker> _markers = [];
  
  @override
  void initState() {
    super.initState();
    _controller = MapController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStoreMarkers();
    });
  }

  void _loadStoreMarkers() {
    final storeProvider = context.read<StoreProvider>();
    final stores = storeProvider.stores;
    
    setState(() {
      _markers = stores.map((store) {
        return Marker(
          point: LatLng(store.latitude, store.longitude),
          child: GestureDetector(
            onTap: () => _onMarkerTapped(store),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    store.name,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 2),
                Icon(
                  Icons.store,
                  color: AppConstants.primaryGreen,
                  size: 30,
                ),
              ],
            ),
          ),
        );
      }).toList();
    });
  }

  void _onMarkerTapped(PartnerStore store) {
    _showStoreBottomSheet(store);
  }

  void _showStoreBottomSheet(PartnerStore store) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          store.emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            store.name,
                            style: GoogleFonts.kanit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      store.description,
                      style: GoogleFonts.kanit(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            store.address,
                            style: GoogleFonts.kanit(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${store.rating}',
                          style: GoogleFonts.kanit(fontSize: 12),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.category, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          store.category,
                          style: GoogleFonts.kanit(fontSize: 12),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _openNavigation(store),
                            icon: const Icon(Icons.directions),
                            label: Text(
                              'นำทาง',
                              style: GoogleFonts.kanit(),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppConstants.primaryGreen,
                              side: BorderSide(color: AppConstants.primaryGreen),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _callStore(store),
                            icon: const Icon(Icons.phone),
                            label: Text(
                              'โทร',
                              style: GoogleFonts.kanit(),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstants.primaryGreen,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openNavigation(PartnerStore store) async {
    final url = 'https://www.openstreetmap.org/directions?from=&to=${store.latitude},${store.longitude}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _callStore(PartnerStore store) async {
    final url = 'tel:${store.phone}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: 'แผนที่ร้านค้าพาร์ทเนอร์',
        showBackButton: true,
      ),
      body: Consumer<StoreProvider>(
        builder: (context, storeProvider, child) {
          if (storeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              FlutterMap(
                mapController: _controller,
                options: MapOptions(
                  initialCenter: LatLng(13.7563, 100.5018),
                  initialZoom: 12.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.flutter_greenpoint',
                  ),
                  MarkerLayer(
                    markers: _markers,
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
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.store,
                          color: AppConstants.primaryGreen,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'ร้านค้าพาร์ทเนอร์ ${storeProvider.stores.length} ร้าน',
                          style: GoogleFonts.kanit(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.touch_app,
                          color: Colors.grey[600],
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'แตะหมุดเพื่อดูรายละเอียด',
                          style: GoogleFonts.kanit(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}