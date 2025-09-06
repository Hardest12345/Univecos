// import 'package:flutter/material.dart';
// import '../../services/auth_service.dart';

// class RegisterSiswaScreen extends StatefulWidget {
//   @override
//   _RegisterSiswaScreenState createState() => _RegisterSiswaScreenState();
// }

// class _RegisterSiswaScreenState extends State<RegisterSiswaScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _authService = AuthService();

//   String name = "",
//       school = "",
//       email = "",
//       studentClass = "",
//       team = "",
//       password = "";

//   bool isLoading = false;

//   Future<void> _register() async {
//     if (!_formKey.currentState!.validate()) return;
//     _formKey.currentState!.save();

//     setState(() => isLoading = true);
//     try {
//       await _authService.registerSiswa(
//         name: name,
//         school: school,
//         email: email,
//         kelas: studentClass,
//         team: team,
//         password: password,
//       );
//       Navigator.pushReplacementNamed(context, '/login');
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: $e")));
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Registrasi Siswa")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 decoration: InputDecoration(labelText: "Nama"),
//                 validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
//                 onSaved: (v) => name = v!,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: "Sekolah"),
//                 validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
//                 onSaved: (v) => school = v!,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: "Email"),
//                 validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
//                 onSaved: (v) => email = v!,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: "Kelas"),
//                 onSaved: (v) => studentClass = v!,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: "Team"),
//                 validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
//                 onSaved: (v) => team = v!,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: "Password"),
//                 obscureText: true,
//                 validator: (v) => v!.length < 6 ? "Minimal 6 karakter" : null,
//                 onSaved: (v) => password = v!,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: isLoading ? null : _register,
//                 child: isLoading ? CircularProgressIndicator() : Text("Daftar"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class RegisterSiswaScreen extends StatefulWidget {
  @override
  _RegisterSiswaScreenState createState() => _RegisterSiswaScreenState();
}

class _RegisterSiswaScreenState extends State<RegisterSiswaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  String name = "",
      school = "",
      email = "",
      studentClass = "",
      team = "",
      password = "";

  bool isLoading = false;
  String? _error;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      isLoading = true;
      _error = null;
    });

    try {
      await _authService.registerSiswa(
        name: name,
        school: school,
        email: email,
        kelas: studentClass,
        team: team,
        password: password,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registrasi berhasil! Silakan login."))
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00707E), Color(0xFFA9F67F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo dan judul
                const SizedBox(height: 20),
                const Text(
                  'Register Siswa',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                Image.asset("assets/images/logo_univecos.png", height: 120),
                const SizedBox(height: 30),

                // Form registrasi
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Nama Lengkap",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          style: const TextStyle(fontSize: 16),
                          validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
                          onSaved: (v) => name = v!,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Sekolah",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          style: const TextStyle(fontSize: 16),
                          validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
                          onSaved: (v) => school = v!,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          style: const TextStyle(fontSize: 16),
                          validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
                          onSaved: (v) => email = v!,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Kelas",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          style: const TextStyle(fontSize: 16),
                          onSaved: (v) => studentClass = v!,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Team",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          style: const TextStyle(fontSize: 16),
                          validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
                          onSaved: (v) => team = v!,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          obscureText: true,
                          style: const TextStyle(fontSize: 16),
                          validator: (v) => v!.length < 6 ? "Minimal 6 karakter" : null,
                          onSaved: (v) => password = v!,
                          onFieldSubmitted: (_) => _register(),
                        ),
                        const SizedBox(height: 16),

                        if (_error != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              _error!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00707E),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: const Text(
                            "Daftar",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: _goToLogin,
                  child: const Text(
                    "Sudah punya akun? Login di sini",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}