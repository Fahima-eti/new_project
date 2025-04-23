import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:new_project/app.dart';
import 'package:new_project/ui/controllers/auth_controller.dart';

import '../../ui/login_screen.dart';

class NetworkResponse {
  final bool isSuccess;
  final int statusCode;
  final Map<String, dynamic>? data;
  final String errorMessage;

  NetworkResponse({
    required this.isSuccess,
    required this.statusCode,
    this.data,
    this.errorMessage = "Something went wrong",
  });

  bool get hasError => !isSuccess;
}

class NetworkClient {
  static final _logger = Logger();

  // -------------------- GET Request --------------------
  static Future<NetworkResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      Map<String ,String> headers = {"Content-Type":
      "application/json","token":AuthController.token ?? ""};

      _preRequestLog(url,headers);

      Response response = await get(uri,headers: headers);

      _postRequestLog(url, response.statusCode,
          responseBody: response.body, headers: response.headers);

      final decodedJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          data: decodedJson,
        );
      }else if( response .statusCode == 401){
        _moveToLoginScreen();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
            errorMessage: "Un-authorize user.please login in again"
        );

      }
      else {
        String errorMessage = _extractErrorMessage(decodedJson);
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: errorMessage,
        );
      }
    } catch (e) {
      _postRequestLog(url, -1, errorMessage: e.toString());
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  // -------------------- POST Request --------------------
  static Future<NetworkResponse> postRequest({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      Map<String ,String> headers = {"Content-Type":
      "application/json","token":AuthController.token ?? ""};

      _preRequestLog(url,headers, body: body);

      Response response = await post(
        uri,
        headers:headers,
          body: jsonEncode(body));

      _postRequestLog(url, response.statusCode,
          headers: response.headers, responseBody: response.body);

      final decodedJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          data: decodedJson,
        );
      }else if( response .statusCode == 401){
        _moveToLoginScreen();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: "Un-authorize user.please login in again"
        );

      }
      else {
        String errorMessage = _extractErrorMessage(decodedJson);
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: errorMessage,
        );
      }
    } catch (e) {
      _postRequestLog(url, -1, errorMessage: e.toString());
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  // -------------------- Helpers --------------------

  static void _preRequestLog(String url, Map<String,String> headers ,{Map<String, dynamic>? body}) {
    _logger.i("📤 Request:\nURL: $url\nHeaders:$headers\n"
        "Body: $body");
  }

  static void _postRequestLog(
      String url,
      int statusCode, {
        Map<String, dynamic>? headers,
        dynamic responseBody,
        dynamic errorMessage,
      }) {
    if (errorMessage != null) {
      _logger.e("Error:\nURL: $url\nStatus Code: $statusCode\nError: $errorMessage");
    } else {
      _logger.i("Response:\nURL: $url\nStatus Code: $statusCode\nHeaders: $headers\nBody: $responseBody");
    }
  }

  static String _extractErrorMessage(dynamic decodedJson) {
    try {
      if (decodedJson is Map<String, dynamic>) {
        if (decodedJson['data'] is String) {
          return decodedJson['data'];
        } else if (decodedJson['data'] is Map &&
            decodedJson['data']['message'] is String) {
          return decodedJson['data']['message'];
        }
      }
    } catch (_) {
      // Ignore and fallback to default
    }
    return "Something went wrong";
  }
 static Future<void> _moveToLoginScreen()async{
    await AuthController.clearUserData();

    Navigator.pushAndRemoveUntil(
        TaskManagerApp.navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context)=>LoginScreen(),),
            (predicate)=>false);

  }
}
