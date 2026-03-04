import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class CropScreen extends StatefulWidget {
  final String imagePath;
  const CropScreen({super.key, required this.imagePath});

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  static const Color primaryGreen = Color(0xFF163225);
  static const Color accentGreen = Color(0xFF1FA85B);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startCrop();
    });
  }

  Future<void> _startCrop() async {
    try {
      final cropped = await ImageCropper().cropImage(
        sourcePath: widget.imagePath,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 85,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Potong Gambar',
            toolbarColor: primaryGreen,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: accentGreen,
            lockAspectRatio: true,
          ),
          IOSUiSettings(title: 'Potong Gambar'),
        ],
      );

      if (!mounted) return;

      if (cropped != null) {
        Navigator.pop(context, File(cropped.path));
      } else {
        Navigator.pop(context); // cancel
      }
    } catch (e) {
      debugPrint("Crop error: $e");
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}