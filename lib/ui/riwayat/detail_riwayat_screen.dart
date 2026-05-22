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
                  padding: const EdgeInsets.fromLTRB(24, 34, 24, 32),
                  child: Column(
                    children: [
                      _ImagePreview(item: item),
                      const SizedBox(height: 28),
                      _ResultBadge(label: item.label),
                      const SizedBox(height: 24),
                      _DetailCard(
                        confidence: item.confidence,
                        gejala: item.gejala,
                        pengendalian: item.pengendalian,
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
            "Detail Riwayat",
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
    return Container(
      width: 160,
      height: 145,
      decoration: BoxDecoration(
        color: DashboardScreen.green,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: DashboardScreen.border,
          width: 1.6,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
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
    return const Center(
      child: Icon(
        Icons.image_outlined,
        size: 60,
        color: DashboardScreen.dark,
      ),
    );
  }
}

class _ResultBadge extends StatelessWidget {
  const _ResultBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 175,
        maxWidth: 230,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: DashboardScreen.green,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: DashboardScreen.border,
          width: 1,
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 17,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w500,
          color: DashboardScreen.dark,
          height: 1.15,
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.confidence,
    required this.gejala,
    required this.pengendalian,
  });

  final double confidence;
  final String gejala;
  final String pengendalian;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 260),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        color: DashboardScreen.green,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: DashboardScreen.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Confidence: ${(confidence * 100).toStringAsFixed(2)}%',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: DashboardScreen.softText,
            ),
          ),
          const SizedBox(height: 18),
          _SectionText(
            title: 'Ciri-Ciri Gejala',
            content: gejala,
          ),
          const SizedBox(height: 20),
          _SectionText(
            title: 'Pencegahan Awal',
            content: pengendalian,
          ),
        ],
      ),
    );
  }
}

class _SectionText extends StatelessWidget {
  const _SectionText({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF36563C),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          content,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontSize: 14,
            height: 1.75,
            color: Color(0xFF36563C),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}