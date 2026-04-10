import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../dashboard/dashboard_screen.dart';

class EditAkunScreen extends StatefulWidget {
  const EditAkunScreen({super.key});

  @override
  State<EditAkunScreen> createState() => _EditAkunScreenState();
}

class _EditAkunScreenState extends State<EditAkunScreen> {
  final _auth = AuthService();

  late final TextEditingController _usernameC;
  late final TextEditingController _emailC;
  final TextEditingController _currentPasswordC = TextEditingController();
  final TextEditingController _newPasswordC = TextEditingController();

  bool _loading = false;

  static const Color dark = Color(0xFF163225);
  static const Color green = Color(0xFFB1D8B7);
  static const Color white = Colors.white;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _usernameC = TextEditingController(text: user?.displayName ?? '');
    _emailC = TextEditingController(text: user?.email ?? '');
  }

  Future<void> _simpan() async {
    setState(() => _loading = true);

    final pesan = await _auth.updateAkun(
      username: _usernameC.text,
      email: _emailC.text,
      currentPassword: _currentPasswordC.text,
      newPassword: _newPasswordC.text,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (pesan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(pesan)),
      );
    }
  }

  @override
  void dispose() {
    _usernameC.dispose();
    _emailC.dispose();
    _currentPasswordC.dispose();
    _newPasswordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardScreen.green,
      body: SafeArea(
        child: Stack(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 24, top: 16),
              child: Text(
                "Edit Profil",
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
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
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: green,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: dark.withOpacity(0.4)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 72,
                                    height: 72,
                                    decoration: const BoxDecoration(
                                      color: white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      size: 42,
                                      color: dark,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  OutlinedButton(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: dark,
                                      backgroundColor: white,
                                      side: const BorderSide(color: dark, width: 0.7),
                                    ),
                                    child: const Text('Ubah Foto'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            _buildInputCard(
                              controller: _usernameC,
                              label: 'Username',
                            ),
                            const SizedBox(height: 14),
                            _buildInputCard(
                              controller: _emailC,
                              label: 'Email',
                            ),
                            const SizedBox(height: 14),
                            _buildInputCard(
                              controller: _currentPasswordC,
                              label: 'Password saat ini',
                              obscure: true,
                            ),
                            const SizedBox(height: 14),
                            _buildInputCard(
                              controller: _newPasswordC,
                              label: 'Password baru',
                              obscure: true,
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: dark,
                                      side: const BorderSide(color: dark, width: 0.8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                    child: const Text('Batal'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _loading ? null : _simpan,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: green,
                                      foregroundColor: dark,
                                      elevation: 0,
                                      side: const BorderSide(color: dark, width: 0.8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                    child: _loading
                                        ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : const Text('Simpan'),
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
        child: const Text(
          'Edit Profil',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: dark,
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard({
    required TextEditingController controller,
    required String label,
    bool obscure = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: green,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dark.withOpacity(0.35)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
      ),
    );
  }
}