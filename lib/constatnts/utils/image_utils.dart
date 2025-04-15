import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class ImageUtils {
  Future<String> downloadProductImage(String url, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/$fileName'; // Save path

    final file = File(path);
    if (await file.exists()) {
      return path; // Return path if image exists
    }

    final dio = Dio();
    await dio.download(url, path); // Download the image
    return path; // Return the path after saving
  }
}
