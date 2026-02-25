import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Tema Warna
  static const green = Color(0xFFB1D8B7);
  static const dark = Color(0xFF163225);
  static const white = Colors.white;
  static const accentGreen = Color(0xFF1FA85B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: green,
      body: SafeArea(
        child: Stack(
          children: [
            _buildHeaderTitle(),
            _buildMainContent(),
          ],
        ),
      ),
      bottomNavigationBar: const _BottomNav(),
    );
  }

  // --- UI Sections ---

  Widget _buildHeaderTitle() {
    return const Padding(
      padding: EdgeInsets.only(left: 24, top: 16),
      child: Text(
        "Dashboard",
        style: TextStyle(
          fontSize: 34, 
          fontWeight: FontWeight.w800, 
          color: dark, 
          height: 1.05
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.only(top: 78),
      child: Container(
        decoration: const BoxDecoration(
          color: white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 130),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _AppLogoHeader(),
              const SizedBox(height: 18),
              const _InstructionCard(),
              const SizedBox(height: 18),
              _buildSectionTitle("Menu"),
              const _MenuGrid(),
              const SizedBox(height: 18),
              _buildSectionTitle("Artikel"),
              _buildArticlePlaceholder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: dark),
      ),
    );
  }

  Widget _buildArticlePlaceholder() {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        color: green, 
        borderRadius: BorderRadius.circular(18)
      ),
    );
  }
}

// --- Component Widgets ---

class _AppLogoHeader extends StatelessWidget {
  const _AppLogoHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 78, height: 78,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: DashboardScreen.green.withOpacity(0.8), width: 2),
          ),
          child: ClipOval(
            child: Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.eco, size: 42, color: DashboardScreen.dark),
            ),
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            children: [
              Text("Leafcab", style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: DashboardScreen.dark, height: 1)),
              SizedBox(height: 4),
              Text("Aplikasi Deteksi Daun Cabai", style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: DashboardScreen.dark)),
            ],
          ),
        ),
      ],
    );
  }
}

class _InstructionCard extends StatelessWidget {
  const _InstructionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: DashboardScreen.green, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(child: _Step(type: _StepType.scan, label: "Ambil\ngambar")),
              _Arrow(),
              Expanded(child: _Step(type: _StepType.diagnose, label: "Lihat\ndiagnosis")),
              _Arrow(),
              Expanded(child: _Step(type: _StepType.result, label: "Dapatkan\nhasil")),
            ],
          ),
          const SizedBox(height: 14),
          _PillButton(text: "Mulai Deteksi", onTap: () {}),
        ],
      ),
    );
  }
}

class _MenuGrid extends StatelessWidget {
  const _MenuGrid();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _Menu(icon: Icons.article_outlined, label: "Artikel"),
        _Menu(icon: Icons.camera_alt_outlined, label: "Deteksi"),
        _Menu(icon: Icons.history, label: "Riwayat"),
        _Menu(icon: Icons.info_outline, label: "Tentang"),
      ],
    );
  }
}

// --- Small Helper Widgets ---

class _Arrow extends StatelessWidget {
  const _Arrow();
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.only(top: 6),
    child: Icon(Icons.chevron_right, size: 34, color: DashboardScreen.dark),
  );
}

class _PillButton extends StatelessWidget {
  const _PillButton({required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, style: const TextStyle(color: DashboardScreen.dark, fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            const CircleAvatar(
              radius: 13,
              backgroundColor: DashboardScreen.dark,
              child: Icon(Icons.chevron_right, size: 18, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class _Menu extends StatelessWidget {
  const _Menu({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: 70, height: 70,
        decoration: BoxDecoration(color: DashboardScreen.green, borderRadius: BorderRadius.circular(14)),
        child: Icon(icon, size: 30, color: DashboardScreen.dark),
      ),
      const SizedBox(height: 6),
      Text(label, style: const TextStyle(fontSize: 12, color: DashboardScreen.dark)),
    ],
  );
}

enum _StepType { scan, diagnose, result }

class _Step extends StatelessWidget {
  const _Step({required this.type, required this.label});
  final _StepType type;
  final String label;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    if (type == _StepType.scan) icon = Icons.center_focus_strong;
    else if (type == _StepType.diagnose) icon = Icons.assignment_outlined;
    else icon = Icons.check_circle_outline;

    return Column(
      children: [
        Icon(icon, size: 34, color: DashboardScreen.dark),
        const SizedBox(height: 6),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: DashboardScreen.dark)),
      ],
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 70,
            color: DashboardScreen.green,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.home, size: 32, color: DashboardScreen.dark),
                Icon(Icons.article_outlined, size: 32, color: DashboardScreen.dark),
                SizedBox(width: 60),
                Icon(Icons.history, size: 32, color: DashboardScreen.dark),
                Icon(Icons.info_outline, size: 32, color: DashboardScreen.dark),
              ],
            ),
          ),
          Positioned(
            top: -20, left: 0, right: 0,
            child: Center(
              child: Container(
                width: 65, height: 65,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)]),
                child: const Icon(Icons.camera_alt, size: 30, color: DashboardScreen.dark),
              ),
            ),
          ),
        ],
      ),
    );
  }
}