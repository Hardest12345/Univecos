import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../services/file_service.dart';
import 'pdf_preview_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class UploadContentScreen extends StatefulWidget {
  const UploadContentScreen({super.key});

  @override
  State<UploadContentScreen> createState() => _UploadContentScreenState();
}

class _UploadContentScreenState extends State<UploadContentScreen>
    with SingleTickerProviderStateMixin {
  final _fileService = FileService();
  late TabController _tabController;

  // Journals
  final _journalTitleCtrl = TextEditingController();
  String _journalCategory = 'Ekosistem Hujan Tropis';
  bool _uploadingJournal = false;
  Uint8List? _selectedJournalFile;
  String? _selectedJournalName;

  // Smartbooks
  final _smartbookTitleCtrl = TextEditingController();
  bool _uploadingSmartbook = false;
  Uint8List? _selectedSmartbookFile;
  String? _selectedSmartbookName;

  // Templates
  bool _uploadingTemplate = false;
  Uint8List? _selectedTemplateFile;
  String? _selectedTemplateName;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> _pickPdf(Function(Uint8List, String) onPicked) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    if (result != null && result.files.single.bytes != null) {
      onPicked(result.files.single.bytes!, result.files.single.name);
    }
  }

  // ---- Upload actions ----
  Future<void> _uploadJournal() async {
    final title = _journalTitleCtrl.text.trim();
    if (title.isEmpty) {
      _snack('Judul jurnal wajib diisi');
      return;
    }
    if (_selectedJournalFile == null) {
      _snack('Pilih file PDF terlebih dahulu');
      return;
    }

    final safeTitle = title
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(' ', '_');
    final safeCategory = _journalCategory.replaceAll(' ', '_');
    final path = 'journals/$safeCategory/$safeTitle.pdf';

    setState(() => _uploadingJournal = true);
    try {
      await _fileService.uploadToBucket(
        bucket: 'univecos',
        path: path,
        bytes: _selectedJournalFile!,
      );

      // === Tambahkan insert metadata ke tabel pdf_files ===
      await _fileService.insertPdfMetadata(
        kategori: safeCategory,
        title: title,
        path: path,
      );

      _snack('Jurnal diupload & metadata tersimpan!');
      setState(() {
        _selectedJournalFile = null;
        _selectedJournalName = null;
      });
    } catch (e) {
      _snack('Gagal upload jurnal: $e');
    } finally {
      setState(() => _uploadingJournal = false);
    }
  }

  Future<void> _uploadSmartbook() async {
    final title = _smartbookTitleCtrl.text.trim();
    if (title.isEmpty) {
      _snack('Judul smartbook wajib diisi');
      return;
    }
    if (_selectedSmartbookFile == null) {
      _snack('Pilih file PDF terlebih dahulu');
      return;
    }

    final safeTitle = title
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(' ', '_');
    final path = 'smartbooks/$safeTitle.pdf';

    setState(() => _uploadingSmartbook = true);
    try {
      await _fileService.uploadToBucket(
        bucket: 'univecos',
        path: path,
        bytes: _selectedSmartbookFile!,
      );

      await _fileService.insertPdfMetadata(
        kategori: "smartbooks",
        title: title,
        path: path,
      );

      _snack('Smartbook diupload & metadata tersimpan!');
      setState(() {
        _selectedSmartbookFile = null;
        _selectedSmartbookName = null;
      });
    } catch (e) {
      _snack('Gagal upload smartbook: $e');
    } finally {
      setState(() => _uploadingSmartbook = false);
    }
  }

  Future<void> _uploadTemplate(String name) async {
    if (_selectedTemplateFile == null) {
      _snack('Pilih file PDF template terlebih dahulu');
      return;
    }

    final path = 'templates/$name.pdf';
    setState(() => _uploadingTemplate = true);
    try {
      await _fileService.uploadToBucket(
        bucket: 'univecos',
        path: path,
        bytes: _selectedTemplateFile!,
      );

      await _fileService.insertPdfMetadata(
        kategori: "templates",
        title: name,
        path: path,
      );

      _snack('Template $name diupload & metadata tersimpan!');
      setState(() {
        _selectedTemplateFile = null;
        _selectedTemplateName = null;
      });
    } catch (e) {
      _snack('Gagal upload template: $e');
    } finally {
      setState(() => _uploadingTemplate = false);
    }
  }

  void _openPreview(String bucket, String path, String title) {
    final url = _fileService.getPublicUrl(bucket: bucket, path: path);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfPreviewScreen(title: title, url: url),
      ),
    );
  }

  // ---- Lists ----
  Future<List<_FileRow>> _listJournals() async {
    final cats = await _fileService.listFiles(
      bucket: 'univecos',
      prefix: 'journals/',
    );
    final List<_FileRow> rows = [];
    for (final c in cats) {
      if (c.name.isEmpty) continue;
      final files = await _fileService.listFiles(
        bucket: 'univecos',
        prefix: 'journals/${c.name}/',
      );
      for (final f in files) {
        rows.add(
          _FileRow(
            path: 'journals/${c.name}/${f.name}',
            display: '${c.name}/${f.name}',
          ),
        );
      }
    }
    return rows;
  }

  Future<List<_FileRow>> _listSmartbooks() async {
    final files = await _fileService.listFiles(
      bucket: 'univecos',
      prefix: 'smartbooks/',
    );
    return files
        .map((f) => _FileRow(path: 'smartbooks/${f.name}', display: f.name))
        .toList();
  }

  Future<List<_FileRow>> _listTemplates() async {
    final files = await _fileService.listFiles(
      bucket: 'univecos',
      prefix: 'templates/',
    );
    return files
        .map((f) => _FileRow(path: 'templates/${f.name}', display: f.name))
        .toList();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _journalTitleCtrl.dispose();
    _smartbookTitleCtrl.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Content'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Journals'),
            Tab(text: 'Smartbooks'),
            Tab(text: 'Templates'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_journalsTab(), _smartbooksTab(), _templatesTab()],
      ),
    );
  }
  // Tambahkan fungsi hapus
