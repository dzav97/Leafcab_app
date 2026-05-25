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
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F6F3),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: _isLoadingImage
                    ? const _LoadingView()
                    : _imageData == null
                        ? const _EmptyView()
                        : Column(
                            children: [
                              const SizedBox(height: 18),
                              const _InstructionCard(),
                              const SizedBox(height: 18),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                  ),
                                  child: _CropArea(
                                    imageData: _imageData!,
                                    cropController: _cropController,
                                    onCropped: _saveCroppedImage,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(18, 0, 18, 28),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _BottomButton(
                                        text: 'Batal',
                                        icon: Icons.close_rounded,
                                        backgroundColor:
                                            const Color(0xFFF7F7F7),
                                        textColor: DashboardScreen.dark,
                                        onTap: _isCropping
                                            ? null
                                            : () => Navigator.pop(context),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: _BottomButton(
                                        text: _isCropping
                                            ? 'Memproses...'
                                            : 'Gunakan',
                                        icon: _isCropping
                                            ? Icons.hourglass_top_rounded
                                            : Icons.check_rounded,
                                        backgroundColor:
                                            const Color(0xFF36563C),
                                        textColor: Colors.white,
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

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Gambar tidak tersedia.',
        style: TextStyle(
          color: DashboardScreen.dark,
          fontSize: 14,
          fontWeight: FontWeight.w600,
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
    final disabled = onBack == null;

    return Container(
      width: double.infinity,
      color: DashboardScreen.green,
      padding: const EdgeInsets.fromLTRB(12, 12, 24, 18),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: disabled ? DashboardScreen.softText : DashboardScreen.dark,
              size: 28,
            ),
          ),
          const SizedBox(width: 4),
          const Expanded(
            child: Text(
              'Potong Gambar',
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

class _InstructionCard extends StatelessWidget {
  const _InstructionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: DashboardScreen.green,
        borderRadius: BorderRadius.circular(20),
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
            radius: 17,
            backgroundColor: Color(0xFFD7E9D8),
            child: Icon(
              Icons.crop_rounded,
              size: 21,
              color: DashboardScreen.dark,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Atur area crop agar fokus pada daun yang akan dideteksi.',
              style: TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: DashboardScreen.softText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CropArea extends StatelessWidget {
  const _CropArea({
    required this.imageData,
    required this.cropController,
    required this.onCropped,
  });

  final Uint8List imageData;
  final CropController cropController;
  final ValueChanged<Uint8List> onCropped;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      child: Crop(
        image: imageData,
        controller: cropController,
        onCropped: onCropped,
        withCircleUi: false,
        baseColor: DashboardScreen.green,
        maskColor: Colors.black.withValues(alpha: 0.45),
        radius: 18,
        initialSize: 0.82,
        fixCropRect: true,
        interactive: true,
        cornerDotBuilder: (size, edgeAlignment) {
          return const _CropCornerDot();
        },
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  const _BottomButton({
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  });

  final String text;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;

    return Material(
      color: disabled ? const Color(0xFFE1E5E0) : backgroundColor,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 46,
          alignment: Alignment.center,
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
                size: 21,
                color: disabled ? DashboardScreen.softText : textColor,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: disabled ? DashboardScreen.softText : textColor,
                ),
              ),
            ],
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
      width: 19,
      height: 19,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: DashboardScreen.dark,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}