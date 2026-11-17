import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/core/errors/app_exception.dart';

class FeedbackRemoteDataSource {
  FeedbackRemoteDataSource(this._client);

  final http.Client _client;

  /// Given at build time: --dart-define-from-file=env.json
  static const _url = String.fromEnvironment('FEEDBACK_URL');
  static const _timeout = Duration(seconds: 30);

  Future<void> send(Map<String, Object?> payload) async {
    if (_url.isEmpty) {
      throw const ServerException('Feedback is not available right now.');
    }

    try {
      var response = await _client
          .post(
            Uri.parse(_url),
            // text/plain: Apps Script reads the body the same way.
            headers: {'Content-Type': 'text/plain;charset=utf-8'},
            body: jsonEncode(payload),
          )
          .timeout(_timeout);

      // Apps Script answers a POST with a redirect to the real result.
      // (response.isRedirect is only true for 303 on a POST, so we check the status code ourselves.)
      final location = response.headers['location'];
      const redirectCodes = {301, 302, 303, 307, 308};
      if (redirectCodes.contains(response.statusCode) && location != null) {
       response = await _client.get(Uri.parse(location)).timeout(_timeout);
      }

      if (kDebugMode) {
        debugPrint('Feedback response: ${response.statusCode} ${response.body}');
      }
      
      if (response.statusCode != 200) {
        throw ServerException(
          'Could not send your feedback.',
          statusCode: response.statusCode,
        );
      }
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if (body is! Map<String, dynamic> || body['ok'] != true) {
        throw const ServerException('Could not send your feedback.');
      }
    } on TimeoutException {
      throw const NetworkException('The request took too long.');
    } on SocketException {
      throw const NetworkException('No internet connection.');
    } on http.ClientException {
      throw const NetworkException('Could not reach the server.');
    } on FormatException {
      throw const ServerException('Could not send your feedback.');
    }
  }
}