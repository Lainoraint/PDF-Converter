import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

class DocumentRepository {
  final Dio _dio = Dio();
  final String serverUrl = 'http://10.111.16.107:8000';

  String _stripExtension(String fileName) {
    return fileName.contains('.')
        ? fileName.substring(0, fileName.lastIndexOf('.'))
        : fileName;
  }

  Exception _buildError(DioException e) {
    if (e.response?.data != null) {
      try {
        final decoded = utf8.decode(e.response!.data as List<int>);
        final json = jsonDecode(decoded);
        if (json['detail'] != null) {
          return Exception(json['detail'].toString());
        }
      } catch (_) {
      }
    }
    debugPrint('DioException: ${e.message}, Response: ${e.response?.data}');
    return Exception("Kesalahan Jaringan: ${e.message}");
  }

  Future<File> convertToPdf(File inputFile, {String orientation = 'landscape'}) async {
    try {
      String originalFileName = inputFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          inputFile.path,
          filename: originalFileName,
        ),
        "orientation": orientation,
      });

      Response response = await _dio.post(
        '$serverUrl/convert/',
        data: formData,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        Directory directory = await getApplicationDocumentsDirectory();
        String newFileName = '${_stripExtension(originalFileName)}.pdf';
        String savePath = '${directory.path}/$newFileName';
        File savedFile = File(savePath);
        await savedFile.writeAsBytes(response.data);
        return savedFile;
      } else {
        throw Exception("Gagal mengonversi dokumen. Status: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw _buildError(e);
    } catch (e) {
      throw Exception("Terjadi kesalahan sistem: $e");
    }
  }

  Future<File> convertFromPdf(File inputFile, String targetFormat) async {
    try {
      String originalFileName = inputFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "target_format": targetFormat,
        "file": await MultipartFile.fromFile(
          inputFile.path,
          filename: originalFileName,
        ),
      });

      Response response = await _dio.post(
        '$serverUrl/convert-from-pdf/',
        data: formData,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        Directory directory = await getApplicationDocumentsDirectory();
        String newFileName = '${_stripExtension(originalFileName)}.$targetFormat';
        String savePath = '${directory.path}/$newFileName';
        File savedFile = File(savePath);
        await savedFile.writeAsBytes(response.data);
        return savedFile;
      } else {
        throw Exception("Gagal mengonversi dokumen. Status: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw _buildError(e);
    } catch (e) {
      throw Exception("Terjadi kesalahan sistem: $e");
    }
  }
}