Future<void> _deleteJournal(String path) async {
  try {
    final supabase = Supabase.instance.client;
    await supabase.storage.from('univecos').remove([path]);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Jurnal berhasil dihapus')),
    );

    setState(() {}); // refresh daftar setelah dihapus
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal menghapus jurnal: $e')),
    );
  }
}

Widget _journalsTab() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        DropdownButtonFormField<String>(
          value: _journalCategory,
          decoration: const InputDecoration(labelText: 'Kategori'),
          items: const [
            DropdownMenuItem(
              value: 'Ekosistem Hujan Tropis',
              child: Text('Ekosistem Hujan Tropis'),
            ),
            DropdownMenuItem(
              value: 'Ekosistem Sabana',
              child: Text('Ekosistem Sabana'),
            ),
            DropdownMenuItem(
              value: 'Ekosistem Bakau',
              child: Text('Ekosistem Bakau'),
            ),
            DropdownMenuItem(value: 'Biotik', child: Text('Biotik')),
            DropdownMenuItem(value: 'Abiotik', child: Text('Abiotik')),
          ],
          onChanged:
              (v) => setState(() => _journalCategory = v ?? _journalCategory),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _journalTitleCtrl,
          decoration: const InputDecoration(
            labelText: 'Judul PDF (tanpa .pdf)',
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed:
                  () => _pickPdf((bytes, name) {
                    setState(() {
                      _selectedJournalFile = bytes;
                      _selectedJournalName = name;
                    });
                  }),
              icon: const Icon(Icons.attach_file),
              label: const Text('Pilih File'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(_selectedJournalName ?? 'Belum ada file dipilih'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _uploadingJournal ? null : _uploadJournal,
            icon:
                _uploadingJournal
                    ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Icon(Icons.upload),
            label: const Text('Upload Journal'),
          ),
        ),
        const Divider(height: 24),
        Expanded(
          child: FutureBuilder<List<_FileRow>>(
            future: _listJournals(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final files = snap.data ?? [];
              if (files.isEmpty)
                return const Center(child: Text('Belum ada jurnal'));
              return ListView.separated(
                itemCount: files.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final row = files[i];
                  return ListTile(
                    leading: const Icon(Icons.picture_as_pdf),
                    title: Text(row.display),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          child: const Text('Preview'),
                          onPressed: () =>
                              _openPreview('univecos', row.path, row.display),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteJournal(row.path),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    ),
  );
}


  Widget _smartbooksTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _smartbookTitleCtrl,
            decoration: const InputDecoration(
              labelText: 'Judul PDF (tanpa .pdf)',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed:
                    () => _pickPdf((bytes, name) {
                      setState(() {
                        _selectedSmartbookFile = bytes;
                        _selectedSmartbookName = name;
                      });
                    }),
                icon: const Icon(Icons.attach_file),
                label: const Text('Pilih File'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(_selectedSmartbookName ?? 'Belum ada file dipilih'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _uploadingSmartbook ? null : _uploadSmartbook,
              icon:
                  _uploadingSmartbook
                      ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.upload),
              label: const Text('Upload Smartbook'),
            ),
          ),
          const Divider(height: 24),
          Expanded(
            child: FutureBuilder<List<_FileRow>>(
              future: _listSmartbooks(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final files = snap.data ?? [];
                if (files.isEmpty)
                  return const Center(child: Text('Belum ada smartbook'));
                return ListView.separated(
                  itemCount: files.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final row = files[i];
                    return ListTile(
                    leading: const Icon(Icons.picture_as_pdf),
                    title: Text(row.display),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          child: const Text('Preview'),
                          onPressed: () =>
                              _openPreview('univecos', row.path, row.display),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteJournal(row.path),
                        ),
                      ],
                    ),
                  );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _templatesTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              ElevatedButton.icon(
                onPressed:
                    () => _pickPdf((bytes, name) {
                      setState(() {
                        _selectedTemplateFile = bytes;
                        _selectedTemplateName = name;
                      });
                    }),
                icon: const Icon(Icons.attach_file),
                label: const Text('Pilih File Template'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(_selectedTemplateName ?? 'Belum ada file dipilih'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton.icon(
                onPressed:
                    _uploadingTemplate
                        ? null
                        : () => _uploadTemplate('rancangan'),
                icon:
                    _uploadingTemplate
                        ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.upload_file),
                label: const Text('Upload Rancangan'),
              ),
              ElevatedButton.icon(
                onPressed:
                    _uploadingTemplate
                        ? null
                        : () => _uploadTemplate('laporan'),
                icon:
                    _uploadingTemplate
                        ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.upload_file),
                label: const Text('Upload Laporan'),
              ),
              ElevatedButton.icon(
                onPressed:
                    _uploadingTemplate ? null : () => _uploadTemplate('rapor'),
                icon:
                    _uploadingTemplate
                        ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.upload_file),
                label: const Text('Upload Rapor'),
              ),
            ],
          ),
          const Divider(height: 24),
          Expanded(
            child: FutureBuilder<List<_FileRow>>(
              future: _listTemplates(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final files = snap.data ?? [];
                if (files.isEmpty)
                  return const Center(child: Text('Belum ada template'));
                return ListView.separated(
                  itemCount: files.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final row = files[i];
                    return ListTile(
                      leading: const Icon(Icons.picture_as_pdf),
                      title: Text(row.display),
                      trailing: TextButton(
                        child: const Text('Preview'),
                        onPressed:
                            () =>
                                _openPreview('univecos', row.path, row.display),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FileRow {
  final String path;
  final String display;
  _FileRow({required this.path, required this.display});
}
