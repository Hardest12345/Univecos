import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/home/home_siswa.dart';
import '../screens/home/home_guru.dart';
import '../screens/home/home_admin.dart';

class RoleGuard extends StatelessWidget {
  const RoleGuard({super.key});

  Future<String?> _getRole() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return null;

    final res = await Supabase.instance.client
        .from('profiles')
        .select('role')
        .eq('id', user.id)
        .maybeSingle();

    return res?['role'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getRole(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        switch (snapshot.data) {
          case 'siswa':
            return const HomeSiswa();
          case 'guru':
            return const HomeGuru();
          case 'admin':
            return const HomeAdmin();
          default:
            return const Scaffold(
              body: Center(child: Text('Role tidak dikenali')),
            );
        }
      },
    );
  }
}
