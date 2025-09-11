import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../constants/app_constants.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

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
        latitude: 13.7563,
        longitude: 100.5018,
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
      setState(() => _isLoading = false);
      _showError('เกิดข้อผิดพลาด: $e');
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
      appBar: const CommonAppBar(title: 'เพิ่มร้านค้าพาร์ทเนอร์'),
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
