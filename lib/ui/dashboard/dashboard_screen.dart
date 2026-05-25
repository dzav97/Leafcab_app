import 'package:flutter/material.dart';

import '../../data/models/artikel_model.dart';
import '../../core/artikel_data.dart';
import '../artikel/artikel_screen.dart';
import '../artikel/detail_artikel_screen.dart';
import '../deteksi/deteksi_screen.dart';
import '../riwayat/riwayat_screen.dart';
import '../akun/akun_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const green = Color(0xFFB7D7B8);
  static const dark = Color(0xFF22352A);
  static const white = Color(0xFFF7F7F7);
  static const accentGreen = Color(0xFF2FA84F);
  static const softText = Color(0xFF55685B);
  static const border = Color(0xFF23352B);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = [
    _HomeContent(onNavigate: _onNavTap),
    const ArtikelScreen(),
    const DeteksiScreen(),
    const RiwayatScreen(),
    const AkunScreen(),
  ];

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardScreen.green,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

/// =======================
/// HOME CONTENT
/// =======================
class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.onNavigate});

  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(child: _buildMainContent(context)),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: DashboardScreen.green,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
      child: const Text(
        'Beranda',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w900,
          color: DashboardScreen.dark,
          letterSpacing: 0.2,
          height: 1.05,
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF4F6F3),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 22, 18, 130),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _AppLogoHeader(),
            const SizedBox(height: 18),

            _InstructionCard(
              onStartDetection: () => onNavigate(2),
            ),

            const SizedBox(height: 24),

            _SectionHeader(
              title: 'Artikel',
              actionText: 'Lihat semua',
              onActionTap: () => onNavigate(1),
            ),

            const SizedBox(height: 12),
            _buildArticleList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleList(BuildContext context) {
    final List<Artikel> articles = artikelData.take(3).toList();

    return Column(
      children: articles.map((artikel) {
        return _ArticleCard(artikel: artikel);
      }).toList(),
    );
  }
}

/// LOGO HEADER
class _AppLogoHeader extends StatelessWidget {
  const _AppLogoHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: DashboardScreen.green,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: DashboardScreen.border,
          width: 1.1,
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            offset: Offset(0, 3),
            color: Colors.black12,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF6F6F0),
              border: Border.all(
                color: const Color(0xFF97AC87),
                width: 1.2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(7),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const Icon(
                    Icons.eco,
                    size: 42,
                    color: DashboardScreen.dark,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Leafcab',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF36563C),
                    height: 1,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Aplikasi Deteksi Daun Cabai',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: DashboardScreen.softText,
                    height: 1.25,
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

/// PANDUAN CARD
class _InstructionCard extends StatelessWidget {
  const _InstructionCard({required this.onStartDetection});

  final VoidCallback onStartDetection;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
      decoration: BoxDecoration(
        color: DashboardScreen.green,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: DashboardScreen.border,
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            offset: Offset(0, 3),
            color: Colors.black12,
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Step(
                  type: _StepType.scan,
                  label: 'Ambil\ngambar',
                ),
              ),
              _Arrow(),
              Expanded(
                child: _Step(
                  type: _StepType.diagnose,
                  label: 'Lihat\ndiagnosis',
                ),
              ),
              _Arrow(),
              Expanded(
                child: _Step(
                  type: _StepType.result,
                  label: 'Dapatkan\nhasil',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _PillButton(
            text: 'Mulai Deteksi',
            onTap: onStartDetection,
          ),
        ],
      ),
    );
  }
}

enum _StepType { scan, diagnose, result }

class _Step extends StatelessWidget {
  const _Step({
    required this.type,
    required this.label,
  });

  final _StepType type;
  final String label;

