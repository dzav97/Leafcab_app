import 'dart:io';
import 'package:flutter/material.dart';

import '../../data/models/artikel_model.dart';
import '../dashboard/dashboard_screen.dart';

class DetailArtikelScreen extends StatelessWidget {
  const DetailArtikelScreen({
    super.key,
    required this.artikel,
  });

  final Artikel artikel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardScreen.green,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: DashboardScreen.dark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Detail Artikel",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: DashboardScreen.dark,
                      height: 1.05,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 78),
              child: Container(
                decoration: const BoxDecoration(
                  color: DashboardScreen.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(26),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: DashboardScreen.green,
                          borderRadius: BorderRadius.circular(22),
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
                                Icons.article_outlined,
                                color: DashboardScreen.dark,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                artikel.judul,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: DashboardScreen.dark,
                                  height: 1.25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      if (artikel.gambar.isNotEmpty) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            File(artikel.gambar),
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 180,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: DashboardScreen.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.image_not_supported_outlined,
                                size: 42,
                                color: DashboardScreen.dark,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: DashboardScreen.green,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          _formatTanggal(artikel.tanggal),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: DashboardScreen.dark,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: DashboardScreen.green,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              artikel.isi,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                fontSize: 15,
                                height: 1.8,
                                color: DashboardScreen.dark,
                              ),
                            ),
                          ),
                        ),
                      ),
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

  static String _formatTanggal(DateTime tanggal) {
    return '${tanggal.day.toString().padLeft(2, '0')}-'
        '${tanggal.month.toString().padLeft(2, '0')}-'
        '${tanggal.year}';
  }
}