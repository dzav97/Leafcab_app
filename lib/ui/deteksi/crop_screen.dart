import 'dart:io';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../dashboard/dashboard_screen.dart';

class CropScreen extends StatefulWidget {
  const CropScreen({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  final CropController _cropController = CropController();

  Uint8List? _imageData;
  bool _isLoadingImage = true;
  bool _isCropping = false;

  @override
  void initState() {
    super.initState();
    _loadImageBytes();
  }

  Future<void> _loadImageBytes() async {
    try {
      final bytes = await File(widget.imagePath).readAsBytes();
      if (!mounted) return;

      setState(() {
        _imageData = bytes;
        _isLoadingImage = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoadingImage = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat gambar: $e')),
      );

      Navigator.pop(context);
    }
  }

  Future<void> _saveCroppedImage(Uint8List croppedData) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(p.join(dir.path, 'history_images'));

      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final fileName = '${const Uuid().v4()}.jpg';
      final filePath = p.join(imagesDir.path, fileName);

      final file = File(filePath);
      await file.writeAsBytes(croppedData);

      if (!mounted) return;
      Navigator.pop(context, file);
    } catch (e) {
      if (!mounted) return;

      setState(() => _isCropping = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan hasil crop: $e')),
      );
    }
  }

  void _startCrop() {
    if (_imageData == null || _isCropping) return;

    setState(() => _isCropping = true);
    _cropController.crop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardScreen.green,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _Header(
              onBack: _isCropping ? null : () => Navigator.pop(context),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF3F3F3),
                child: _isLoadingImage
                    ? const Center(child: CircularProgressIndicator())
                    : _imageData == null
                        ? const Center(
                            child: Text(
                              'Gambar tidak tersedia.',
                              style: TextStyle(
                                color: DashboardScreen.dark,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              const SizedBox(height: 18),
                              const _InstructionText(),
                              const SizedBox(height: 18),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 18),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: DashboardScreen.green,
                                      borderRadius: BorderRadius.circular(28),
                                      border: Border.all(
                                        color: DashboardScreen.border,
                                        width: 1,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(28),
                                      child: Crop(
                                        image: _imageData!,
                                        controller: _cropController,
                                        onCropped: (croppedData) {
                                          _saveCroppedImage(croppedData);
                                        },
                                        withCircleUi: false,
                                        baseColor: DashboardScreen.green,
                                        maskColor:
                                            Colors.black.withValues(alpha:0.45),
                                        radius: 18,
                                        initialSize: 0.75,
                                        fixCropRect: true,
                                        interactive: true,
                                        cornerDotBuilder: (size, edgeAlignment) {
                                          return const _CropCornerDot();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(18, 0, 18, 28),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _BottomButton(
                                        text: 'Batal',
                                        backgroundColor:
                                            const Color(0xFFF7F7F7),
                                        textColor: DashboardScreen.dark,
                                        onTap: _isCropping
                                            ? null
                                            : () => Navigator.pop(context),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _BottomButton(
                                        text: _isCropping
                                            ? 'Memproses...'
                                            : 'Gunakan',
                                        backgroundColor:
                                            DashboardScreen.green,
                                        textColor: DashboardScreen.dark,
                                        onTap: _isCropping ? null : _startCrop,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
  const _Header({this.onBack});

  final VoidCallback? onBack;

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
            child: Icon(
              Icons.arrow_back,
              size: 34,
              color: onBack == null
                  ? DashboardScreen.softText
                  : DashboardScreen.dark,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Potong Gambar',
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

class _InstructionText extends StatelessWidget {
  const _InstructionText();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        'Atur area crop agar fokus pada daun yang akan dideteksi.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontStyle: FontStyle.italic,
          color: DashboardScreen.softText,
          height: 1.5,
        ),
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  const _BottomButton({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  });

  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: DashboardScreen.border,
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: onTap == null ? DashboardScreen.softText : textColor,
          ),
        ),
      ),
    );
  }
}

class _CropCornerDot extends StatelessWidget {
  const _CropCornerDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: DashboardScreen.dark,
          width: 1.4,
        ),
      ),
    );
  }
}