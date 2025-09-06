import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/home/home_siswa.dart';
import '../screens/home/home_guru.dart';
import '../screens/home/home_admin.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_guru_screen.dart';
import '../screens/auth/register_siswa_screen.dart';

class AppRoutes {
  static String login = '/login';
  static String register = '/register';
  static String homeSiswa = '/home-siswa';
  static String homeGuru = '/home-guru';
  static String homeAdmin = '/home-admin';

  static GoRouter router = GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(
        path: login,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => RegisterGuruScreen(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => RegisterSiswaScreen(),
      ),
      GoRoute(
        path: homeSiswa,
        builder: (context, state) => HomeSiswa(),
      ),
      GoRoute(
        path: homeSiswa,
        builder: (context, state) => HomeSiswa(),
      ),
      GoRoute(
        path: homeGuru,
        builder: (context, state) => HomeGuru(),
      ),
      GoRoute(
        path: homeAdmin,
        builder: (context, state) => HomeAdmin(),
      ),
    ],
  );
}
