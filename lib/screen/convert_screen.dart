import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/convert/convert_bloc.dart';
import '../bloc/convert/convert_event.dart';
import '../bloc/convert/convert_state.dart';

class ConvertScreen extends StatelessWidget {
  const ConvertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doc to PDF Converter'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocConsumer<ConvertBloc, ConvertState>(
            listener: (context, state) {
              if (state is ConvertFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state is ConvertSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Konversi berhasil!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is ConvertLoading) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 24),
                    Text(
                      'Sedang memproses dokumen di server...\nMohon tunggu sebentar.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                );
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state is ConvertSuccess) ...[
                    const Icon(Icons.picture_as_pdf, color: Colors.redAccent, size: 80),
                    const SizedBox(height: 16),
                    const Text(
                      'Konversi Selesai!',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    
                    ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          Directory downloadDir = Directory('/storage/emulated/0/Download');
                          
                          if (!await downloadDir.exists()) {
                            await downloadDir.create(recursive: true);
                          }

                          String fileName = state.pdfFile.path.split('/').last;
                          String publicSavePath = '${downloadDir.path}/$fileName';

                          await state.pdfFile.copy(publicSavePath);

                          final result = await OpenFilex.open(publicSavePath);

                          if (context.mounted) {
                            if (result.type == ResultType.noAppToOpen) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('File tersimpan di Download, tapi tidak ada aplikasi pembaca PDF di HP ini.'),
                                  backgroundColor: Colors.orange,
                                  duration: Duration(seconds: 4),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Tersimpan & Dibuka:\n$fileName'),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Gagal menyimpan file: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.download_for_offline),
                      label: const Text('Simpan & Buka File'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 32),
                ],

                  ElevatedButton.icon(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['png', 'jpg', 'jpeg', 'doc', 'docx', 'xls', 'xlsx'],
                      );

                      if (result != null && result.files.single.path != null) {
                        File selectedFile = File(result.files.single.path!);
                        if (context.mounted) {
                          context.read<ConvertBloc>().add(ConvertFileStarted(selectedFile));
                        }
                      }
                    },
                    icon: const Icon(Icons.upload_file),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                      child: Text(
                        'Pilih File & Konversi',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ]
              );
            },
          ),
        ),
      ),
    );
  }
}