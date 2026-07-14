import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameC = TextEditingController();
  final _emailC = TextEditingController();
  final _passwordC = TextEditingController();
  final _auth = AuthService();

  bool _obscure = true;
  bool _loading = false;

  static const Color bgGreen = Color(0xFFF1F1F1);
  static const Color softGreen = Color(0xFFA9CFAB);
  static const Color dark = Color(0xFF355A3C);
  static const Color cardColor = Color(0xFFF1F1F1);
  static const Color fieldBorder = Color(0xFF8E8E8E);
  static const Color hintColor = Color(0xFF667066);
  static const Color buttonBorder = Color(0xFF1E2A1F);

  OutlineInputBorder _fieldBorderStyle(double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: fieldBorder, width: width),
    );
  }

  RoundedRectangleBorder _buttonShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
      side: const BorderSide(color: buttonBorder, width: 1),
    );
  }

  Future<void> _showMessageDialog({
    required String title,
    required String message,
    required bool isSuccess,
  }) async {
    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: Row(
          children: [
            Icon(
              isSuccess
                  ? Icons.check_circle_outline_rounded
                  : Icons.error_outline_rounded,
              color: isSuccess ? dark : Colors.red,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: dark,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: dark,
            fontSize: 14,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'OK',
              style: TextStyle(
                color: dark,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();

    final username = _usernameC.text.trim();
    final email = _emailC.text.trim();
    final password = _passwordC.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      await _showMessageDialog(
        title: 'Gagal',
        message: 'Semua field wajib diisi.',
        isSuccess: false,
      );
      return;
    }

    if (_loading) return;

    setState(() => _loading = true);

    final pesan = await _auth.daftar(
      username: username,
      email: email,
      password: password,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (pesan != null && pesan.toLowerCase().contains('berhasil')) {
      await _showMessageDialog(
        title: 'Verifikasi Email',
        message:
            'Akun berhasil dibuat. Link verifikasi telah dikirim ke email anda. Silakan cek Gmail dan lakukan verifikasi sebelum login.',
        isSuccess: true,
      );

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );

      return;
    }

    await _showMessageDialog(
      title: 'Gagal',
      message: pesan ?? 'Gagal mendaftar. Silakan coba lagi.',
      isSuccess: false,
    );
  }

  @override
  void dispose() {
    _usernameC.dispose();
    _emailC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreen,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
            ),
            child: Column(
              children: [
                const SizedBox(height: 58),
                _buildLogo(),
                const SizedBox(height: 58),
                _buildRegisterPanel(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterPanel() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: softGreen,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.fromLTRB(24, 30, 24, 34),
        decoration: const BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            const Text(
              'Daftar',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: dark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Buat akun LeafCab terlebih dahulu',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: dark.withValues(alpha: 0.72),
              ),
            ),
            const SizedBox(height: 30),
            _buildTextField(
              controller: _usernameC,
              hint: 'Username',
              icon: Icons.account_circle_outlined,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _emailC,
              hint: 'Email',
              icon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _passwordC,
              hint: 'Password',
              icon: Icons.lock_outline_rounded,
              obscure: _obscure,
              textInputAction: TextInputAction.done,
              suffix: IconButton(
                onPressed: () {
                  setState(() => _obscure = !_obscure);
                },
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.black54,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: _loading
                          ? null
                          : () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                                (_) => false,
                              );
                            },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: dark,
                        backgroundColor: cardColor,
                        side: const BorderSide(
                          color: buttonBorder,
                          width: 1,
                        ),
                        shape: _buttonShape(),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: softGreen,
                        foregroundColor: dark,
                        elevation: 0,
                        shape: _buttonShape(),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Daftar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _loading
                  ? null
                  : () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                        (_) => false,
                      );
                    },
              child: Text(
                'Sudah punya akun? Masuk',
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: dark.withValues(alpha: 0.75),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        SizedBox(
          width: 122,
          height: 122,
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const Icon(
              Icons.local_florist,
              size: 64,
              color: dark,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Leafcab',
          style: TextStyle(
            fontSize: 29,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
            color: dark.withValues(alpha: 0.95),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
  }) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        style: const TextStyle(
          fontSize: 14,
          color: dark,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: hintColor,
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.black87,
            size: 24,
          ),
          suffixIcon: suffix,
          filled: true,
          fillColor: cardColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          enabledBorder: _fieldBorderStyle(1),
          focusedBorder: _fieldBorderStyle(1.2),
        ),
      ),
    );
  }
}