  @override
  Widget build(BuildContext context) {
    Widget iconWidget;

    if (type == _StepType.scan) {
      iconWidget = Stack(
        alignment: Alignment.center,
        children: const [
          Icon(
            Icons.center_focus_strong,
            size: 38,
            color: DashboardScreen.dark,
          ),
          Icon(
            Icons.eco,
            size: 22,
            color: DashboardScreen.accentGreen,
          ),
        ],
      );
    } else if (type == _StepType.diagnose) {
      iconWidget = Stack(
        alignment: Alignment.center,
        children: const [
          Icon(
            Icons.assignment_outlined,
            size: 40,
            color: DashboardScreen.dark,
          ),
          Positioned(
            bottom: 3,
            child: Icon(
              Icons.check_circle,
              size: 16,
              color: DashboardScreen.accentGreen,
            ),
          ),
        ],
      );
    } else {
      iconWidget = const Icon(
        Icons.battery_full,
        size: 38,
        color: DashboardScreen.dark,
      );
    }

    return Column(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: const BoxDecoration(
            color: Color(0xFFD7E9D8),
            shape: BoxShape.circle,
          ),
          child: Center(child: iconWidget),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12.5,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
            color: DashboardScreen.softText,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 12),
      child: Icon(
        Icons.chevron_right_rounded,
        size: 34,
        color: DashboardScreen.dark,
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.text,
    required this.onTap,
  });

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF3C5E40),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              const CircleAvatar(
                radius: 11,
                backgroundColor: Color(0xFF547657),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
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

/// SECTION HEADER
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionText,
    required this.onActionTap,
  });

  final String title;
  final String actionText;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: DashboardScreen.dark,
            ),
          ),
        ),
        InkWell(
          onTap: onActionTap,
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: const [
                Text(
                  'Lihat semua',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF36563C),
                  ),
                ),
                SizedBox(width: 2),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: Color(0xFF36563C),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


/// LIST ARTIKEL
class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.artikel});

  final Artikel artikel;

  @override
  Widget build(BuildContext context) {
    final ringkasan = _ringkasIsi(artikel.isi);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailArtikelScreen(artikel: artikel),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: DashboardScreen.green,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: DashboardScreen.border,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              _ArticleThumbnail(imagePath: artikel.gambar),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artikel.judul,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: DashboardScreen.dark,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ringkasan,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: DashboardScreen.softText,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right_rounded,
                color: DashboardScreen.dark,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _ringkasIsi(String isi) {
    final text = isi.replaceAll('\n', ' ').trim();
    if (text.length <= 95) return text;
    return '${text.substring(0, 95)}...';
  }
}

class _ArticleThumbnail extends StatelessWidget {
  const _ArticleThumbnail({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 66,
      height: 66,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF9DB68E),
          width: 1,
        ),
      ),
      child: imagePath.isEmpty
          ? const Icon(
              Icons.article_outlined,
              size: 30,
              color: DashboardScreen.dark,
            )
          : Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Icon(
                Icons.article_outlined,
                size: 30,
                color: DashboardScreen.dark,
              ),
            ),
    );
  }
}

/// BOTTOM NAVIGASI
class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      color: const Color(0xFFF3F3F3),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 76,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                color: DashboardScreen.green,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                border: Border(
                  top: BorderSide(
                    color: DashboardScreen.border,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _BottomNavItem(
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home_rounded,
                      label: 'Beranda',
                      active: currentIndex == 0,
                      onTap: () => onTap(0),
                    ),
                  ),
                  Expanded(
                    child: _BottomNavItem(
                      icon: Icons.article_outlined,
                      activeIcon: Icons.article_rounded,
                      label: 'Artikel',
                      active: currentIndex == 1,
                      onTap: () => onTap(1),
                    ),
                  ),
                  const SizedBox(width: 76),
                  Expanded(
                    child: _BottomNavItem(
                      icon: Icons.history_outlined,
                      activeIcon: Icons.history_rounded,
                      label: 'Riwayat',
                      active: currentIndex == 3,
                      onTap: () => onTap(3),
                    ),
                  ),
                  Expanded(
                    child: _BottomNavItem(
                      icon: Icons.person_outline_rounded,
                      activeIcon: Icons.person_rounded,
                      label: 'Akun',
                      active: currentIndex == 4,
                      onTap: () => onTap(4),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: () => onTap(2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      color: currentIndex == 2
                          ? const Color(0xFF36563C)
                          : const Color(0xFFF6F3F3),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: currentIndex == 2
                            ? const Color(0xFF36563C)
                            : const Color(0xFFE6E0E0),
                        width: 3,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 8,
                          offset: Offset(0, 3),
                          color: Colors.black12,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      size: 32,
                      color: currentIndex == 2
                          ? Colors.white
                          : DashboardScreen.dark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Deteksi',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: currentIndex == 2
                          ? const Color(0xFF36563C)
                          : DashboardScreen.dark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF36563C) : DashboardScreen.dark;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: 76,
        child: Padding(
          padding: const EdgeInsets.only(top: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                active ? activeIcon : icon,
                size: 29,
                color: color,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: active ? 18 : 0,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF36563C),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}