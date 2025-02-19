import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:pos_app/data/api/urls.dart';
import 'package:pos_app/data/models/response_model.dart';

class ApiService {
  static final Dio _dio = Client().init();

  static Future<ResponseModel> getApiData(String url, {Map<String, dynamic>? queryParams}) async {
    String apiUrl = url;
    print(apiUrl);
    try {
      final response = await _dio.get(
        apiUrl,
        queryParameters: queryParams,
        options: Options(headers: Urls.getHeaders()),
      );
      if (response.statusCode == 200) {
        final jsonObject = response.data as Map<String, dynamic>;
        final bool isSuccess = jsonObject['status'];

        return ResponseModel(
          statusCode: response.statusCode!,
          body: json.encode(response.data),
          response: response,
          responseObject: jsonObject,
          errorMessage: jsonObject['message'],
          isSuccess: isSuccess,
        );
      } else if (response.statusCode == 401) {
        return ResponseModel(
          statusCode: response.statusCode!,
          body: json.encode(response.data),
          response: response,
          errorMessage: "Session expired please login",
          isSuccess: false,
          responseObject: {},
        );
      } else if (response.statusCode == 404) {
        final jsonObject = response.data as Map<String, dynamic>;

        return ResponseModel(
          statusCode: response.statusCode!,
          body: json.encode(response.data),
          response: response,
          errorMessage: jsonObject['message'],
          isSuccess: false,
          responseObject: {},
        );
      } else {
        final jsonObject = response.data as Map<String, dynamic>;

        return ResponseModel(
          statusCode: response.statusCode!,
          body: json.encode(response.data),
          response: response,
          errorMessage: jsonObject['message'],
          isSuccess: false,
          responseObject: {},
        );
      }
    } on DioException catch (e) {
      return ResponseModel(
        statusCode: e.response?.statusCode ?? 0,
        body: e.response?.data?.toString() ?? e.message ?? "",
        response: e.response,
        errorMessage: e.message,
        isSuccess: false,
        responseObject: {},
      );
    } catch (e) {
      print(e);
      return ResponseModel(
        statusCode: 0,
        body: e.toString(),
        response: null,
        errorMessage: e.toString(),
        isSuccess: false,
        responseObject: {},
      );
    }
  }

  static Future<ResponseModel> postApiData(String url, dynamic body) async {
    try {
      final response = await _dio.post(
        url,
        data: body,
        options: Options(headers: Urls.getHeaders()),
      );
      print(url);
      print(body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonObject = response.data as Map<String, dynamic>;
        final bool isSuccess = jsonObject['status'];

        return ResponseModel(
          statusCode: response.statusCode!,
          body: json.encode(response.data),
          response: response,
          responseObject: jsonObject,
          isSuccess: isSuccess,
          errorMessage: jsonObject['message'],
        );
      } else if (response.statusCode == 401) {
        return ResponseModel(
          statusCode: response.statusCode!,
          body: json.encode(response.data),
          response: response,
          errorMessage: "Session expired please login",
          isSuccess: false,
          responseObject: {},
        );
      } else if (response.statusCode == 404) {
        final jsonObject = response.data as Map<String, dynamic>;

        return ResponseModel(
          statusCode: response.statusCode!,
          body: json.encode(response.data),
          response: response,
          errorMessage: jsonObject['message'],
          isSuccess: false,
          responseObject: {},
        );
      } else {
        final jsonObject = response.data as Map<String, dynamic>;

        return ResponseModel(
          statusCode: response.statusCode!,
          body: json.encode(response.data),
          response: response,
          errorMessage: jsonObject['message'],
          isSuccess: false,
          responseObject: {},
        );
      }
    } on DioException catch (e) {
      print(e);

      return ResponseModel(
        statusCode: e.response?.statusCode ?? 0,
        body: e.response?.data?.toString() ?? e.message ?? "",
        response: e.response,
        errorMessage: e.message,
        isSuccess: false,
        responseObject: {},
      );
    } catch (e) {
      print(e);
      return ResponseModel(
        statusCode: 0,
        body: e.toString(),
        response: null,
        errorMessage: e.toString(),
        isSuccess: false,
        responseObject: {},
      );
    }
  }

