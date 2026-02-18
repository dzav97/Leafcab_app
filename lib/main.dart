import 'package:flutter/material.dart';
import 'ui/splash/splash_screen.dart';

void main() {
  // Memastikan binding Flutter siap sebelum inisialisasi DB
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leafcab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Menggunakan tema warna hijau sesuai mockup daun cabai
        primarySwatch: Colors.green,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFCDE4C5), // Warna background mockup
      ),
      // Aplikasi dimulai dari SplashScreen
      home: const SplashScreen(),
    );
  }
}