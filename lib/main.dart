import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// import semua screen yang dipakai
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_siswa_screen.dart';
import 'screens/auth/register_guru_screen.dart';
import 'screens/home/home_siswa.dart';
import 'screens/home/home_guru.dart';
import 'screens/home/home_admin.dart';
import 'services/role_guard.dart';
import 'screens/siswa/achievement_screen.dart';
import 'screens/siswa/chat_siswa.dart';
import 'screens/siswa/test/practice_screen.dart';
import 'screens/siswa/study/capaian_screen.dart';
import 'screens/siswa/study/orientasi_screen.dart';
// import 'screens/siswa/study/ekosistem_detail.dart';
import 'screens/siswa/study/study_menu_screen.dart';
import 'screens/siswa/study/orientasi/keanekaragaman_screen.dart';
import 'screens/siswa/study/orientasi/makhluk_screen.dart';
// import 'screens/siswa/study/pdf_list_screen.dart';
import 'screens/siswa/study/organizer_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url:
        'https://ufcgorebxwhuwtgkggjf.supabase.co', // ganti dengan project Supabase kamu
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVmY2dvcmVieHdodXd0Z2tnZ2pmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU3NjgwNzUsImV4cCI6MjA3MTM0NDA3NX0.S1TXbD3PDTdpJKgs5cyvnc7vxInfTUzc7ZzIpwajWjE',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Univecos',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register_siswa': (_) => RegisterSiswaScreen(),
        '/register_guru': (_) => const RegisterGuruScreen(),
        '/home_siswa': (_) => const HomeSiswa(),
        '/home_guru': (_) => const HomeGuru(),
        '/home_admin': (_) => const HomeAdmin(),
        '/role_guard': (_) => const RoleGuard(), // ⬅️ route untuk guard
        "/achievement": (context) => const MyAchievementScreen(),
        // "/study": (context) => const StudyScreen(),
        // "/chat": (context) => const ChatSiswaScreen(),
        "/practice": (context) => const StudentTestMenu(),
        "/capaian": (context) => const CapaianScreen(),
        "/orientasi": (context) => const OrientasiScreen(),
        // "/ekosistem_detail": (context) => EkosistemDetailScreen(),
        "/study_menu": (context) => const StudyMenuScreen(),
        // "/keanekaragaman": (context) => const KeanekaragamanScreen(),
        // "/makhluk": (context) => const MakhlukScreen(),
        // "/pdf_list": (context) => const PdfListScreen(),
        // "/chat_siswa": (context) => const ChatSiswa(),
        "/organizer": (context) => const OrganizerScreen(),
      },
    );
  }
}
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       debugShowCheckedModeBanner: false,
//       routerConfig: AppRoutes.router,
//       theme: AppTheme.lightTheme,
//     );
//   }
// }
