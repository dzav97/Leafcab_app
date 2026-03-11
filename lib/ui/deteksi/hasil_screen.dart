import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../core/penyakit_info.dart';
import '../../repository/riwayat_repository.dart';
import '../../data/models/riwayat_model.dart';
import '../../services/tflite_service.dart';

class HasilScreen extends StatefulWidget {
  const HasilScreen({super.key, required this.imageFile});
  final File imageFile;

  @override
  State<HasilScreen> createState() => _HasilScreenState();
}

class _HasilScreenState extends State<HasilScreen> {
  final repo = RiwayatRepository();
  final uuid = const Uuid();
  final tflite = TfliteService();

  bool _saved = false;
  bool _loading = true;

  String _rawLabel = '-';
  String _namaTampil = '-';
  double _confidence = 0.0;
  List<String> _gejalaList = [];
  List<String> _pengendalianList = [];

  static const Color primaryGreen = Color(0xFF163225);
  static const Color cardGreen = Color(0xFFA5D6A7);
  static const Color bgGreen = Color(0xFFCDE4C5);

  @override
  void initState() {
    super.initState();
    _runDetection();
  }

  Future<void> _runDetection() async {
    try {
      final result = await tflite.predictImage(widget.imageFile);
      final rawLabel = result.label.toLowerCase().trim();

      final info = penyakitCabaiMap[rawLabel];

      setState(() {
        _rawLabel = rawLabel;
        _namaTampil = info?.namaTampil ?? rawLabel;
        _confidence = result.confidence;
        _gejalaList = info?.gejala ?? ['Gejala belum tersedia untuk label ini.'];
        _pengendalianList =
            info?.pengendalian ?? ['Pengendalian belum tersedia untuk label ini.'];
        _loading = false;
      });

      await _saveHistoryOnce(result.scores);
    } catch (e) {
      setState(() {
        _loading = false;
        _namaTampil = 'Deteksi Gagal';
        _gejalaList = ['Terjadi kesalahan saat membaca model atau gambar.'];
        _pengendalianList = [
          'Periksa model.tflite, labels.txt, config.json, dan preprocessing.'
        ];
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal deteksi: $e')),
      );
    }
  }

  Future<void> _saveHistoryOnce(List<double> scores) async {
    if (_saved) return;
    _saved = true;

    try {
      final record = RiwayatDeteksi(
        localId: uuid.v4(),
        timestamp: DateTime.now(),
        gambar: widget.imageFile.path,
        label: _namaTampil,
        confidence: _confidence,
        description:
            'Gejala:\n• ${_gejalaList.join('\n• ')}\n\nPengendalian:\n• ${_pengendalianList.join('\n• ')}',
        syncState: 'local_only',
      );

      await repo.simpan(record);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Riwayat tersimpan")),
      );

      debugPrint(jsonEncode({
        'raw_label': _rawLabel,
        'display_label': _namaTampil,
        'confidence': _confidence,
        'scores': scores,
      }));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal simpan riwayat: $e")),
      );
    }
  }

  @override
  void dispose() {
    tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreen,
      appBar: AppBar(
        title: const Text(
          "Hasil Deteksi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: primaryGreen,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                      width: double.infinity,
                      height: 230,
                      decoration: BoxDecoration(
                        color: cardGreen.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.file(
                          widget.imageFile,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 64,
                              color: primaryGreen,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: cardGreen,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _namaTampil,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryGreen,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Confidence: ${(_confidence * 100).toStringAsFixed(2)}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildBulletCard(
                      title: 'Ciri-Ciri Gejala:',
                      items: _gejalaList,
                    ),
                    const SizedBox(height: 14),
                    _buildBulletCard(
                      title: 'Pencegahan Awal:',
                      items: _pengendalianList,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildBulletCard({
    required String title,
    required List<String> items,
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
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}