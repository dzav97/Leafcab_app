import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../dashboard/dashboard_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      barrierDismissible: true,
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

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    final email = _emailC.text.trim();
    final password = _passwordC.text.trim();

    if (email.isEmpty || password.isEmpty) {
      await _showMessageDialog(
        title: 'Gagal',
        message: 'Email dan password wajib diisi.',
        isSuccess: false,
      );
      return;
    }

    if (_loading) return;

    setState(() => _loading = true);

    final pesan = await _auth.masuk(
      email: email,
      password: password,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (pesan == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      await _showMessageDialog(
        title: 'Gagal',
        message: pesan,
        isSuccess: false,
      );
    }
  }

  Future<void> _showForgotPasswordDialog() async {
    final emailResetC = TextEditingController(text: _emailC.text.trim());

    final emailReset = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text(
          'Lupa Password',
          style: TextStyle(
            color: dark,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Masukkan email anda. Link reset password akan dikirim ke email tersebut.',
              style: TextStyle(
                color: dark,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailResetC,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: hintColor,
                ),
                prefixIcon: const Icon(
                  Icons.mail_outline,
                  color: Colors.black87,
                ),
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
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Batal',
              style: TextStyle(
                color: dark,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext, emailResetC.text.trim());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: softGreen,
              foregroundColor: dark,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(
                  color: dark,
                  width: 1,
                ),
              ),
            ),
            child: const Text(
              'Kirim',
              style: TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );

    emailResetC.dispose();

    if (!mounted) return;

    if (emailReset == null) return;

    if (emailReset.isEmpty) {
      await _showMessageDialog(
        title: 'Gagal',
        message: 'Email wajib diisi.',
        isSuccess: false,
      );
      return;
    }

    await _kirimResetPassword(emailReset);
  }

  Future<void> _kirimResetPassword(String email) async {
    final pesan = await _auth.lupaPassword(
      email: email,
    );

    if (!mounted) return;

    await _showMessageDialog(
      title: pesan == null ? 'Berhasil' : 'Informasi',
      message: pesan ?? 'Link reset password berhasil dikirim ke email anda.',
      isSuccess: true,
    );
  }

  @override
  void dispose() {
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
                _buildLoginPanel(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginPanel() {
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
              'Masuk',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: dark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Masuk untuk menggunakan LeafCab',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: dark.withValues(alpha: 0.72),
              ),
            ),
            const SizedBox(height: 30),
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
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _loading ? null : _showForgotPasswordDialog,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Lupa Password?',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    color: dark.withValues(alpha: 0.78),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _loading ? null : _login,
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
                        'Masuk',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _loading
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
              child: Text(
                'Belum punya akun? Daftar',
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