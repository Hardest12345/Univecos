// // import 'package:flutter/material.dart';

// // class HomeAdmin extends StatelessWidget {
// //   const HomeAdmin({super.key});

// //   final List<Map<String, dynamic>> menu = const [
// //     {"title": "Upload Journals", "icon": Icons.book},
// //     {"title": "Upload Smartbooks", "icon": Icons.library_books},
// //     {"title": "Upload Templates", "icon": Icons.description},
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Home Admin"),
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.logout),
// //             onPressed: () {
// //               Navigator.pushReplacementNamed(context, "/login");
// //             },
// //           ),
// //         ],
// //       ),
// //       body: GridView.builder(
// //         padding: const EdgeInsets.all(16),
// //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //           crossAxisCount: 2,
// //           crossAxisSpacing: 16,
// //           mainAxisSpacing: 16,
// //         ),
// //         itemCount: menu.length,
// //         itemBuilder: (context, index) {
// //           return Card(
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(16),
// //             ),
// //             elevation: 3,
// //             child: InkWell(
// //               onTap: () {},
// //               borderRadius: BorderRadius.circular(16),
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Icon(menu[index]['icon'], size: 48, color: Colors.green),
// //                   const SizedBox(height: 12),
// //                   Text(
// //                     menu[index]['title'],
// //                     style: const TextStyle(fontSize: 16),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// // TODO: Update the import path below to the correct location of UploadContentScreen
// import '../admin/upload_content_screen.dart';

// class HomeAdmin extends StatelessWidget {
//   const HomeAdmin({super.key});

//   final List<Map<String, dynamic>> menu = const [
//     {"title": "Upload Journals", "icon": Icons.book},
//     {"title": "Upload Smartbooks", "icon": Icons.library_books},
//     {"title": "Upload Templates", "icon": Icons.description},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Home Admin"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               Navigator.pushReplacementNamed(context, "/login");
//             },
//           ),
//         ],
//       ),
//       body: GridView.builder(
//         padding: const EdgeInsets.all(16),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 16,
//           mainAxisSpacing: 16,
//         ),
//         itemCount: menu.length,
//         itemBuilder: (context, index) {
//           return Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             elevation: 3,
//             child: InkWell(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const UploadContentScreen()),
//                 );
//               },

//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../admin/upload_content_screen.dart';
import '../admin/upload_test_screen.dart'; // tambahkan import
import '../admin/admin_test_add_screen.dart'; // tambahkan import
import '../admin/admin_test_edit_screen.dart'; // tambahkan import
import '../admin/admin_test_list_screen.dart'; // tambahkan import

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  final List<Map<String, dynamic>> menu = const [
    {"title": "Upload Journals", "icon": Icons.book, "route": "journals"},
    {"title": "Upload Smartbooks", "icon": Icons.library_books, "route": "smartbooks"},
    {"title": "Upload Templates", "icon": Icons.description, "route": "templates"},
    {"title": "Upload Test", "icon": Icons.quiz, "route": "tests"}, // ✅ tambahkan
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Admin"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: menu.length,
        itemBuilder: (context, index) {
          final item = menu[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                switch (item['route']) {
                  case "tests":
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const UploadTestScreen()),
                    );
                    break;
                  default:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const UploadContentScreen()),
                    );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item['icon'] as IconData, size: 48, color: Colors.green),
                  const SizedBox(height: 12),
                  Text(
                    item['title'] as String,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
