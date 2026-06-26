import 'package:flutter/material.dart';
import 'convert_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Selamat Datang,',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pilih format konversi\nhari ini.',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1C1C1E),
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 40),
              _buildBentoCard(
                context: context,
                title: 'Word to PDF',
                subtitle: 'Mendukung format .doc & .docx',
                icon: Icons.description_rounded,
                iconColor: Colors.blueAccent,
                iconBgColor: Colors.blue.withValues(alpha: 0.1),
                allowedExtensions: ['doc', 'docx'],
                isFullWidth: true,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildBentoCard(
                      context: context,
                      title: 'Excel to PDF',
                      subtitle: '.xls & .xlsx',
                      icon: Icons.table_chart_rounded,
                      iconColor: Colors.green,
                      iconBgColor: Colors.green.withValues(alpha: 0.1),
                      allowedExtensions: ['xls', 'xlsx'],
                      isFullWidth: false,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildBentoCard(
                      context: context,
                      title: 'Image to PDF',
                      subtitle: '.png & .jpg',
                      icon: Icons.image_rounded,
                      iconColor: Colors.purpleAccent,
                      iconBgColor: Colors.purple.withValues(alpha: 0.1),
                      allowedExtensions: ['png', 'jpg', 'jpeg'],
                      isFullWidth: false,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBentoCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required List<String> allowedExtensions,
    required bool isFullWidth,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConvertScreen(
              pageTitle: title,
              allowedExtensions: allowedExtensions,
              themeColor: iconColor,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: EdgeInsets.all(isFullWidth ? 24 : 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade200, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 32, color: iconColor),
                ),
                if (isFullWidth)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey.shade300,
                    size: 20,
                  ),
              ],
            ),
            SizedBox(height: isFullWidth ? 32 : 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C1C1E),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}