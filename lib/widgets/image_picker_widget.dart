import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/data/services/image_upload_service.dart';
import 'package:pos_app/widgets/custom_snackbar.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(String) onImageUploaded;
  final String? initialImageUrl;
  final String folder;
  final double size;
  final bool isCircular;

  const ImagePickerWidget({
    Key? key,
    required this.onImageUploaded,
    this.initialImageUrl,
    required this.folder,
    this.size = 100,
    this.isCircular = true,
  }) : super(key: key);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _imageFile;
  String? _imageUrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.initialImageUrl;
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
          _isUploading = true;
        });

        final String? downloadUrl = await ImageUploadService().uploadImage(
          _imageFile!,
          widget.folder,
        );

        if (downloadUrl != null) {
          setState(() {
            _imageUrl = downloadUrl;
            _isUploading = false;
          });
          widget.onImageUploaded(downloadUrl);
        } else {
          setState(() => _isUploading = false);
          CustomSnackBar.showError(message: 'Failed to upload image');
        }
      }
    } catch (e) {
      setState(() => _isUploading = false);
      CustomSnackBar.showError(message: 'Error picking image: $e');
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showImageSourceDialog,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: widget.isCircular ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: widget.isCircular ? null : BorderRadius.circular(8),
        ),
        child: _isUploading
            ? const Center(child: CircularProgressIndicator())
            : _imageUrl != null
                ? ClipRRect(
                    borderRadius: widget.isCircular ? BorderRadius.circular(widget.size / 2) : BorderRadius.circular(8),
                    child: Image.network(
                      _imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                    ),
                  )
                : Icon(
                    Icons.add_a_photo,
                    size: widget.size * 0.4,
                    color: Colors.grey[400],
                  ),
      ),
    );
  }
}
