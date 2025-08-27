import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class ImageUploadService {
  static final ImageUploadService _instance = ImageUploadService._internal();
  factory ImageUploadService() => _instance;
  ImageUploadService._internal();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _uuid = const Uuid();

  Future<String?> uploadImage(File imageFile, String folder) async {
    try {
      // Generate a unique filename
      final String fileName = '${_uuid.v4()}${path.extension(imageFile.path)}';
      final String filePath = '$folder/$fileName';

      // Create a reference to the file location
      final Reference storageRef = _storage.ref().child(filePath);

      // Upload the file
      final UploadTask uploadTask = storageRef.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/${path.extension(imageFile.path).substring(1)}',
        ),
      );

      // Wait for the upload to complete
      final TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      // Get the reference from the URL
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  Future<String?> uploadProductImage(File imageFile) async {
    return await uploadImage(imageFile, 'products');
  }

  Future<String?> uploadCustomerImage(File imageFile) async {
    return await uploadImage(imageFile, 'customers');
  }

  Future<String?> uploadOrderImage(File imageFile) async {
    return await uploadImage(imageFile, 'orders');
  }
}
