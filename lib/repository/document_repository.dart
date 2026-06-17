import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

class DocumentRepository {
  final Dio _dio = Dio();
  
  final String baseUrl = 'http://10.111.16.107:8000/convert/';

  Future<File> convertToPdf(File inputFile) async {
    try {
      String originalFileName = inputFile.path.split('/').last;
      
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          inputFile.path, 
          filename: originalFileName,
        ),
      });

      Response response = await _dio.post(
        baseUrl,
        data: formData,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        Directory directory = await getApplicationDocumentsDirectory();
        
        String newFileName = '${originalFileName.split('.').first}.pdf';
        String savePath = '${directory.path}/$newFileName';

        File savedPdf = File(savePath);
        await savedPdf.writeAsBytes(response.data);

        return savedPdf;
      } else {
        throw Exception("Gagal mengonversi dokumen. Status: ${response.statusCode}");
      }
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
      throw Exception("Kesalahan Jaringan: ${e.message}");
    } catch (e) {
      throw Exception("Terjadi kesalahan sistem: $e");
    }
  }
}