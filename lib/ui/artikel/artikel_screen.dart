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
        child: Stack(
          children: [
            const _HeaderTitle(),
            Padding(
              padding: const EdgeInsets.only(top: 78),
              child: Container(
                decoration: const BoxDecoration(
                  color: DashboardScreen.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(26),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 18),
                    _buildTopBanner(),
                    const SizedBox(height: 18),
            
                    Expanded(
                      child: FutureBuilder<List<Artikel>>(
                        future: ArtikelRepository().ambilDaftar(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Gagal memuat artikel: ${snapshot.error}',
                                textAlign: TextAlign.center,
                              ),
                            );
                          }

                          final artikelList = snapshot.data ?? [];

                          if (artikelList.isEmpty) {
                            return const Center(
                              child: Text('Belum ada artikel.'),
                            );
                          }

                          return ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                            itemCount: artikelList.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final artikel = artikelList[index];
                              return _ArtikelCard(artikel: artikel);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        decoration: BoxDecoration(
          color: DashboardScreen.green,
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.menu_book_outlined,
                color: DashboardScreen.dark,
                size: 24,
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
    return const Padding(
      padding: EdgeInsets.only(left: 24, top: 16),
      child: Text(
        "Artikel",
        style: TextStyle(
          fontSize: 34,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: DashboardScreen.green,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.eco_outlined,
                color: DashboardScreen.dark,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artikel.judul,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: DashboardScreen.dark,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: DashboardScreen.dark,
            ),
          ],
        ),
      ),
    );
  }

  static String _formatTanggal(DateTime tanggal) {
    return '${tanggal.day.toString().padLeft(2, '0')}-'
        '${tanggal.month.toString().padLeft(2, '0')}-'
        '${tanggal.year}';
  }
}