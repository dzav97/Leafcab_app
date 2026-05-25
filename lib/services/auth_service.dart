import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  Future<String?> daftar({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = credential.user;
      if (user == null) {
        return 'Gagal membuat akun.';
      }

      if (username.trim().isNotEmpty) {
        await user.updateDisplayName(username.trim());
      }

      await user.sendEmailVerification();
      await _auth.signOut();

      return 'Akun berhasil dibuat. Link verifikasi telah dikirim ke email Anda.';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'Password terlalu lemah.';
      } else if (e.code == 'email-already-in-use') {
        return 'Email sudah terdaftar.';
      } else if (e.code == 'invalid-email') {
        return 'Format email tidak valid.';
      } else if (e.code == 'operation-not-allowed') {
        return 'Metode login email/password belum diaktifkan di Firebase.';
      }
      return e.message ?? 'Gagal mendaftar.';
    } catch (e) {
      return 'Terjadi kesalahan saat mendaftar: $e';
    }
  }

  Future<String?> kirimUlangVerifikasiEmail() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return 'User tidak ditemukan.';

      await user.reload();
      final refreshedUser = _auth.currentUser;

      if (refreshedUser == null) {
        return 'User tidak ditemukan.';
      }

      if (refreshedUser.emailVerified) {
        return 'Email sudah terverifikasi.';
      }

      await refreshedUser.sendEmailVerification();
      return 'Email verifikasi berhasil dikirim ulang.';
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Gagal mengirim ulang email verifikasi.';
    } catch (e) {
      return 'Terjadi kesalahan saat mengirim ulang verifikasi: $e';
    }
  }

  Future<String?> cekStatusVerifikasiEmail() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return 'User tidak ditemukan.';

      await user.reload();
      final refreshedUser = _auth.currentUser;

      if (refreshedUser == null) {
        return 'User tidak ditemukan.';
      }

      if (refreshedUser.emailVerified) {
        return 'Email sudah terverifikasi.';
      } else {
        return 'Email belum terverifikasi.';
      }
    } catch (e) {
      return 'Gagal memeriksa status verifikasi email: $e';
    }
  }

  Future<String?> masuk({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = credential.user;
      if (user == null) {
        return 'Gagal masuk.';
      }

      await user.reload();
      final refreshedUser = _auth.currentUser;

      if (refreshedUser == null) {
        return 'Gagal memuat data user.';
      }

      if (!refreshedUser.emailVerified) {
        await _auth.signOut();
        return 'Email belum diverifikasi. Silakan cek inbox Anda terlebih dahulu.';
      }

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' ||
          e.code == 'wrong-password' ||
          e.code == 'user-not-found') {
        return 'Email atau password salah.';
      } else if (e.code == 'invalid-email') {
        return 'Format email tidak valid.';
      } else if (e.code == 'too-many-requests') {
        return 'Terlalu banyak percobaan. Coba lagi nanti.';
      }
      return e.message ?? 'Gagal masuk.';
    } catch (e) {
      return 'Terjadi kesalahan saat masuk: $e';
    }
  }

  Future<String?> lupaPassword({
    required String email,
  }) async {
    try {
      final emailTrim = email.trim();

      if (emailTrim.isEmpty) {
        return 'Email wajib diisi.';
      }

      await _auth.sendPasswordResetEmail(email: emailTrim);
      return 'Link reset password telah dikirim ke email Anda.';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return 'Format email tidak valid.';
      } else if (e.code == 'user-not-found') {
        return 'Email tidak terdaftar.';
      } else if (e.code == 'too-many-requests') {
        return 'Terlalu banyak percobaan. Coba lagi nanti.';
      }
      return e.message ?? 'Gagal mengirim email reset password.';
    } catch (e) {
      return 'Terjadi kesalahan saat mengirim reset password: $e';
    }
  }

  Future<void> keluar() async {
    await _auth.signOut();
  }

  Future<String?> updateAkun({
    required String username,
    required String email,
    required String currentPassword,
    String? newPassword,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return 'User tidak ditemukan.';

      final oldEmail = user.email ?? '';
      if (oldEmail.isEmpty) {
        return 'Email user tidak ditemukan.';
      }

      final usernameBaru = username.trim();
      final emailBaru = email.trim();
      final passwordLama = currentPassword.trim();
      final passwordBaru = newPassword?.trim() ?? '';

      final usernameChanged =
          usernameBaru.isNotEmpty && usernameBaru != (user.displayName ?? '');

      final emailChanged =
          emailBaru.isNotEmpty && emailBaru != oldEmail.trim();

      final passwordChanged = passwordBaru.isNotEmpty;

      if (!usernameChanged && !emailChanged && !passwordChanged) {
        return 'Tidak ada perubahan data.';
      }

      if ((emailChanged || passwordChanged) && passwordLama.isEmpty) {
        return 'Masukkan password saat ini untuk mengubah email atau password.';
      }

      if (emailChanged || passwordChanged) {
        final credential = EmailAuthProvider.credential(
          email: oldEmail,
          password: passwordLama,
        );

        await user.reauthenticateWithCredential(credential);
      }

      if (emailChanged) {
        await user.verifyBeforeUpdateEmail(emailBaru);
      }

      if (passwordChanged) {
        await user.updatePassword(passwordBaru);
      }

      if (usernameChanged) {
        await user.updateDisplayName(usernameBaru);
      }

      await user.reload();

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return 'Silakan login ulang lalu coba lagi.';
      } else if (e.code == 'invalid-email') {
        return 'Format email tidak valid.';
      } else if (e.code == 'email-already-in-use') {
        return 'Email sudah digunakan akun lain.';
      } else if (e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        return 'Password saat ini salah.';
      } else if (e.code == 'weak-password') {
        return 'Password baru terlalu lemah.';
      } else if (e.code == 'too-many-requests') {
        return 'Terlalu banyak percobaan. Coba lagi nanti.';
      }

      return e.message ?? 'Gagal memperbarui akun.';
    } catch (e) {
      return 'Terjadi kesalahan saat memperbarui akun: $e';
    }
  }

  Future<String?> hapusAkun({
    required String currentPassword,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return 'User tidak ditemukan.';

      final email = user.email;
      if (email == null || email.isEmpty) {
        return 'Email user tidak ditemukan.';
      }

      final credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword.trim(),
      );

      await user.reauthenticateWithCredential(credential);
      await user.delete();

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        return 'Password salah.';
      } else if (e.code == 'requires-recent-login') {
        return 'Silakan login ulang lalu coba lagi.';
      } else if (e.code == 'too-many-requests') {
        return 'Terlalu banyak percobaan. Coba lagi nanti.';
      }
      return e.message ?? 'Gagal menghapus akun.';
    } catch (e) {
      return 'Terjadi kesalahan saat menghapus akun: $e';
    }
  }
}