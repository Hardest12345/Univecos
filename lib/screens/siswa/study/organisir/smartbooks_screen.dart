// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// class SmartbooksScreen extends StatefulWidget {
//   const SmartbooksScreen({super.key});

//   @override
//   State<SmartbooksScreen> createState() => _SmartbooksScreenState();
// }

// class _SmartbooksScreenState extends State<SmartbooksScreen> {
//   final supabase = Supabase.instance.client;

//   List<String> pdfFiles = [];
//   bool isLoading = true;

//   int currentPdfIndex = 0;
//   late PdfViewerController _pdfViewerController;
//   String selectedPdfUrl = "";

//   @override
//   void initState() {
//     super.initState();
//     _pdfViewerController = PdfViewerController();
//     _loadPdfs();
//   }

//   Future<void> _loadPdfs() async {
//     try {
//       final files = await supabase.storage
//           .from("univecos")
//           .list(path: "smartbooks/");

//       final list = files
//           .map((f) => f.name)
//           .where((f) => f.endsWith(".pdf"))
//           .toList();

//       setState(() {
//         pdfFiles = list;
//         isLoading = false;
//       });

//       if (list.isNotEmpty) {
//         _loadPdfAt(0);
//       }
//     } catch (e) {
//       setState(() => isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Gagal memuat SmartBooks: $e")),
//       );
//     }
//   }

//   void _loadPdfAt(int index) {
//     final url = supabase.storage
//         .from("univecos")
//         .getPublicUrl("smartbooks/${pdfFiles[index]}");

//     setState(() {
//       currentPdfIndex = index;
//       selectedPdfUrl = url;
//       _pdfViewerController = PdfViewerController(); // reset controller
//     });
//   }

//   void _nextPdf() {
//     if (currentPdfIndex < pdfFiles.length - 1) {
//       _loadPdfAt(currentPdfIndex + 1);
//     }
//   }

//   void _prevPdf() {
//     if (currentPdfIndex > 0) {
//       _loadPdfAt(currentPdfIndex - 1);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("SmartBooks")),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : pdfFiles.isEmpty
//               ? const Center(child: Text("Tidak ada SmartBook tersedia"))
//               : Column(
//                   children: [
//                     // PDF Preview
//                     Expanded(
//                       child: selectedPdfUrl.isEmpty
//                           ? const Center(child: Text("Pilih SmartBook"))
//                           : SfPdfViewer.network(
//                               selectedPdfUrl,
//                               controller: _pdfViewerController,
//                               enableDoubleTapZooming: true,
//                             ),
//                     ),

//                     // Navigasi Prev/Next
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.arrow_back),
//                           onPressed: currentPdfIndex > 0 ? _prevPdf : null,
//                         ),
//                         Text(
//                           "${currentPdfIndex + 1} / ${pdfFiles.length}",
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.arrow_forward),
//                           onPressed: currentPdfIndex < pdfFiles.length - 1
//                               ? _nextPdf
//                               : null,
//                         ),
//                       ],
//                     ),

//                     const Divider(),

//                     // Daftar PDF
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: pdfFiles.length,
//                         itemBuilder: (context, index) {
//                           final file = pdfFiles[index];
//                           return ListTile(
//                             selected: index == currentPdfIndex,
//                             leading: const Icon(Icons.picture_as_pdf),
//                             title: Text(file),
//                             onTap: () => _loadPdfAt(index),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SmartbooksScreen extends StatefulWidget {
  const SmartbooksScreen({super.key});

  @override
  State<SmartbooksScreen> createState() => _SmartbooksScreenState();
}

class _SmartbooksScreenState extends State<SmartbooksScreen> {
  final supabase = Supabase.instance.client;

  List<String> pdfFiles = [];
  bool isLoading = true;

