import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import '../../widgets/ui/map_location_picker.dart';
import '../../widgets/ui/simple_location_picker.dart';
import '../../widgets/ui/location_search_picker.dart';

class AdminAddStoreScreen extends StatefulWidget {
  const AdminAddStoreScreen({super.key});

  @override
  State<AdminAddStoreScreen> createState() => _AdminAddStoreScreenState();
}

class _AdminAddStoreScreenState extends State<AdminAddStoreScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _openHoursController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  
  String _selectedCategory = 'ร้านอาหาร';
  String _selectedEmoji = '🍽️';
  double _rating = 4.5;
  bool _isLoading = false;
  double? _selectedLat;
  double? _selectedLng;
  String _locationAddress = 'ยังไม่ได้เลือกตำแหน่ง';

  final List<String> _categories = [
    'ร้านอาหาร', 'ร้านกาแฟ', 'ร้านค้าทั่วไป', 'ซูเปอร์มาร์เก็ต', 
    'ร้านเสื้อผ้า', 'ร้านหนังสือ', 'ร้านยา', 'อื่นๆ'
  ];

  final List<String> _emojis = [
    '🍽️', '☕', '🏪', '🛒', '👕', '📚', '💊', '🏢'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _openHoursController.dispose();
    _discountController.dispose();
    _pointsController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _addStore() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final tags = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();

      final newStore = PartnerStore(
        id: 'store_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        address: _addressController.text.trim(),
        latitude: _selectedLat ?? 13.7563,
        longitude: _selectedLng ?? 100.5018,
        phone: _phoneController.text.trim(),
        imageUrl: '',
        openHours: _openHoursController.text.trim(),
        category: _selectedCategory,
        emoji: _selectedEmoji,
        rating: _rating,
        discount: _discountController.text.trim(),
        pointsRequired: int.tryParse(_pointsController.text) ?? 0,
        tags: tags,
      );

      final storeProvider = context.read<StoreProvider>();
      final success = await storeProvider.addStore(newStore);
      
      if (!mounted) return;
      
      if (success) {
        // รีเฟรชข้อมูลร้านค้า
        await storeProvider.loadStores();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เพิ่มร้านค้าสำเร็จ!', style: GoogleFonts.kanit()),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาดในการเพิ่มร้านค้า', style: GoogleFonts.kanit()),
            backgroundColor: Colors.red,
          ),
        );
      }

    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError('เกิดข้อผิดพลาด: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _addressController.clear();
    _phoneController.clear();
    _openHoursController.clear();
    _discountController.clear();
    _pointsController.clear();
    _tagsController.clear();
    setState(() {
      _selectedCategory = 'ร้านอาหาร';
      _selectedEmoji = '🍽️';
      _rating = 4.5;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.kanit()),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.kanit()),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const CommonAppBar(
        title: 'เพิ่มร้านค้าพาร์ทเนอร์',
        showBackButton: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildBasicInfoCard(),
                    const SizedBox(height: 16),
                    _buildContactInfoCard(),
                    const SizedBox(height: 16),
                    _buildBusinessInfoCard(),
                    const SizedBox(height: 16),
                    _buildPromotionInfoCard(),
                    const SizedBox(height: 30),
                    _buildAddButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildBasicInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ข้อมูลพื้นฐาน',
              style: GoogleFonts.kanit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.darkGreen,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'ชื่อร้าน *',
                labelStyle: GoogleFonts.kanit(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              style: GoogleFonts.kanit(),
              validator: (value) => value?.isEmpty == true ? 'กรุณาใส่ชื่อร้าน' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'คำอธิบาย *',
                labelStyle: GoogleFonts.kanit(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              style: GoogleFonts.kanit(),
              validator: (value) => value?.isEmpty == true ? 'กรุณาใส่คำอธิบาย' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'หมวดหมู่',
                      labelStyle: GoogleFonts.kanit(),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category, style: GoogleFonts.kanit()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                        _selectedEmoji = _emojis[_categories.indexOf(value)];
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppConstants.primaryGreen.withOpacity(0.3)),
                  ),
                  child: Center(
                    child: Text(_selectedEmoji, style: const TextStyle(fontSize: 24)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ข้อมูลติดต่อ',
              style: GoogleFonts.kanit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.darkGreen,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'ที่อยู่ *',
                labelStyle: GoogleFonts.kanit(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              style: GoogleFonts.kanit(),
              validator: (value) => value?.isEmpty == true ? 'กรุณาใส่ที่อยู่' : null,
            ),
            const SizedBox(height: 16),
            _buildLocationPicker(),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'เบอร์โทรศัพท์ *',
                labelStyle: GoogleFonts.kanit(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              style: GoogleFonts.kanit(),
              validator: (value) => value?.isEmpty == true ? 'กรุณาใส่เบอร์โทรศัพท์' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _openHoursController,
              decoration: InputDecoration(
                labelText: 'เวลาเปิด-ปิด',
                labelStyle: GoogleFonts.kanit(),
                hintText: 'เช่น 08:00-20:00',
                hintStyle: GoogleFonts.kanit(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              style: GoogleFonts.kanit(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ข้อมูลธุรกิจ',
              style: GoogleFonts.kanit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.darkGreen,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'คะแนนร้าน: ${_rating.toStringAsFixed(1)}',
              style: GoogleFonts.kanit(fontWeight: FontWeight.w600),
            ),
            Slider(
              value: _rating,
              min: 1.0,
              max: 5.0,
              divisions: 40,
              activeColor: AppConstants.primaryGreen,
              onChanged: (value) => setState(() => _rating = value),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tagsController,
              decoration: InputDecoration(
                labelText: 'แท็ก (คั่นด้วยจุลภาค)',
                labelStyle: GoogleFonts.kanit(),
                hintText: 'เช่น อาหารอร่อย, บริการดี, ราคาถูก',
                hintStyle: GoogleFonts.kanit(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              style: GoogleFonts.kanit(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotionInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'โปรโมชั่น',
              style: GoogleFonts.kanit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.darkGreen,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _discountController,
              decoration: InputDecoration(
                labelText: 'ส่วนลด/โปรโมชั่น',
                labelStyle: GoogleFonts.kanit(),
                hintText: 'เช่น ลด 20%, ซื้อ 1 แถม 1',
                hintStyle: GoogleFonts.kanit(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              style: GoogleFonts.kanit(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _pointsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'แต้มที่ต้องใช้',
                labelStyle: GoogleFonts.kanit(),
                hintText: 'จำนวนแต้มที่ลูกค้าต้องใช้',
                hintStyle: GoogleFonts.kanit(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              style: GoogleFonts.kanit(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationPicker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
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
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _locationAddress,
            style: GoogleFonts.kanit(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('เลือกวิธีระบุตำแหน่ง', style: GoogleFonts.kanit()),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('เลือกวิธีที่ต้องการใช้ในการระบุตำแหน่งร้านค้า', style: GoogleFonts.kanit()),
                        const SizedBox(height: 8),
                        Text('ค้นหาสถานที่: พิมพ์ชื่อสถานที่', style: GoogleFonts.kanit(fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LocationSearchPicker(
                                onLocationSelected: (lat, lng, address) {
                                  setState(() {
                                    _selectedLat = lat;
                                    _selectedLng = lng;
                                    _locationAddress = address;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        child: Text('ค้นหาสถานที่', style: GoogleFonts.kanit()),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SimpleLocationPicker(
                                onLocationSelected: (lat, lng, address) {
                                  setState(() {
                                    _selectedLat = lat;
                                    _selectedLng = lng;
                                    _locationAddress = address;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        child: Text('ใส่พิกัดเอง', style: GoogleFonts.kanit()),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapLocationPicker(
                                onLocationSelected: (latLng, address) {
                                  setState(() {
                                    _selectedLat = latLng.latitude;
                                    _selectedLng = latLng.longitude;
                                    _locationAddress = address;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        child: Text('ใช้แผนที่', style: GoogleFonts.kanit()),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.map),
              label: Text(
                _selectedLat == null ? 'ระบุตำแหน่งร้านค้า' : 'เปลี่ยนตำแหน่ง',
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
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _addStore,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'เพิ่มร้านค้า',
          style: GoogleFonts.kanit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
