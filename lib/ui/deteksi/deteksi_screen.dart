import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  static const Color primaryGreen = Color(0xFF163225);
  static const Color accentGreen = Color(0xFF1FA85B);
  static const Color cardGreen = Color(0xFFA5D6A7);
  static const Color bgGreen = Color(0xFFCDE4C5);

  Future<void> _pickAndCropImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1280,
        maxHeight: 1280,
      );

      if (picked == null) return;

      final croppedFile = await Navigator.push<File?>(
        context,
        MaterialPageRoute(
          builder: (_) => CropScreen(imagePath: picked.path),
        ),
      );

      if (croppedFile == null) return;

      if (!mounted) return;
      setState(() => _image = croppedFile);
    } catch (e, st) {
      debugPrint("Pick/Crop error: $e\n$st");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal ambil/potong gambar: $e")),
      );
    }
  }

  void _processImage() {
    if (_image == null) return;

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
      backgroundColor: bgGreen,
      appBar: AppBar(
        title: const Text(
          "Deteksi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: primaryGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: cardGreen,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: primaryGreen),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Pastikan pencahayaan cukup dan gambar daun terlihat jelas.",
                      style: TextStyle(fontSize: 12, color: primaryGreen),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: cardGreen, width: 2),
                ),
                child: _image == null
                    ? const Icon(
                        Icons.camera_alt_outlined,
                        size: 100,
                        color: cardGreen,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.file(_image!, fit: BoxFit.cover),
                      ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.camera_enhance,
                  label: "Kamera",
                  onTap: () => _pickAndCropImage(ImageSource.camera),
                ),
                _buildActionButton(
                  icon: Icons.photo_library,
                  label: "Galeri",
                  onTap: () => _pickAndCropImage(ImageSource.gallery),
                ),
              ],
            ),

            if (_image != null) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _processImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "MULAI PROSES DETEKSI",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: primaryGreen,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        elevation: 2,
      ),
    );
  }
}