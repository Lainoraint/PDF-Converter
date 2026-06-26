import 'package:flutter/material.dart';
import 'convert_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi Converter Hub'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Pilih Jenis Konversi',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            
            _buildMenuCard(
              context: context,
              title: 'Word to PDF',
              icon: Icons.description,
              color: Colors.blue,
              allowedExtensions: ['doc', 'docx'],
            ),
            const SizedBox(height: 16),
            
            _buildMenuCard(
              context: context,
              title: 'Excel to PDF',
              icon: Icons.table_chart,
              color: Colors.green,
              allowedExtensions: ['xls', 'xlsx'],
            ),
            const SizedBox(height: 16),
            
            _buildMenuCard(
              context: context,
              title: 'Image to PDF',
              icon: Icons.image,
              color: Colors.purple,
              allowedExtensions: ['png', 'jpg', 'jpeg'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required List<String> allowedExtensions,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConvertScreen(
              pageTitle: title,
              allowedExtensions: allowedExtensions,
              themeColor: color,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, color: color),
          ],
        ),
      ),
    );
  }
}