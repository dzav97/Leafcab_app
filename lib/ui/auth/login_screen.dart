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

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  OutlineInputBorder _border([double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: fieldBorder, width: width),
    );
  }

  Future<void> _login() async {
    if (_emailC.text.trim().isEmpty || _passwordC.text.trim().isEmpty) {
      _showSnack('Email dan password wajib diisi.');
      return;
    }

    setState(() => _loading = true);

    final pesan = await _auth.masuk(
      email: _emailC.text,
      password: _passwordC.text,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (pesan == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      _showSnack(pesan);
    }
  }

  Future<void> _showForgotPasswordDialog() async {
    final emailResetC = TextEditingController(text: _emailC.text.trim());
    bool loadingReset = false;

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (_, setStateDialog) => AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Lupa Password',
            style: TextStyle(color: dark, fontWeight: FontWeight.w700),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Masukkan email Anda. Link reset password akan dikirim ke email tersebut.',
                style: TextStyle(color: dark, fontSize: 13),
              ),
              const SizedBox(height: 14),
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
                  enabledBorder: _border(),
                  focusedBorder: _border(1.1),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: loadingReset ? null : () => Navigator.pop(dialogContext),
              child: const Text('Batal', style: TextStyle(color: dark)),
            ),
            ElevatedButton(
              onPressed: loadingReset
                  ? null
                  : () async {
                      if (emailResetC.text.trim().isEmpty) {
                        _showSnack('Email wajib diisi.');
                        return;
                      }

                      setStateDialog(() => loadingReset = true);

                      final pesan = await _auth.lupaPassword(
                        email: emailResetC.text,
                      );

                      if (!mounted) return;

                      setStateDialog(() => loadingReset = false);
                      Navigator.pop(dialogContext);
                      _showSnack(pesan ?? 'Berhasil.');
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: softGreen,
                foregroundColor: dark,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: dark, width: 1),
                ),
              ),
              child: loadingReset
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Kirim'),
            ),
          ],
        ),
      ),
    );

    emailResetC.dispose();
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
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: const BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 52),
                      _buildLogo(),
                      const SizedBox(height: 145),
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: softGreen,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(26),
                            topRight: Radius.circular(26),
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(top: 60),
                          padding: const EdgeInsets.fromLTRB(24, 34, 24, 30),
                          decoration: const BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(26),
                              topRight: Radius.circular(26),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Masuk',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: dark,
                                ),
                              ),
                              const SizedBox(height: 38),
                              _buildTextField(
                                controller: _emailC,
                                hint: 'Email',
                                icon: Icons.mail_outline,
                              ),
                              const SizedBox(height: 18),
                              _buildTextField(
                                controller: _passwordC,
                                hint: 'Password',
                                icon: Icons.lock,
                                obscure: _obscure,
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
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      color: dark.withOpacity(0.78),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _loading ? null : _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: softGreen,
                                    foregroundColor: dark,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                      side: const BorderSide(
                                        color: Color(0xFF1E2A1F),
                                        width: 1,
                                      ),
                                    ),
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
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const RegisterScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Belum punya akun? Klik untuk daftar',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    color: dark.withOpacity(0.75),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        SizedBox(
          width: 128,
          height: 128,
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
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
            fontSize: 28,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w400,
            color: dark.withOpacity(0.95),
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
  }) {
    return SizedBox(
      height: 46,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(
          fontSize: 14,
          color: dark,
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
          enabledBorder: _border(),
          focusedBorder: _border(1.1),
        ),
      ),
    );
  }
}