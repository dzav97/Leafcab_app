import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna sesuai mockup
    const Color primaryGreen = Color(0xFF388E3C); // Hijau tua header
    const Color lightGreenBg = Color(0xFFCDE4C5); // Background utama
    const Color cardGreen = Color(0xFFA5D6A7);    // Background kartu instruksi

    return Scaffold(
      backgroundColor: lightGreenBg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 40, left: 25, right: 25),
              decoration: const BoxDecoration(
                color: primaryGreen,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/images/logo.png'), 
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Leafcab",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Aplikasi Deteksi Daun Cabai",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --- KARTU INSTRUKSI / BANNER ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardGreen,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStepIcon(Icons.center_focus_weak, "Ambil\nGambar"),
                      const Icon(Icons.arrow_forward_ios, size: 15, color: Colors.black54),
                      _buildStepIcon(Icons.assignment_outlined, "Lihat\nDiagnosis"),
                      const Icon(Icons.arrow_forward_ios, size: 15, color: Colors.black54),
                      _buildStepIcon(Icons.check_circle_outline, "Dapatkan\nHasil"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("Mulai Deteksi"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(left: 25, top: 25, bottom: 10),
              child: Text("Menu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryGreen)),
            ),

            // --- MENU GRID ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMenuItem(Icons.article, "Artikel", cardGreen),
                  _buildMenuItem(Icons.camera_alt, "Deteksi", cardGreen),
                  _buildMenuItem(Icons.history, "Riwayat", cardGreen),
                  _buildMenuItem(Icons.info, "Tentang", cardGreen),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(left: 25, top: 25, bottom: 10),
              child: Text("Artikel Preview", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryGreen)),
            ),

            // --- ARTIKEL PREVIEW ---
            Container(
              height: 150,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: cardGreen,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar sesuai rancangan
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.black45,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt, size: 40), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: ""),
        ],
      ),
    );
  }

  Widget _buildStepIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.black87),
        const SizedBox(height: 8),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, size: 30, color: const Color(0xFF1B5E20)),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}