import 'package:flutter/material.dart';

void main() {
  runApp(const GreenPointApp());
}

class GreenPointApp extends StatelessWidget {
  const GreenPointApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenPoint',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _points = 0;
  int _plasticReduced = 0;

  void _addPoints(int points, int plastic) {
    setState(() {
      _points += points;
      _plasticReduced += plastic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('GreenPoint'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Icon(Icons.eco, size: 50, color: Colors.green),
                    const SizedBox(height: 10),
                    Text('แต้มสะสม', style: Theme.of(context).textTheme.titleLarge),
                    Text('$_points แต้ม', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.green, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('ลดพลาสติก $_plasticReduced ชิ้น', style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('กิจกรรมลดพลาสติก', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildActivityCard('ใช้ถุงผ้า', Icons.shopping_bag, 10, 1),
                  _buildActivityCard('ใช้กล่องอาหาร', Icons.lunch_dining, 15, 1),
                  _buildActivityCard('ใช้หลอดไผ่', Icons.local_drink, 5, 1),
                  _buildActivityCard('ไม่ใช้ถุงพลาสติก', Icons.no_luggage, 20, 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(String title, IconData icon, int points, int plastic) {
    return Card(
      child: InkWell(
        onTap: () => _addPoints(points, plastic),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.green),
              const SizedBox(height: 8),
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('+$points แต้ม', style: const TextStyle(color: Colors.green)),
            ],
          ),
        ),
      ),
    );
  }
}
