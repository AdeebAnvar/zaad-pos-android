// import 'dart:async';
// import 'dart:convert';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:http/http.dart' as http;
// import 'package:pos_app/data/models/response_model.dart';
// import 'package:pos_app/widgets/custom_snackbar.dart';

// class NetworkService {
//   static final NetworkService _instance = NetworkService._internal();
//   factory NetworkService() => _instance;
//   NetworkService._internal();

//   final String baseUrl = 'https://your-api-base-url.com/api'; // Replace with your API base URL
//   final http.Client _client = http.Client();
//   final Connectivity _connectivity = Connectivity();
//   final StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();

//   Stream<bool> get connectionStatus => _connectionStatusController.stream;

//   Future<void> initialize() async {
//     // Check initial connection status
//     ConnectivityResult result = await _connectivity.checkConnectivity();
//     _connectionStatusController.add(result != ConnectivityResult.none);

//     // Listen for connectivity changes
//     _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
//       _connectionStatusController.add(result != ConnectivityResult.none);
//     });
//   }

//   Future<ResponseModel> get(String endpoint, {Map<String, String>? headers}) async {
//     try {
//       if (!await _checkConnectivity()) {
//         return ResponseModel(
//           isSuccess: false,
//           errorMessage: 'No internet connection',
//           statusCode: 0,
//           body: '',
//           response: null,
//           responseObject: {},
//         );
//       }

//       final response = await _client.get(
//         Uri.parse('$baseUrl$endpoint'),
//         headers: _getHeaders(headers),
//       );

//       return _handleResponse(response);
//     } catch (e) {
//       return _handleError(e);
//     }
//   }

//   Future<ResponseModel> post(String endpoint, dynamic body, {Map<String, String>? headers}) async {
//     try {
//       if (!await _checkConnectivity()) {
//         return ResponseModel(
//           isSuccess: false,
//           errorMessage: 'No internet connection',
//           statusCode: 0,
//           body: '',
//           response: null,
//           responseObject: {},
//         );
//       }

//       final response = await _client.post(
//         Uri.parse('$baseUrl$endpoint'),
//         headers: _getHeaders(headers),
//         body: json.encode(body),
//       );

//       return _handleResponse(response);
//     } catch (e) {
//       return _handleError(e);
//     }
//   }

//   Future<ResponseModel> put(String endpoint, dynamic body, {Map<String, String>? headers}) async {
//     try {
//       if (!await _checkConnectivity()) {
//         return ResponseModel(
//           isSuccess: false,
//           errorMessage: 'No internet connection',
//           statusCode: 0,
//           body: '',
//           response: null,
//           responseObject: {},
//         );
//       }

//       final response = await _client.put(
//         Uri.parse('$baseUrl$endpoint'),
//         headers: _getHeaders(headers),
//         body: json.encode(body),
//       );

//       return _handleResponse(response);
//     } catch (e) {
//       return _handleError(e);
//     }
//   }

//   Future<ResponseModel> delete(String endpoint, {Map<String, String>? headers}) async {
//     try {
//       if (!await _checkConnectivity()) {
//         return ResponseModel(
//           isSuccess: false,
//           errorMessage: 'No internet connection',
//           statusCode: 0,
//           body: '',
//           response: null,
//           responseObject: {},
//         );
//       }

//       final response = await _client.delete(
//         Uri.parse('$baseUrl$endpoint'),
//         headers: _getHeaders(headers),
//       );

//       return _handleResponse(response);
//     } catch (e) {
//       return _handleError(e);
//     }
//   }

//   Map<String, String> _getHeaders(Map<String, String>? headers) {
//     final defaultHeaders = {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//       // Add your authentication token here if needed
//       // 'Authorization': 'Bearer $token',
//     };

//     if (headers != null) {
//       defaultHeaders.addAll(headers);
//     }

//     return defaultHeaders;
//   }

//   Future<bool> _checkConnectivity() async {
//     final result = await _connectivity.checkConnectivity();
//     return result != ConnectivityResult.none;
//   }

//   ResponseModel _handleResponse(http.Response response) {
//     try {
//       final responseData = json.decode(response.body);

//       return ResponseModel(
//         isSuccess: response.statusCode >= 200 && response.statusCode < 300,
//         statusCode: response.statusCode,
//         body: response.body,
//         response: response,
//         responseObject: responseData,
//         errorMessage: response.statusCode >= 200 && response.statusCode < 300 ? null : responseData['message'] ?? 'An error occurred',
//       );
//     } catch (e) {
//       return ResponseModel(
//         isSuccess: false,
//         statusCode: response.statusCode,
//         body: response.body,
//         response: response,
//         responseObject: {},
//         errorMessage: 'Failed to parse response',
//       );
//     }
//   }

//   ResponseModel _handleError(dynamic error) {
//     String errorMessage = 'An error occurred';

//     if (error is http.ClientException) {
//       errorMessage = 'Network error occurred';
//     } else if (error is TimeoutException) {
//       errorMessage = 'Request timed out';
//     }

//     CustomSnackBar.showError(message: errorMessage);

//     return ResponseModel(
//       isSuccess: false,
//       statusCode: 0,
//       body: '',
//       response: null,
//       responseObject: {},
//       errorMessage: errorMessage,
//     );
//   }

//   void dispose() {
//     _client.close();
//     _connectionStatusController.close();
//   }
// }
