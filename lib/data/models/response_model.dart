import 'dart:typed_data';

class ResponseModel {
  ResponseModel({required this.statusCode, required this.body, required this.response, this.errorMessage, required this.responseObject, required this.isSuccess, this.bodyBytes});
  int statusCode;
  String body;
  dynamic response;
  String? errorMessage;
  Map<String, dynamic> responseObject;
  bool isSuccess;
  Uint8List? bodyBytes;
}
