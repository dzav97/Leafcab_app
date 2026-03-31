import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

class CropScreen extends StatefulWidget {
  final String imagePath;
  const CropScreen({super.key, required this.imagePath});

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  static const Color primaryGreen = Color(0xFF163225);
  static const Color accentGreen = Color(0xFF1FA85B);

  static const Color softGreen = Color(0xFFC5DEC5);
  static const Color cardGreen = Color(0xFFAED0AE);
  static const Color bgColor = Colors.white;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startCrop();
    });
  }

  Future<void> _startCrop() async {
    try {
      // Sembunyikan status bar + navigation bar saat cropper dibuka
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

      final cropped = await ImageCropper().cropImage(
        sourcePath: widget.imagePath,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 85,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Potong Gambar',
            toolbarColor: softGreen,
            statusBarColor: softGreen,
            toolbarWidgetColor: primaryGreen,
            activeControlsWidgetColor: accentGreen,
            backgroundColor: bgColor,
            dimmedLayerColor: Colors.black.withOpacity(0.35),
            cropFrameColor: primaryGreen,
            cropGridColor: primaryGreen.withOpacity(0.25),
            cropFrameStrokeWidth: 2,
            lockAspectRatio: true,
            hideBottomControls: false,
            showCropGrid: true,
            initAspectRatio: CropAspectRatioPreset.square,
          ),
          IOSUiSettings(
            title: 'Potong Gambar',
            aspectRatioLockEnabled: true,
            rotateButtonsHidden: false,
            resetButtonHidden: false,
            aspectRatioPickerButtonHidden: true,
          ),
        ],
      );

      // Kembalikan system UI setelah cropper selesai
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );

      if (!mounted) return;

      if (cropped == null) {
        Navigator.pop(context);
        return;
      }

      final dir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(p.join(dir.path, 'history_images'));
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final id = const Uuid().v4();
      final newPath = p.join(imagesDir.path, '$id.jpg');

      final savedFile = await File(cropped.path).copy(newPath);

      try {
        await File(cropped.path).delete();
      } catch (_) {}

      Navigator.pop(context, savedFile);
    } catch (e) {
      // Pastikan system UI tetap dikembalikan kalau error
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );

      debugPrint("Crop error: $e");
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: softGreen,
              child: Row(
                children: [
                  Icon(Icons.close, color: primaryGreen, size: 22),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Potong Gambar',
                        style: TextStyle(
                          color: primaryGreen,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Serif',
                        ),
                      ),
                    ),
                  ),
                  Icon(Icons.check_circle, color: accentGreen, size: 22),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: 185,
                  height: 270,
                  decoration: BoxDecoration(
                    color: cardGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.camera_alt_outlined,
                      size: 72,
                      color: primaryGreen,
                    ),
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