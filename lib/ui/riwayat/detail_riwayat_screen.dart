import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../data/models/riwayat_model.dart';
import '../dashboard/dashboard_screen.dart';

class DetailRiwayatScreen extends StatelessWidget {
  const DetailRiwayatScreen({
    super.key,
    required this.item,
  });

  final RiwayatDeteksi item;

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
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                  child: Column(
                    children: [
                      _ImagePreview(item: item),
                      const SizedBox(height: 18),
                      _ResultCard(
                        label: item.label,
                        confidence: item.confidence,
                      ),
                      const SizedBox(height: 16),
                      _InfoSection(
                        icon: Icons.eco_outlined,
                        title: 'Ciri-Ciri Gejala',
                        content: item.gejala,
                      ),
                      const SizedBox(height: 16),
                      _InfoSection(
                        icon: Icons.health_and_safety_outlined,
                        title: 'Pencegahan Awal',
                        content: item.pengendalian,
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
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: DashboardScreen.green,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(30),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(
                Icons.arrow_back,
                size: 32,
                color: DashboardScreen.dark,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Detail Riwayat',
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

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.item});

  final RiwayatDeteksi item;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 220,
        height: 220,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: DashboardScreen.green,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: DashboardScreen.border,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    if (item.gambar.isNotEmpty) {
      final file = File(item.gambar);

      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildBase64OrIcon(),
        );
      }
    }

    return _buildBase64OrIcon();
  }

  Widget _buildBase64OrIcon() {
    final imageBase64 = item.imageBase64;

    if (imageBase64 != null && imageBase64.isNotEmpty) {
      try {
        final Uint8List bytes = base64Decode(imageBase64);

        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildImageIcon(),
        );
      } catch (_) {
        return _buildImageIcon();
      }
    }

    return _buildImageIcon();
  }

  Widget _buildImageIcon() {
    return Container(
      color: DashboardScreen.green,
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_outlined,
        size: 60,
        color: DashboardScreen.dark,
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.label,
    required this.confidence,
  });

  final String label;
  final double confidence;

  @override
  Widget build(BuildContext context) {
    final confidencePercent = (confidence * 100).clamp(0, 100).toDouble();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: DashboardScreen.green,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: DashboardScreen.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Hasil Deteksi',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: DashboardScreen.softText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              color: Color(0xFF36563C),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Text(
                'Confidence',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: DashboardScreen.softText,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: const Color(0xFF9DB68E),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${confidencePercent.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF36563C),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: confidencePercent / 100,
              minHeight: 7,
              backgroundColor: Colors.white.withValues(alpha: 0.55),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF36563C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.icon,
    required this.title,
    required this.content,
  });

  final IconData icon;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final paragraphs = content
        .trim()
        .split(RegExp(r'\n\s*\n'))
        .where((text) => text.trim().isNotEmpty)
        .toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        color: DashboardScreen.green,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: DashboardScreen.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor: Colors.white.withValues(alpha: 0.55),
                child: Icon(
                  icon,
                  size: 20,
                  color: DashboardScreen.dark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF36563C),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...List.generate(paragraphs.length, (index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == paragraphs.length - 1 ? 0 : 14,
              ),
              child: Text(
                paragraphs[index].trim(),
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 14.5,
                  height: 1.65,
                  color: Color(0xFF36563C),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.05,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}