import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';
import 'edit_akun_screen.dart';

class AkunScreen extends StatefulWidget {
  const AkunScreen({super.key});

  @override
  State<AkunScreen> createState() => _AkunScreenState();
}

class _AkunScreenState extends State<AkunScreen> {
  final _auth = AuthService();

  static const Color dark = Color(0xFF163225);
  static const Color green = Color(0xFFB1D8B7);
  static const Color white = Colors.white;

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
    final User? user = FirebaseAuth.instance.currentUser;
    final username = user?.displayName?.isNotEmpty == true
        ? user!.displayName!
        : 'Belum diatur';
    final email = user?.email ?? 'Belum diatur';

    return Scaffold(
      backgroundColor: green,
      body: SafeArea(
        child: Stack(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 24, top: 16),
              child: Text(
                "Akun",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: dark,
                  height: 1.05,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 78),
              child: Container(
                decoration: const BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(26),
                  ),
                ),
                child: Column(
                  children: [
                    _buildTopBanner(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                        child: Column(
                          children: [
                            Container(
                              width: 82,
                              height: 82,
                              decoration: BoxDecoration(
                                color: green,
                                shape: BoxShape.circle,
                                border: Border.all(color: dark.withOpacity(0.5)),
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 44,
                                color: dark,
                              ),
                            ),
                            const SizedBox(height: 14),
                            OutlinedButton(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const EditAkunScreen(),
                                  ),
                                );
                                setState(() {});
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: dark,
                                side: const BorderSide(color: dark, width: 0.8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Text('Edit Profil'),
                            ),
                            const SizedBox(height: 18),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: green,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: dark.withOpacity(0.4)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _infoRow('Username', username),
                                  const SizedBox(height: 12),
                                  _infoRow('Email', email),
                                  const SizedBox(height: 12),
                                  _infoRow('Password', '••••••••'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: _logout,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: dark,
                                      side: const BorderSide(color: dark, width: 0.8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                    child: const Text('Logout'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: _hapusAkunDialog,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      side: const BorderSide(color: Colors.red, width: 0.8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                    child: const Text('Hapus Akun'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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

  Widget _buildTopBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        decoration: BoxDecoration(
          color: green,
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Akun',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: dark,
              ),
            ),
            Icon(Icons.info_outline, color: dark),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: dark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: dark),
        ),
      ],
    );
  }
}