import 'package:contacts_app/utils/utils.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class NetworkManager {
  static NetworkManager? _instance;

  NetworkManager._internal();

  factory NetworkManager() {
    _instance ??= NetworkManager._internal();
    return _instance!;
  }

  Future<bool> sendHttpRequest({
    required String endpoint,
    required HttpMethod type,
    ApiCallback? callback,
    Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(NetworkingUrls.baseUrl + endpoint);

      var headers = await getHeaders();

      http.Request request;
      if (type == HttpMethod.post) {
        request = http.Request('POST', uri);
        if (body != null) {
          request.body = json.encode(body);
        }
      } else if (type == HttpMethod.put) {
        request = http.Request('PUT', uri);
        request.body = json.encode(body);
      } else if (type == HttpMethod.get) {
        request = http.Request('GET', uri);
      } else {
        request = http.Request('DELETE', uri);
        if (body != null) {
          request.body = json.encode(body);
        }
      }
      request.headers.addAll(headers);

      http.StreamedResponse streamedResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamedResponse);

      callback?.onCompleted();
      response.statusCode == HttpStatus.ok
          ? callback?.onSuccess(response)
          : callback?.onError(response.reasonPhrase, response.statusCode);

      return true;
    } on SocketException catch (e) {
      callback?.onError(e.message, 1);
      return false;
    } catch (e) {
      debugPrint('NetworkManager: $e');
      return false;
    }
  }

  Future<Map<String, String>> getHeaders() async {
    Map<String, String> headers = {
      'Authorization': 'Bearer ${SharedPrefs.getAuthToken()}',
      'Content-Type': 'application/json',
    };

    return headers;
  }
}

class ApiCallback {
  ApiCallback({
    required this.onCompleted,
    required this.onSuccess,
    required this.onError,
  });

  final void Function() onCompleted;

  final void Function(http.Response response) onSuccess;

  final void Function(String? reason, int statusCode) onError;
}
