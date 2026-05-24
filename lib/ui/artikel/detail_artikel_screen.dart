import 'package:flutter/material.dart';

import '../../data/models/artikel_model.dart';
import '../dashboard/dashboard_screen.dart';

class DetailArtikelScreen extends StatelessWidget {
  const DetailArtikelScreen({
    super.key,
    required this.artikel,
  });

  final Artikel artikel;

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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TitleSection(title: artikel.judul),
                      const SizedBox(height: 22),

                      if (artikel.gambar.isNotEmpty) ...[
                        _ArticleImage(imagePath: artikel.gambar),
                        const SizedBox(height: 22),
                      ],

                      _ContentCard(content: artikel.isi),
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
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: onBack,
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(
                Icons.arrow_back,
                size: 32,
                color: DashboardScreen.dark,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Detail Artikel',
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

class _TitleSection extends StatelessWidget {
  const _TitleSection({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: DashboardScreen.green,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: DashboardScreen.border,
          width: 1,
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Color(0xFF36563C),
          height: 1.25,
        ),
      ),
    );
  }
}

class _ArticleImage extends StatelessWidget {
  const _ArticleImage({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8EE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: DashboardScreen.border,
          width: 1,
        ),
      ),
      child: Image.asset(
        imagePath,
        width: double.infinity,
        fit: BoxFit.fitWidth,
        errorBuilder: (_, __, ___) {
          return Container(
            height: 180,
            width: double.infinity,
            alignment: Alignment.center,
            color: DashboardScreen.green,
            child: const Icon(
              Icons.image_not_supported_outlined,
              size: 42,
              color: DashboardScreen.dark,
            ),
          );
        },
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({required this.content});

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
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 26),
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
        children: List.generate(paragraphs.length, (index) {
          final paragraph = paragraphs[index].trim();

          return Padding(
            padding: EdgeInsets.only(
              bottom: index == paragraphs.length - 1 ? 0 : 18,
            ),
            child: Text(
              paragraph,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 15,
                height: 1.7,
                fontWeight: FontWeight.w400,
                color: Color(0xFF36563C),
                letterSpacing: 0.05,
              ),
            ),
          );
        }),
      ),
    );
  }
}