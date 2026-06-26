import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/convert/convert_bloc.dart';
import '../bloc/convert/convert_event.dart';
import '../bloc/convert/convert_state.dart';

class ConvertScreen extends StatefulWidget {
  final String pageTitle;
  final List<String> allowedExtensions;
  final Color themeColor;
  final bool isFromPdf;
  final String? targetFormat;

  const ConvertScreen({
    super.key,
    required this.pageTitle,
    required this.allowedExtensions,
    required this.themeColor,
    this.isFromPdf = false,
    this.targetFormat,
  });

  @override
  State<ConvertScreen> createState() => _ConvertScreenState();
}

class _ConvertScreenState extends State<ConvertScreen> {
  String _orientation = 'landscape';
  bool get _showOrientationToggle {
    if (widget.isFromPdf) return false;
    const excelExtensions = ['xls', 'xlsx'];
    return widget.allowedExtensions.any((ext) => excelExtensions.contains(ext.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: Text(widget.pageTitle),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1C1C1E),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: BlocConsumer<ConvertBloc, ConvertState>(
            listener: (context, state) {
              if (state is ConvertFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage), backgroundColor: Colors.red),
                );
              } else if (state is ConvertSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Konversi berhasil!'), backgroundColor: Colors.green),
                );
              }
            },
            builder: (context, state) {
              if (state is ConvertLoading) return _buildLoadingCard();
              if (state is ConvertSuccess) return _buildSuccessCard(context, state);
              return Column(
                children: [
                  if (_showOrientationToggle) _buildOrientationToggle(),
                  if (_showOrientationToggle) const SizedBox(height: 16),
                  _buildDropZone(context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOrientationToggle() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Orientasi Halaman',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _orientationOption(
                  label: 'Landscape',
                  value: 'landscape',
                  icon: Icons.stay_current_landscape_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _orientationOption(
                  label: 'Portrait',
                  value: 'portrait',
                  icon: Icons.stay_current_portrait_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _orientationOption({required String label, required String value, required IconData icon}) {
    final bool selected = _orientation == value;
    return InkWell(
      onTap: () => setState(() => _orientation = value),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? widget.themeColor.withValues(alpha: 0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? widget.themeColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? widget.themeColor : Colors.grey.shade500, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? widget.themeColor : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: widget.themeColor),
          const SizedBox(height: 32),
          const Text(
            'Memproses Dokumen...',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1C1C1E)),
          ),
          const SizedBox(height: 8),
          Text(
            'Mohon tunggu sebentar di layar ini.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessCard(BuildContext context, ConvertSuccess state) {
    String fileName = state.outputFile.path.split('/').last;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 64),
          ),
          const SizedBox(height: 24),
          const Text(
            'Konversi Selesai!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1C1C1E)),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                try {
                  if (!Platform.isAndroid) {
                    throw Exception('Simpan ke Download saat ini hanya didukung di Android.');
                  }
                  Directory downloadDir = Directory('/storage/emulated/0/Download');
                  if (!await downloadDir.exists()) {
                    await downloadDir.create(recursive: true);
                  }
                  String publicSavePath = '${downloadDir.path}/$fileName';
                  await state.outputFile.copy(publicSavePath);
                  final result = await OpenFilex.open(publicSavePath);

                  if (context.mounted) {
                    if (result.type == ResultType.noAppToOpen) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tersimpan di Download, tapi tidak ada PDF reader.'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Tersimpan & Dibuka:\n$fileName'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal menyimpan file: $e'), backgroundColor: Colors.red),
                    );
                  }
                }
              },
              icon: const Icon(Icons.download_rounded),
              label: const Text('Simpan & Buka File'),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.themeColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                context.read<ConvertBloc>().add(ConvertReset());
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade600,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Kembali ke Beranda', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropZone(BuildContext context) {
    return InkWell(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: widget.allowedExtensions,
        );

        if (result != null && result.files.single.path != null) {
          File selectedFile = File(result.files.single.path!);
          if (context.mounted) {
            context.read<ConvertBloc>().add(ConvertFileStarted(
              inputFile: selectedFile,
              isFromPdf: widget.isFromPdf,
              targetFormat: widget.targetFormat,
              orientation: _orientation,
            ));
          }
        }
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: widget.themeColor.withValues(alpha: 0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: widget.themeColor.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.themeColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.cloud_upload_rounded, size: 56, color: widget.themeColor),
            ),
            const SizedBox(height: 24),
            const Text(
              'Ketuk untuk mengunggah',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1C1C1E)),
            ),
            const SizedBox(height: 8),
            Text(
              'Mendukung format: ${widget.allowedExtensions.join(', ')}',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}