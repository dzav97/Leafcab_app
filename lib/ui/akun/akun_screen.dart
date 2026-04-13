import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../auth/login_screen.dart';
import '../dashboard/dashboard_screen.dart';
import 'edit_akun_screen.dart';

class AkunScreen extends StatefulWidget {
  const AkunScreen({super.key});

  @override
  State<AkunScreen> createState() => _AkunScreenState();
}

class _AkunScreenState extends State<AkunScreen> {
  final _auth = AuthService();

  Future<void> _logout() async {
    await _auth.keluar();
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  Future<void> _hapusAkunDialog() async {
    final passwordC = TextEditingController();
    final rootContext = context;

    await showDialog(
      context: rootContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Akun'),
        content: TextField(
          controller: passwordC,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Masukkan password saat ini',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              final pesan = await _auth.hapusAkun(
                currentPassword: passwordC.text,
              );

              if (!mounted) return;

              if (pesan == null) {
                if (Navigator.canPop(dialogContext)) {
                  Navigator.pop(dialogContext);
                }

                if (!mounted) return;

                Navigator.pushAndRemoveUntil(
                  rootContext,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false,
                );
              } else {
                if (Navigator.canPop(dialogContext)) {
                  Navigator.pop(dialogContext);
                }

                ScaffoldMessenger.of(rootContext).showSnackBar(
                  SnackBar(content: Text(pesan)),
                );
              }
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    passwordC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final username = user?.displayName?.isNotEmpty == true
        ? user!.displayName!
        : 'Belum diatur';
    final email = user?.email ?? 'Belum diatur';

    return Scaffold(
      backgroundColor: DashboardScreen.green,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _Header(),
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF3F3F3),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 48, 24, 120),
                  child: Column(
                    children: [
                      const _AvatarCircle(),
                      const SizedBox(height: 22),
                      _EditProfileButton(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EditAkunScreen(),
                            ),
                          );
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 38),
                      _InfoCard(
                        username: username,
                        email: email,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: _ActionButton(
                              text: 'Logout',
                              textColor: Colors.black,
                              borderColor: DashboardScreen.border,
                              onTap: _logout,
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: _ActionButton(
                              text: 'Hapus Akun',
                              textColor: Colors.red,
                              borderColor: DashboardScreen.border,
                              onTap: _hapusAkunDialog,
                            ),
                          ),
                        ],
                      ),
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
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: DashboardScreen.green,
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 16),
      child: Row(
        children: const [
          Expanded(
            child: Text(
              'Akun',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: DashboardScreen.dark,
                height: 1.05,
              ),
            ),
          ),
          Icon(
            Icons.info_outline,
            size: 34,
            color: DashboardScreen.dark,
          ),
        ],
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 102,
      height: 102,
      decoration: BoxDecoration(
        color: DashboardScreen.green,
        shape: BoxShape.circle,
        border: Border.all(
          color: DashboardScreen.border,
          width: 1,
        ),
      ),
    );
  }
}

class _EditProfileButton extends StatelessWidget {
  const _EditProfileButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 120,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: DashboardScreen.border,
            width: 1,
          ),
        ),
        child: const Text(
          'Edit Profil',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF36563C),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.username,
    required this.email,
  });

  final String username;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: DashboardScreen.green,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: DashboardScreen.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoField(
            title: 'Username:',
            value: username,
          ),
          const SizedBox(height: 18),
          _InfoField(
            title: 'Gmail:',
            value: email,
          ),
          const SizedBox(height: 18),
          const _InfoField(
            title: 'Password:',
            value: '********',
            showLine: false,
          ),
        ],
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({
    required this.title,
    required this.value,
    this.showLine = true,
  });

  final String title;
  final String value;
  final bool showLine;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF36563C),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: DashboardScreen.dark,
          ),
        ),
        if (showLine) ...[
          const SizedBox(height: 8),
          Container(
            width: 240,
            height: 1.2,
            color: const Color(0xFF4D6B50),
          ),
        ],
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.text,
    required this.textColor,
    required this.borderColor,
    required this.onTap,
  });

  final String text;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    );
  }
}