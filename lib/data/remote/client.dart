import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_pretty_dio_logger/flutter_pretty_dio_logger.dart';
import 'package:injectable/injectable.dart';
import 'package:themoviedb_app/data/remote/api_endpoint.dart';

@singleton
class Client {
  static const kTimeout = 30000;

  late Dio dio;

  Client() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(milliseconds: kTimeout),
        receiveTimeout: const Duration(milliseconds: kTimeout),
        validateStatus: (status) => true,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmZTAwOGQ0ZmUzNDc0MTIxZDdlNzMyZDNlZDY0Y2Q2MiIsInN1YiI6IjVjMTM1MjEwYzNhMzY4NjZkODM1OGI2OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.bpRQe6S882Jt870XOoVbSjGi5aUyL3uswwEudWSeJcw'
        },
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        error: true,
        showCUrl: true,
        responseBody: true,
        canShowLog: kDebugMode,
        showProcessingTime: false,
      ),
    );
  }

  void setToken(String? token) {
    if (null == token) {
      dio.options.headers.remove("Authorization");
    } else {
      dio.options.headers["Authorization"] = 'Bearer $token';
    }
  }
}
