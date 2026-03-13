import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/models/riwayat_model.dart';

class DetailRiwayatScreen extends StatelessWidget {
  const DetailRiwayatScreen({super.key, required this.item});

  final RiwayatDeteksi item;

  static const Color primaryGreen = Color(0xFF163225);
  static const Color cardGreen = Color(0xFFA5D6A7);
  static const Color bgGreen = Color(0xFFCDE4C5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreen,
      appBar: AppBar(
        title: const Text(
          'Detail Riwayat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: primaryGreen,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: cardGreen.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.file(
                    File(item.gambar),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.image_not_supported,
                      size: 60,
                      color: primaryGreen,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: cardGreen,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Confidence: ${(item.confidence * 100).toStringAsFixed(2)}%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: primaryGreen,
                ),
              ),
              const SizedBox(height: 20),
              _buildInfoCard(
                title: 'Ciri-Ciri Gejala:',
                content: item.gejala,
              ),
              const SizedBox(height: 14),
              _buildInfoCard(
                title: 'Pencegahan Awal:',
                content: item.pengendalian,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardGreen.withOpacity(0.8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: primaryGreen,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: primaryGreen,
            ),
          ),
        ],
      ),
    );
  }
}