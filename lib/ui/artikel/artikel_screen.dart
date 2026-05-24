import 'package:flutter/material.dart';

import '../../data/models/artikel_model.dart';
import '../../repository/artikel_repository.dart';
import '../dashboard/dashboard_screen.dart';
import 'detail_artikel_screen.dart';

class ArtikelScreen extends StatelessWidget {
  const ArtikelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardScreen.green,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _HeaderTitle(),
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF3F3F3),
                child: FutureBuilder<List<Artikel>>(
                  future: ArtikelRepository().ambilDaftar(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'Gagal memuat artikel: ${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: DashboardScreen.dark,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    }

                    final artikelList = snapshot.data ?? [];

                    if (artikelList.isEmpty) {
                      return const Center(
                        child: Text(
                          'Belum ada artikel.',
                          style: TextStyle(
                            color: DashboardScreen.dark,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(18, 38, 18, 120),
                      itemCount: artikelList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final artikel = artikelList[index];
                        return _ArtikelCard(artikel: artikel);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: DashboardScreen.green,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
      child: const Text(
        "Artikel",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: DashboardScreen.dark,
          height: 1.05,
        ),
      ),
    );
  }
}

class _ArtikelCard extends StatelessWidget {
  const _ArtikelCard({required this.artikel});

  final Artikel artikel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailArtikelScreen(artikel: artikel),
          ),
        );
      },
      child: Container(
        height: 86,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: DashboardScreen.green,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: DashboardScreen.border,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFEAF4E8),
                border: Border.all(
                  color: const Color(0xFF9DB68E),
                  width: 1,
                ),
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Image.asset(
                    artikel.gambar,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.eco,
                      color: DashboardScreen.dark,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                artikel.judul,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF36563C),
                  height: 1.1,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.chevron_right_rounded,
              size: 42,
              color: DashboardScreen.dark,
            ),
          ],
        ),
      ),
    );
  }
}