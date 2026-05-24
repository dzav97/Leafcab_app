import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

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

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  OutlineInputBorder _fieldBorder(double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: fieldBorder, width: width),
    );
  }

  RoundedRectangleBorder _buttonShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
      side: const BorderSide(color: buttonBorder, width: 1),
    );
  }

  Future<void> _register() async {
    if (_usernameC.text.trim().isEmpty ||
        _emailC.text.trim().isEmpty ||
        _passwordC.text.trim().isEmpty) {
      _showSnack('Semua field wajib diisi.');
      return;
    }

    setState(() => _loading = true);

    final pesan = await _auth.daftar(
      username: _usernameC.text,
      email: _emailC.text,
      password: _passwordC.text,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (pesan == null) {
      _showSnack('Pendaftaran berhasil. Silakan masuk.');
      Navigator.pop(context);
    } else {
      _showSnack(pesan);
    }
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
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Daftar',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: dark,
                                ),
                              ),
                              const SizedBox(height: 38),
                              _buildTextField(
                                controller: _usernameC,
                                hint: 'Username',
                                icon: Icons.account_circle,
                              ),
                              const SizedBox(height: 18),
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
                                  onPressed: () => setState(() => _obscure = !_obscure),
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
                                            : () => Navigator.pop(context),
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
                                  const SizedBox(width: 16),
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
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
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
          enabledBorder: _fieldBorder(1),
          focusedBorder: _fieldBorder(1.1),
        ),
      ),
    );
  }
}