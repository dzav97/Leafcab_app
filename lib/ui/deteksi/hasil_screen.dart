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

  String _rawLabel = '-';
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
        _rawLabel = rawLabel;
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

      // Langsung sync ke Firestore supaya device lain bisa ambil image_base64.
      await syncService.syncRiwayat();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Riwayat tersimpan")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal simpan riwayat: $e")),
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
                color: const Color(0xFFF3F3F3),
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 22, 24, 28),
                        child: Column(
                          children: [
                            _ImageCard(imageFile: widget.imageFile),
                            const SizedBox(height: 16),
                            _ResultBadge(label: _namaTampil),
                            const SizedBox(height: 8),
                            Text(
                              'Confidence: ${(_confidence * 100).toStringAsFixed(2)}%',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: DashboardScreen.softText,
                              ),
                            ),
                            const SizedBox(height: 22),
                            _InfoCard(
                              gejalaList: _gejalaList,
                              pengendalianList: _pengendalianList,
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
            "Hasil Deteksi",
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

class _ImageCard extends StatelessWidget {
  const _ImageCard({required this.imageFile});

  final File imageFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      height: 300,
      decoration: BoxDecoration(
        color: DashboardScreen.green,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: DashboardScreen.border,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.file(
          imageFile,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Center(
            child: Icon(
              Icons.image_outlined,
              size: 70,
              color: DashboardScreen.dark,
            ),
          ),
        ),
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
      constraints: const BoxConstraints(minWidth: 175, maxWidth: 230),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
          fontWeight: FontWeight.w800,
          color: Colors.black,
          height: 1.15,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.gejalaList,
    required this.pengendalianList,
  });

  final List<String> gejalaList;
  final List<String> pengendalianList;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 320),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
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
          const Text(
            'Ciri-Ciri Gejala:',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF36563C),
            ),
          ),
          const SizedBox(height: 12),
          ...gejalaList.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                '• ${item.trim()}',
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.7,
                  color: Color(0xFF36563C),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 26),
          const Text(
            'Pencegahan Awal:',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF36563C),
            ),
          ),
          const SizedBox(height: 12),
          ...pengendalianList.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                '• ${item.trim()}',
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.7,
                  color: Color(0xFF36563C),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}