  int currentPdfIndex = 0;
  late PdfViewerController _pdfViewerController;
  String selectedPdfUrl = "";

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
    _loadPdfs();
  }

  Future<void> _loadPdfs() async {
    try {
      final files = await supabase.storage
          .from("univecos")
          .list(path: "smartbooks/");

      final list =
          files.map((f) => f.name).where((f) => f.endsWith(".pdf")).toList();

      setState(() {
        pdfFiles = list;
        isLoading = false;
      });

      if (list.isNotEmpty) {
        _loadPdfAt(0);
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memuat E-Books: $e")));
    }
  }

  void _loadPdfAt(int index) {
    final url = supabase.storage
        .from("univecos")
        .getPublicUrl("smartbooks/${pdfFiles[index]}");

    setState(() {
      currentPdfIndex = index;
      selectedPdfUrl = url;
      _pdfViewerController = PdfViewerController(); // reset controller
    });
  }

  void _nextPdf() {
    if (currentPdfIndex < pdfFiles.length - 1) {
      _loadPdfAt(currentPdfIndex + 1);
    }
  }

  void _prevPdf() {
    if (currentPdfIndex > 0) {
      _loadPdfAt(currentPdfIndex - 1);
    }
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
        child: SafeArea(
          child: Column(
            children: [
              // Header dengan tombol back
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        "E-Books",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              isLoading
                  ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                  : pdfFiles.isEmpty
                  ? Expanded(
                    child: Center(
                      child: Text(
                        "Tidak ada E-Book tersedia",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  )
                  : Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: Column(
                        children: [
                          // PDF Viewer Section
                          Expanded(
                            flex: 3,
                            child:
                                selectedPdfUrl.isEmpty
                                    ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.menu_book,
                                            size: 48,
                                            color: Color(0xFF00707E),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            "Pilih E-Book untuk dibaca",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    : Container(
                                      margin: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: SfPdfViewer.network(
                                          selectedPdfUrl,
                                          controller: _pdfViewerController,
                                          enableDoubleTapZooming: true,
                                        ),
                                      ),
                                    ),
                          ),

                          // Navigation Controls
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Color(0xFF00707E),
                                  ),
                                  onPressed:
                                      currentPdfIndex > 0 ? _prevPdf : null,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00707E),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "${currentPdfIndex + 1} / ${pdfFiles.length}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xFF00707E),
                                  ),
                                  onPressed:
                                      currentPdfIndex < pdfFiles.length - 1
                                          ? _nextPdf
                                          : null,
                                ),
                              ],
                            ),
                          ),

                          // PDF List Section
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      "Daftar E-Books",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(
                                          255,
                                          255,
                                          255,
                                          255,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      itemCount: pdfFiles.length,
                                      itemBuilder: (context, index) {
                                        final file = pdfFiles[index];
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                index == currentPdfIndex
                                                    ? const Color(
                                                      0xFF00707E,
                                                    ).withOpacity(0.1)
                                                    : Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color:
                                                  index == currentPdfIndex
                                                      ? const Color(0xFF00707E)
                                                      : Colors.grey.shade300,
                                              width: 3,
                                            ),
                                            boxShadow:
                                                index == currentPdfIndex
                                                    ? [
                                                      BoxShadow(
                                                        color: const Color(
                                                          0xFF00707E,
                                                        ).withOpacity(0.2),
                                                        blurRadius: 2,
                                                        offset: const Offset(
                                                          0,
                                                          2,
                                                        ),
                                                      ),
                                                    ]
                                                    : [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.1),
                                                        blurRadius: 2,
                                                        offset: const Offset(
                                                          0,
                                                          1,
                                                        ),
                                                      ),
                                                    ],
                                          ),
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.menu_book,
                                              color: Color(0xFF00707E),
                                            ),
                                            title: Text(
                                              file,
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight:
                                                    index == currentPdfIndex
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                              ),
                                            ),
                                            trailing:
                                                index == currentPdfIndex
                                                    ? Icon(
                                                      Icons.check_circle,
                                                      color: Color(0xFF00707E),
                                                    )
                                                    : null,
                                            onTap: () => _loadPdfAt(index),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
