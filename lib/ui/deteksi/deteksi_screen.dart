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
        SnackBar(content: Text("Gagal ambil gambar: $e")),
      );
    }
  }

  void _processImage() {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih gambar terlebih dahulu.")),
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
            const _HeaderTitle(),
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF3F3F3),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 120),
                  child: Column(
                    children: [
                      const _InstructionBox(),
                      const SizedBox(height: 28),
                      _PreviewCard(image: _image),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _ActionButton(
                            icon: Icons.camera_alt_outlined,
                            label: "Kamera",
                            onTap: () => _pickAndCropImage(ImageSource.camera),
                          ),
                          _ActionButton(
                            icon: Icons.photo_library_outlined,
                            label: "Galeri",
                            onTap: () => _pickAndCropImage(ImageSource.gallery),
                          ),
                        ],
                      ),
                      const SizedBox(height: 26),
                      _ProcessButton(onTap: _processImage),
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
  const _HeaderTitle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: DashboardScreen.green,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
      child: const Text(
        "Deteksi",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: DashboardScreen.dark,
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
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: DashboardScreen.green,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: DashboardScreen.border,
          width: 1,
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.info_outline,
              size: 26,
              color: DashboardScreen.dark,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Petunjuk\nPastikan pencahayaan cukup dan gambar daun terlihat jelas agar hasil deteksi lebih akurat.",
              style: TextStyle(
                fontSize: 13,
                height: 1.6,
                fontStyle: FontStyle.italic,
                color: DashboardScreen.softText,
              ),
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
    return Container(
      width: double.infinity,
      height: 362,
      decoration: BoxDecoration(
        color: DashboardScreen.green,
        borderRadius: BorderRadius.circular(34),
        border: Border.all(
          color: DashboardScreen.border,
          width: 1,
        ),
      ),
      child: image == null
          ? const Center(
              child: _CameraPlaceholder(),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(34),
              child: Image.file(
                image!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}

class _CameraPlaceholder extends StatelessWidget {
  const _CameraPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.camera_alt_outlined,
          size: 120,
          color: DashboardScreen.dark,
        ),
      ],
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 145,
        height: 34,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
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
              size: 22,
              color: DashboardScreen.dark,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF36563C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProcessButton extends StatelessWidget {
  const _ProcessButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: DashboardScreen.border,
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: const Text(
          "Mulai Proses Deteksi",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF36563C),
          ),
        ),
      ),
    );
  }
}