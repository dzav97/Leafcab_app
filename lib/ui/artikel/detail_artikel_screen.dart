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
        bottom: false,
        child: Column(
          children: [
            _Header(onBack: () => Navigator.pop(context)),
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF3F3F3),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 46, 24, 32),
                  child: Column(
                    children: [
                      _TitleBadge(title: artikel.judul),
                      const SizedBox(height: 34),

                      // Kalau nanti ingin gambar tetap dipakai, blok ini bisa diaktifkan lagi.
                      if (artikel.gambar.isNotEmpty) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
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
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: DashboardScreen.border,
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.image_not_supported_outlined,
                                size: 40,
                                color: DashboardScreen.dark,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      _ContentCard(content: artikel.isi),
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
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: const Icon(
              Icons.arrow_back,
              size: 34,
              color: DashboardScreen.dark,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            "Detail Artikel",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: DashboardScreen.dark,
              height: 1.05,
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleBadge extends StatelessWidget {
  const _TitleBadge({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 175,
          maxWidth: 230,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        decoration: BoxDecoration(
          color: DashboardScreen.green,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: DashboardScreen.border,
            width: 1,
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF36563C),
            height: 1.15,
          ),
        ),
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 260),
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
      decoration: BoxDecoration(
        color: DashboardScreen.green,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: DashboardScreen.border,
          width: 1,
        ),
      ),
      child: Text(
        content,
        textAlign: TextAlign.justify,
        style: const TextStyle(
          fontSize: 15,
          height: 1.9,
          color: Color(0xFF36563C),
        ),
      ),
    );
  }
}