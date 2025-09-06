import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  Future<void> registerSiswa({
    required String name,
    required String school,
    required String email,
    required String kelas,
    required String team,
    required String password,
  }) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) throw Exception("Gagal registrasi siswa");

    await supabase.from('profiles').insert({
      'id': user.id,
      'role': 'siswa',
      'name': name,
      'school': school,
      'email': email,
      'class': kelas,
      'team': team,
    });
  }

  Future<void> registerGuru({
    required String name,
    required String school,
    required String email,
    required String kelas,
    required String password,
  }) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) throw Exception("Gagal registrasi guru");

    await supabase.from('profiles').insert({
      'id': user.id,
      'role': 'guru',
      'name': name,
      'school': school,
      'email': email,
      'class': kelas,
    });
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) throw Exception("Login gagal, cek email/password");
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }
}
