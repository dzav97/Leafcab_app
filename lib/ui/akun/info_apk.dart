import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart';

class InformasiAplikasiScreen extends StatelessWidget {
  const InformasiAplikasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardScreen.green,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _Header(
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F6F3),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
                  child: Column(
                    children: const [
                      _InfoCard(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: DashboardScreen.green,
      padding: const EdgeInsets.fromLTRB(12, 12, 24, 18),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: DashboardScreen.dark,
              size: 28,
            ),
          ),
          const SizedBox(width: 4),
          const Expanded(
            child: Text(
              'Informasi Aplikasi',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: DashboardScreen.dark,
                letterSpacing: 0.1,
                height: 1.05,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: DashboardScreen.border,
          width: 1.2,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Icon(
              Icons.eco_rounded,
              size: 58,
              color: DashboardScreen.dark,
            ),
          ),
          SizedBox(height: 14),
          Center(
            child: Text(
              'LeafCab',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: DashboardScreen.dark,
              ),
            ),
          ),
          SizedBox(height: 4),
          Center(
            child: Text(
              'Aplikasi Deteksi Penyakit Daun Cabai',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B776C),
              ),
            ),
          ),
          SizedBox(height: 22),
          Divider(
            height: 1,
            thickness: 1,
            color: DashboardScreen.border,
          ),
          SizedBox(height: 18),
          Text(
            'Tentang Aplikasi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: DashboardScreen.dark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'LeafCab membantu pengguna melakukan identifikasi awal penyakit pada daun cabai melalui gambar.',
            style: TextStyle(
              fontSize: 13.5,
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: DashboardScreen.dark,
            ),
          ),
          SizedBox(height: 18),
          Text(
            'Versi',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF6B776C),
            ),
          ),
          SizedBox(height: 4),
          Text(
            '1.0.0',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: DashboardScreen.dark,
            ),
          ),
          SizedBox(height: 18),
          Text(
            'Pengaduan dan Saran',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF6B776C),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'leafcab@gmail.com',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: DashboardScreen.dark,
            ),
          ),
        ],
      ),
    );
  }
}