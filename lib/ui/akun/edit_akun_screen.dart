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
        bottom: false,
        child: Column(
          children: [
            _Header(onBack: () => Navigator.pop(context)),
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF3F3F3),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 34, 24, 32),
                  child: Column(
                    children: [
                      const _AvatarSection(),
                      const SizedBox(height: 28),
                      _FormCard(
                        children: [
                          _InputField(
                            controller: _usernameC,
                            label: 'Username',
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 16),
                          _InputField(
                            controller: _emailC,
                            label: 'Gmail',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 16),
                          _InputField(
                            controller: _currentPasswordC,
                            label: 'Password saat ini',
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
                          const SizedBox(height: 16),
                          _InputField(
                            controller: _newPasswordC,
                            label: 'Password baru',
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
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Expanded(
                            child: _ActionButton(
                              text: 'Batal',
                              textColor: DashboardScreen.dark,
                              backgroundColor: const Color(0xFFF7F7F7),
                              onTap: _loading
                                  ? null
                                  : () => Navigator.pop(context),
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: _ActionButton(
                              text: 'Simpan',
                              textColor: DashboardScreen.dark,
                              backgroundColor: DashboardScreen.green,
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
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: const Icon(
              Icons.arrow_back,
              size: 34,
              color: DashboardScreen.dark,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Edit Profil',
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

class _AvatarSection extends StatelessWidget {
  const _AvatarSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 104,
          height: 104,
          decoration: BoxDecoration(
            color: DashboardScreen.green,
            shape: BoxShape.circle,
            border: Border.all(
              color: DashboardScreen.border,
              width: 1,
            ),
          ),
          child: const Icon(
            Icons.person_outline,
            size: 50,
            color: DashboardScreen.dark,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 18),
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
      ],
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
        color: DashboardScreen.green,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: DashboardScreen.border,
          width: 1,
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
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: DashboardScreen.border,
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        style: const TextStyle(
          fontSize: 14,
          color: DashboardScreen.dark,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF36563C),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          border: InputBorder.none,
          suffixIcon: suffixIcon,
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
    required this.onTap,
    this.loading = false,
  });

  final String text;
  final Color textColor;
  final Color backgroundColor;
  final VoidCallback? onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: DashboardScreen.border,
            width: 1,
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
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