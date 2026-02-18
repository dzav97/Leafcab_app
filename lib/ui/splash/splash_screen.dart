import 'package:flutter/material.dart';
import '../../../data/dataproviders/database_helper.dart';
import '../../ui/dashboard/dashboard_screen.dart'; // Nanti kita buat ini

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // 1. Inisialisasi Database (Proses menyalin file .db dari assets)
    await DatabaseHelper.instance.database;

    // 2. Beri jeda sedikit agar logo terlihat (misal 2 detik)
    await Future.delayed(const Duration(seconds: 2));

    // 3. Pindah ke Dashboard
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ganti dengan logo cabai Anda di folder assets
            Image.asset(
              'assets/images/logo.png', 
              width: 150,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}