import 'package:dio/dio.dart' show Options;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pos_app/data/api/service.dart';
import 'package:pos_app/data/api/urls.dart';
import 'package:path/path.dart' as p;

class ImageUtils {
  Future<String> downloadImage(String url, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, fileName);

    final file = File(path);
    if (await file.exists()) {
      return path; // Return path if image exists
    }

    try {
      final dio = Client().init();
      await dio.download('${Urls.baseUrl}$url', path, options: Options(headers: Urls.getHeaders())); // Download the image
    } catch (e) {
      rethrow;
    }
    return path; // Return the path after saving
  }
}
