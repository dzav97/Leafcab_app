import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/models/riwayat_model.dart';
import '../dashboard/dashboard_screen.dart';

class DetailRiwayatScreen extends StatelessWidget {
  const DetailRiwayatScreen({super.key, required this.item});

  final RiwayatDeteksi item;

  static const Color primaryGreen = Color(0xFF163225);
  static const Color cardGreen = Color(0xFFA5D6A7);

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
                    _buildTopBanner(context),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                        child: Column(
                          children: [
                            Container(
                              width: 112,
                              height: 112,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD8F0DB),
                                borderRadius: BorderRadius.circular(26),
                                border: Border.all(
                                  color: DashboardScreen.dark,
                                  width: 1.8,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.file(
                                  File(item.gambar),
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.image_outlined,
                                    size: 56,
                                    color: DashboardScreen.dark,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: DashboardScreen.green,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                item.label,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500,
                                  color: DashboardScreen.dark,
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: DashboardScreen.green,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Confidence: ${(item.confidence * 100).toStringAsFixed(2)}%',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: DashboardScreen.dark,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  _buildSectionText(
                                    title: 'Ciri-Ciri Gejala',
                                    content: item.gejala,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildSectionText(
                                    title: 'Pencegahan Awal',
                                    content: item.pengendalian,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildTopBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        decoration: BoxDecoration(
          color: DashboardScreen.green,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.arrow_back,
                  color: DashboardScreen.dark,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Detail Riwayat',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: DashboardScreen.dark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionText({
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: DashboardScreen.dark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontSize: 14,
            height: 1.65,
            color: DashboardScreen.dark,
          ),
        ),
      ],
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
        "Detail Riwayat",
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