  static Future<ResponseModel> putApiData(String url, dynamic body) async {
    try {
      final response = await _dio.put(
        url,
        data: body,
        options: Options(headers: Urls.getHeaders()),
      );
      if (response.statusCode == 200) {
        final jsonObject = response.data as Map<String, dynamic>;
        final bool isSuccess = jsonObject['status'];

        return ResponseModel(
          statusCode: response.statusCode!,
          body: json.encode(response.data),
          response: response,
          responseObject: jsonObject,
          isSuccess: isSuccess,
          errorMessage: jsonObject['message'],
        );
      } else if (response.statusCode == 401) {
        return ResponseModel(
          statusCode: response.statusCode!,
          body: json.encode(response.data),
          response: response,
          errorMessage: "Session expired please login",
          isSuccess: false,
          responseObject: {},
        );
      } else if (response.statusCode == 404) {
        final jsonObject = response.data as Map<String, dynamic>;

        return ResponseModel(
          statusCode: response.statusCode!,
          body: json.encode(response.data),
          response: response,
          errorMessage: jsonObject['message'],
          isSuccess: false,
          responseObject: {},
        );
      } else {
        return ResponseModel(
          statusCode: response.statusCode!,
          body: json.encode(response.data),
          response: response,
          errorMessage: "Internal error: ${response.data}",
          isSuccess: false,
          responseObject: {},
        );
      }
    } on DioException catch (e) {
      print(e);

      return ResponseModel(
        statusCode: e.response?.statusCode ?? 0,
        body: e.response?.data?.toString() ?? e.message ?? "",
        response: e.response,
        errorMessage: e.message,
        isSuccess: false,
        responseObject: {},
      );
    } catch (e) {
      print(e);
      return ResponseModel(
        statusCode: 0,
        body: e.toString(),
        response: null,
        errorMessage: e.toString(),
        isSuccess: false,
        responseObject: {},
      );
    }
  }

  static Future<ResponseModel> getFileApi(String url, dynamic body) async {
    try {
      final response = await _dio.post(
        url,
        data: body,
        options: Options(
          headers: Urls.getHeaders(),
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200) {
        return ResponseModel(
          statusCode: response.statusCode!,
          body: "", // Empty since we're dealing with bytes
          response: response,
          bodyBytes: Uint8List.fromList(response.data),
          responseObject: {},
          isSuccess: true,
        );
      } else if (response.statusCode == 401) {
        return ResponseModel(
          statusCode: response.statusCode!,
          body: json.encode(response.data),
          response: response,
          errorMessage: "Session expired please login",
          isSuccess: false,
          responseObject: {},
        );
      } else if (response.statusCode == 404) {
        final jsonObject = response.data as Map<String, dynamic>;

        return ResponseModel(
          statusCode: response.statusCode!,
          body: json.encode(response.data),
          response: response,
          errorMessage: jsonObject['message'],
          isSuccess: false,
          responseObject: {},
        );
      } else {
        return ResponseModel(
          statusCode: response.statusCode!,
          body: json.encode(response.data),
          response: response,
          errorMessage: "Internal error: ${response.data}",
          isSuccess: false,
          responseObject: {},
        );
      }
    } on DioException catch (e) {
      return ResponseModel(
        statusCode: e.response?.statusCode ?? 0,
        body: e.response?.data?.toString() ?? e.message ?? "",
        response: e.response,
        errorMessage: e.message,
        isSuccess: false,
        responseObject: {},
      );
    } catch (e) {
      return ResponseModel(
        statusCode: 0,
        body: e.toString(),
        response: null,
        errorMessage: e.toString(),
        isSuccess: false,
        responseObject: {},
      );
    }
  }
}

class Client {
  Dio init() {
    final Dio dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          print(e.message);
          if (e.type == DioExceptionType.connectionError) {
            print(e.message);
            final response = Response(
              requestOptions: e.requestOptions,
              data: {"success": false, "message": "No internet connection"},
              statusCode: 101,
            );

            // Return the custom response
            return handler.resolve(response);
          } else if (e.type == DioExceptionType.badResponse) {
            final response = Response(
              requestOptions: e.requestOptions,
              data: {"success": false, "message": "Bad response"},
              statusCode: 101,
            );

            // Return the custom response
            return handler.resolve(response);
          } else {
            print(e.message);
            if (e.response?.statusCode == 401) {
              final jsonObject = e.response?.data as Map<String, dynamic>;
              final response = Response(
                requestOptions: e.requestOptions,
                data: jsonObject,
                statusCode: e.response?.statusCode,
              );

              // Return the custom response
              return handler.resolve(response);
              // await loginController.logout(getMain.Get.context!);
            } else {
              final jsonObject = e.response?.data;
              final response = Response(
                requestOptions: e.requestOptions,
                data: jsonObject,
                statusCode: e.response?.statusCode,
              );

              // Return the custom response
              return handler.resolve(response);
            }
          }
        },
      ),
    );
    return dio;
  }
}
