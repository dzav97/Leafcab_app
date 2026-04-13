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
/// HOME CONTENT (TAB 0)
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
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: const Text(
        "Dashboard",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: DashboardScreen.dark,
          letterSpacing: 0.2,
          height: 1.1,
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF3F3F3),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 130),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _AppLogoHeader(),
            const SizedBox(height: 18),
            _InstructionCard(
              onStartDetection: () => onNavigate(2),
            ),
            const SizedBox(height: 10),
            _buildSectionTitle("Menu"),
            _MenuGrid(
              onArtikelTap: () => onNavigate(1),
              onDeteksiTap: () => onNavigate(2),
              onRiwayatTap: () => onNavigate(3),
            ),
            const SizedBox(height: 12),
            _buildSectionTitle("Artikel"),
            _buildArticleList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: DashboardScreen.dark,
        ),
      ),
    );
  }

  Widget _buildArticleList(BuildContext context) {
    final List<Artikel> articles = artikelData.take(3).toList();

    return Column(
      children: articles.map((artikel) {
        return GestureDetector(
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
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: DashboardScreen.green,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: DashboardScreen.border,
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.article_outlined,
                    size: 28,
                    color: DashboardScreen.dark,
                  ),
                ),
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
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: DashboardScreen.dark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _ringkasIsi(artikel.isi),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: DashboardScreen.softText,
                          fontStyle: FontStyle.italic,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  color: DashboardScreen.dark,
                  size: 22,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  static String _ringkasIsi(String isi) {
    final text = isi.replaceAll('\n', ' ').trim();
    if (text.length <= 90) return text;
    return '${text.substring(0, 90)}...';
  }
}

/// =======================
/// COMPONENT WIDGETS
/// =======================

class _AppLogoHeader extends StatelessWidget {
  const _AppLogoHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFF6F6F0),
            border: Border.all(
              color: const Color(0xFF97AC87),
              width: 1.2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: ClipOval(
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.eco,
                  size: 42,
                  color: DashboardScreen.dark,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Leafcab",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF36563C),
                  height: 1,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Aplikasi Deteksi Daun Cabai",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: DashboardScreen.softText,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InstructionCard extends StatelessWidget {
  const _InstructionCard({required this.onStartDetection});

  final VoidCallback onStartDetection;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: DashboardScreen.green,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: DashboardScreen.border,
          width: 1.2,
        ),
      ),
      child: Column(
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Step(
                  type: _StepType.scan,
                  label: "Ambil\ngambar",
                ),
              ),
              _Arrow(),
              Expanded(
                child: _Step(
                  type: _StepType.diagnose,
                  label: "Lihat\ndiagnosis",
                ),
              ),
              _Arrow(),
              Expanded(
                child: _Step(
                  type: _StepType.result,
                  label: "Dapatkan\nhasil",
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _PillButton(
            text: "Mulai Deteksi",
            onTap: onStartDetection,
          ),
        ],
      ),
    );
  }
}

class _MenuGrid extends StatelessWidget {
  const _MenuGrid({
    required this.onArtikelTap,
    required this.onDeteksiTap,
    required this.onRiwayatTap,
  });

  final VoidCallback onArtikelTap;
  final VoidCallback onDeteksiTap;
  final VoidCallback onRiwayatTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _Menu(
          icon: Icons.article_outlined,
          label: "Artikel",
          onTap: onArtikelTap,
        ),
        _Menu(
          icon: Icons.camera_alt_outlined,
          label: "Deteksi",
          onTap: onDeteksiTap,
        ),
        _Menu(
          icon: Icons.history,
          label: "Riwayat",
          onTap: onRiwayatTap,
        ),
        const _Menu(
          icon: Icons.info_outline,
          label: "Tentang",
          onTap: null,
        ),
      ],
    );
  }
}

/// =======================
/// SMALL HELPERS
/// =======================

class _Arrow extends StatelessWidget {
  const _Arrow();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 10),
      child: Icon(
        Icons.chevron_right,
        size: 36,
        color: DashboardScreen.dark,
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({required this.text, required this.onTap});

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF3C5E40),
          borderRadius: BorderRadius.circular(999),
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              offset: Offset(0, 1),
              color: Colors.black12,
            ),
          ],
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
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 11,
              backgroundColor: Color(0xFF547657),
              child: Icon(
                Icons.chevron_right,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Menu extends StatelessWidget {
  const _Menu({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 78,
        height: 84,
        decoration: BoxDecoration(
          color: DashboardScreen.green,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: DashboardScreen.border,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 34, color: DashboardScreen.dark),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: DashboardScreen.softText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _StepType { scan, diagnose, result }

class _Step extends StatelessWidget {
  const _Step({required this.type, required this.label});

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
            size: 36,
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
            size: 38,
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
        size: 36,
        color: DashboardScreen.dark,
      );
    }

    return Column(
      children: [
        SizedBox(height: 48, child: Center(child: iconWidget)),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontStyle: FontStyle.italic,
            color: DashboardScreen.softText,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

/// =======================
/// BOTTOM NAV
/// =======================
class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 76,
            decoration: const BoxDecoration(
              color: DashboardScreen.green,
              border: Border(
                top: BorderSide(color: DashboardScreen.border, width: 1),
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navIcon(Icons.home_outlined, 0),
                _navIcon(Icons.article_outlined, 1),
                const SizedBox(width: 58),
                _navIcon(Icons.history, 3),
                _navIcon(Icons.account_circle_outlined, 4),
              ],
            ),
          ),
          Positioned(
            top: -14,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => onTap(2),
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F3F3),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE6E0E0),
                      width: 3,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 8,
                        offset: Offset(0, 2),
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 32,
                    color: currentIndex == 2
                        ? DashboardScreen.accentGreen
                        : DashboardScreen.dark,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, int index) {
    final active = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Icon(
          icon,
          size: 34,
          color: active ? DashboardScreen.accentGreen : DashboardScreen.dark,
        ),
      ),
    );
  }
}