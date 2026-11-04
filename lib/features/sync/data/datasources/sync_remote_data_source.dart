import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:quiz_app/core/constants/api_constants.dart';
import 'package:quiz_app/core/errors/app_exception.dart';
import 'package:quiz_app/features/sync/data/models/sync_content_model.dart';

class SyncRemoteDataSource {
  SyncRemoteDataSource(this._client);
  final http.Client _client;

  /// Asks the server for the current content version.
  Future<int> fetchVersion({void Function()? onSlowResponse}) async {
    final json = await _getJson(
      ApiConstants.versionPath,
      timeout: ApiConstants.versionTimeout,
      onSlowResponse: onSlowResponse,
    );
    final version = json['version'];
    if (version is! int) {
      throw const ServerException('Unexpected response from the server.');
    }
    return version;
  }


  // Downloads all categories and questions in one snapshot.
  Future<SyncContentModel> fetchContent({
    void Function()? onSlowResponse,
  }) async {
    final json = await _getJson(
      ApiConstants.syncPath,
      timeout: ApiConstants.syncTimeout,
      onSlowResponse: onSlowResponse,
    );
    try {
      return SyncContentModel.fromJson(json);
    } 
    on TypeError {
      throw const ServerException('Unexpected response from the server.');
    } 
    on FormatException {
      throw const ServerException('Unexpected response from the server.');
    }
  }


  // ------------------------ Helper Methods ------------------------ 
  Future<Map<String, dynamic>> _getJson(
    String path, {
    required Duration timeout,
    void Function()? onSlowResponse,
  }) async {
    final slowTimer = onSlowResponse == null
                      ? null
                      : Timer(ApiConstants.slowResponseThreshold, onSlowResponse);

    try {
      final response = await _client.get( Uri.parse('${ApiConstants.baseUrl}$path') )
                                    .timeout( timeout );
      final body = utf8.decode(response.bodyBytes);

      if (response.statusCode != 200) {
        throw ServerException(
          _problemMessage(body),
          statusCode: response.statusCode
        );
      }
      return jsonDecode(body) as Map<String, dynamic>;
    } 
    on TimeoutException {
      throw const NetworkException('The server took too long to respond.');
    } 
    on SocketException {
      throw const NetworkException('No internet connection.');
    } 
    on http.ClientException {
      throw const NetworkException('Could not reach the server.');
    } 
    on FormatException {
      throw const ServerException('Unexpected response from the server.');
    } 
    finally {
      slowTimer?.cancel();
    }
  }

  
  /// Reads the `detail` or `title` of a ProblemDetail error body.
  String _problemMessage(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      return (json['detail'] ?? json['title'] ?? 'Server error').toString();
    } 
    catch (_) {
      return 'Server error';
    }
  }
}