import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../dashboard/dashboard_screen.dart';
import 'crop_screen.dart';
import 'hasil_screen.dart';

class DeteksiScreen extends StatefulWidget {
  const DeteksiScreen({super.key});

  @override
  State<DeteksiScreen> createState() => _DeteksiScreenState();
}

class _DeteksiScreenState extends State<DeteksiScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> _pickAndCropImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1600,
        maxHeight: 1600,
      );

      if (picked == null) return;
      if (!mounted) return;

      final croppedFile = await Navigator.push<File?>(
        context,
        MaterialPageRoute(
          builder: (_) => CropScreen(imagePath: picked.path),
        ),
      );

      if (croppedFile == null || !mounted) return;

      setState(() => _image = croppedFile);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal ambil gambar: $e')),
      );
    }
  }

  void _processImage() {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih gambar terlebih dahulu.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HasilScreen(imageFile: _image!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardScreen.green,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _HeaderTitle(title: 'Deteksi'),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F6F3),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 120),
                  child: Column(
                    children: [
                      const _InstructionBox(),
                      const SizedBox(height: 22),
                      _PreviewCard(image: _image),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _ActionButton(
                              icon: Icons.camera_alt_outlined,
                              label: 'Kamera',
                              onTap: () =>
                                  _pickAndCropImage(ImageSource.camera),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _ActionButton(
                              icon: Icons.photo_library_outlined,
                              label: 'Galeri',
                              onTap: () =>
                                  _pickAndCropImage(ImageSource.gallery),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      _ProcessButton(
                        onTap: _processImage,
                        enabled: _image != null,
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

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: DashboardScreen.green,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w900,
          color: DashboardScreen.dark,
          letterSpacing: 0.2,
          height: 1.05,
        ),
      ),
    );
  }
}

class _InstructionBox extends StatelessWidget {
  const _InstructionBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: DashboardScreen.green,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: DashboardScreen.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFD7E9D8),
            child: Icon(
              Icons.info_outline,
              size: 22,
              color: DashboardScreen.dark,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Petunjuk Deteksi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF36563C),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Pastikan pencahayaan cukup dan gambar daun terlihat jelas agar hasil deteksi lebih akurat.',
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.45,
                    color: DashboardScreen.softText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.image});

  final File? image;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth;

        return Container(
          width: size,
          height: size,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: DashboardScreen.green,
            borderRadius: BorderRadius.circular(28),
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
          child: image == null
              ? const _CameraPlaceholder()
              : Image.file(
                  image!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
        );
      },
    );
  }
}

class _CameraPlaceholder extends StatelessWidget {
  const _CameraPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DashboardScreen.green,
      padding: const EdgeInsets.all(24),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate_outlined,
            size: 82,
            color: DashboardScreen.dark,
          ),
          SizedBox(height: 14),
          Text(
            'Belum ada gambar',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF36563C),
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Ambil foto atau pilih gambar daun cabai dari galeri.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.35,
              fontWeight: FontWeight.w500,
              color: DashboardScreen.softText,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF8F8F8),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: DashboardScreen.border,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 23,
                color: DashboardScreen.dark,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF36563C),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProcessButton extends StatelessWidget {
  const _ProcessButton({
    required this.onTap,
    required this.enabled,
  });

  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled
          ? const Color(0xFF36563C)
          : const Color(0xFF9DB68E),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: double.infinity,
          height: 46,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.search_rounded,
                size: 22,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                enabled ? 'Mulai Proses Deteksi' : 'Pilih Gambar Dahulu',
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}