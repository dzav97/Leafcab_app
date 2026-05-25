import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../auth/login_screen.dart';
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
  bool _obscureCurrent = true;
  bool _obscureNew = true;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _usernameC = TextEditingController(text: user?.displayName ?? '');
    _emailC = TextEditingController(text: user?.email ?? '');
  }

  Future<void> _simpan() async {
    FocusScope.of(context).unfocus();

    if (_loading) return;

    setState(() => _loading = true);

    final user = FirebaseAuth.instance.currentUser;
    final emailLama = user?.email ?? '';
    final emailBaru = _emailC.text.trim();

    final emailBerubah = emailBaru.isNotEmpty && emailBaru != emailLama;

    final pesan = await _auth.updateAkun(
      username: _usernameC.text.trim(),
      email: emailBaru,
      currentPassword: _currentPasswordC.text,
      newPassword: _newPasswordC.text,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (pesan != null) {
      await _showMessageDialog(
        title: 'Gagal',
        message: pesan,
        isSuccess: false,
      );
      return;
    }

    if (emailBerubah) {
      await _showMessageDialog(
        title: 'Verifikasi Email',
        message:
            'Link verifikasi telah dikirim ke email baru kamu. Silakan cek Gmail dan lakukan verifikasi. Setelah itu, login kembali.',
        isSuccess: true,
      );

      if (!mounted) return;

      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );

      return;
    }

    await _showMessageDialog(
      title: 'Berhasil',
      message: 'Profil berhasil diperbarui.',
      isSuccess: true,
    );

    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> _showMessageDialog({
    required String title,
    required String message,
    required bool isSuccess,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: Row(
          children: [
            Icon(
              isSuccess
                  ? Icons.check_circle_outline_rounded
                  : Icons.error_outline_rounded,
              color: isSuccess ? DashboardScreen.dark : Colors.red,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'OK',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: DashboardScreen.dark,
              ),
            ),
          ),
        ],
      ),
    );
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
        bottom: false,
        child: Column(
          children: [
            _Header(onBack: () => Navigator.pop(context)),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F6F3),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 34, 24, 120),
                  child: Column(
                    children: [
                      const _AvatarSection(),
                      const SizedBox(height: 24),
                      _FormCard(
                        children: [
                          _InputField(
                            controller: _usernameC,
                            label: 'Username',
                            icon: Icons.person_outline_rounded,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 14),
                          _InputField(
                            controller: _emailC,
                            label: 'Gmail',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 14),
                          _InputField(
                            controller: _currentPasswordC,
                            label: 'Password saat ini',
                            icon: Icons.lock_outline_rounded,
                            obscureText: _obscureCurrent,
                            textInputAction: TextInputAction.next,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureCurrent = !_obscureCurrent;
                                });
                              },
                              icon: Icon(
                                _obscureCurrent
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: DashboardScreen.dark,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          _InputField(
                            controller: _newPasswordC,
                            label: 'Password baru',
                            icon: Icons.lock_reset_rounded,
                            obscureText: _obscureNew,
                            textInputAction: TextInputAction.done,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureNew = !_obscureNew;
                                });
                              },
                              icon: Icon(
                                _obscureNew
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: DashboardScreen.dark,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _ActionButton(
                              text: 'Batal',
                              textColor: DashboardScreen.dark,
                              backgroundColor: Colors.white,
                              borderColor: DashboardScreen.border,
                              onTap: _loading
                                  ? null
                                  : () => Navigator.pop(context),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _ActionButton(
                              text: 'Simpan',
                              textColor: DashboardScreen.dark,
                              backgroundColor: DashboardScreen.green,
                              borderColor: DashboardScreen.border,
                              onTap: _loading ? null : _simpan,
                              loading: _loading,
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
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: DashboardScreen.green,
      padding: const EdgeInsets.fromLTRB(12, 12, 24, 18),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: DashboardScreen.dark,
              size: 28,
            ),
          ),
          const SizedBox(width: 4),
          const Expanded(
            child: Text(
              'Edit Akun',
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

class _AvatarSection extends StatelessWidget {
  const _AvatarSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
      decoration: BoxDecoration(
        color: DashboardScreen.green,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: DashboardScreen.border,
          width: 1.2,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 108,
            height: 108,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.55),
              shape: BoxShape.circle,
              border: Border.all(
                color: DashboardScreen.border,
                width: 1.2,
              ),
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 60,
              color: DashboardScreen.dark,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Perbarui Profil',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: DashboardScreen.dark,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Ubah username, email, atau password akun kamu.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4E6A52),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: DashboardScreen.border,
          width: 1.2,
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: const TextStyle(
        fontSize: 14,
        color: DashboardScreen.dark,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFF4E6A52),
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          color: DashboardScreen.dark,
          size: 21,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: DashboardScreen.border,
            width: 1.1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: DashboardScreen.dark,
            width: 1.3,
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.onTap,
    this.loading = false,
  });

  final String text;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback? onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: borderColor,
              width: 1.2,
            ),
          ),
          child: loading
              ? const SizedBox(
                  width: 19,
                  height: 19,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: DashboardScreen.dark,
                  ),
                )
              : Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
        ),
      ),
    );
  }
}