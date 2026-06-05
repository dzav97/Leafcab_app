import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/penyakit_info.dart';
import '../../data/models/riwayat_model.dart';
import '../../repository/riwayat_repository.dart';
import '../../services/riwayat_sync_service.dart';
import '../../services/tflite_service.dart';
import '../dashboard/dashboard_screen.dart';

class HasilScreen extends StatefulWidget {
  const HasilScreen({super.key, required this.imageFile});

  final File imageFile;

  @override
  State<HasilScreen> createState() => _HasilScreenState();
}

class _HasilScreenState extends State<HasilScreen> {
  final repo = RiwayatRepository();
  final syncService = RiwayatSyncService();
  final uuid = const Uuid();
  final tflite = TfliteService();

  bool _saved = false;
  bool _loading = true;

  String _namaTampil = '-';
  double _confidence = 0.0;
  List<String> _gejalaList = [];
  List<String> _pengendalianList = [];

  @override
  void initState() {
    super.initState();
    _runDetection();
  }

  Future<void> _runDetection() async {
    try {
      final result = await tflite.predictImage(widget.imageFile);
      final rawLabel = result.label.trim();

      final info = penyakitCabaiMap[rawLabel];

      if (!mounted) return;
      setState(() {
        _namaTampil = info?.namaTampil ?? rawLabel;
        _confidence = result.confidence;
        _gejalaList = info?.gejala ?? ['Gejala belum tersedia untuk label ini.'];
        _pengendalianList =
            info?.pengendalian ?? ['Pengendalian belum tersedia untuk label ini.'];
        _loading = false;
      });

      await _saveHistoryOnce();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _namaTampil = 'Deteksi Gagal';
        _confidence = 0.0;
        _gejalaList = ['Terjadi kesalahan saat membaca model atau gambar.'];
        _pengendalianList = [
          'Periksa model.tflite, labels.txt, dan preprocessing.',
        ];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal deteksi: $e')),
      );
    }
  }

  Future<void> _saveHistoryOnce() async {
    if (_saved) return;
    _saved = true;

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User belum login. Riwayat tidak dapat disimpan.'),
          ),
        );
        return;
      }

      final now = DateTime.now();
      final localId = uuid.v4();

      final savedImagePath = await _copyImageToPermanentStorage(
        sourceImage: widget.imageFile,
        localId: localId,
      );

      final imageBase64 = await _imageToCompressedBase64(
        file: File(savedImagePath),
      );

      final record = RiwayatDeteksi(
        localId: localId,
        userId: user.uid,
        cloudId: null,
        timestamp: now,
        updatedAt: now,
        gambar: savedImagePath,
        label: _namaTampil,
        confidence: _confidence,
        gejala: _gejalaList.join('\n'),
        pengendalian: _pengendalianList.join('\n'),
        syncState: 'local_only',
        isDeleted: 0,
        storagePath: null,
        imageBase64: imageBase64,
      );

      await repo.simpan(record);

      await syncService.syncRiwayat();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Riwayat tersimpan')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal simpan riwayat: $e')),
      );
    }
  }

  Future<String> _copyImageToPermanentStorage({
    required File sourceImage,
    required String localId,
  }) async {
    final appDir = await getApplicationDocumentsDirectory();

    final extension = p.extension(sourceImage.path).isNotEmpty
        ? p.extension(sourceImage.path)
        : '.jpg';

    final savedImagePath = p.join(
      appDir.path,
      'riwayat_$localId$extension',
    );

    final savedFile = await sourceImage.copy(savedImagePath);

    return savedFile.path;
  }

  Future<String?> _imageToCompressedBase64({
    required File file,
  }) async {
    final bytes = await file.readAsBytes();
    final decodedImage = img.decodeImage(bytes);

    if (decodedImage == null) {
      return null;
    }

    final resizedImage = img.copyResize(
      decodedImage,
      width: 300,
    );

    final jpgBytes = img.encodeJpg(
      resizedImage,
      quality: 55,
    );

    return base64Encode(jpgBytes);
  }

  @override
  void dispose() {
    tflite.close();
    super.dispose();
  }

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
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F6F3),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: _loading
                    ? const _LoadingView()
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                        child: Column(
                          children: [
                            _ImageCard(imageFile: widget.imageFile),
                            const SizedBox(height: 18),
                            _ResultCard(
                              label: _namaTampil,
                              confidence: _confidence,
                            ),
                            const SizedBox(height: 16),
                            _InfoSection(
                              icon: Icons.eco_outlined,
                              title: 'Ciri-Ciri Gejala',
                              content: _gejalaList.join('\n\n'),
                            ),
                            const SizedBox(height: 16),
                            _InfoSection(
                              icon: Icons.health_and_safety_outlined,
                              title: 'Pencegahan Awal',
                              content: _pengendalianList.join('\n\n'),
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

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: DashboardScreen.dark,
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
              'Hasil Deteksi',
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

class _ImageCard extends StatelessWidget {
  const _ImageCard({required this.imageFile});

  final File imageFile;

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
        child: Image.file(
          imageFile,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => const Center(
            child: Icon(
              Icons.image_outlined,
              size: 60,
              color: DashboardScreen.dark,
            ),
          ),
        ),
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
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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