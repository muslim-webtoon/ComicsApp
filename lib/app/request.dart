import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

import 'package:flutter/services.dart' show rootBundle;

class Request {
  static const String baseUrl = 'http://api.webcomics.pk/api/';

  static Future<dynamic> get({String url, Map params}) async {
    return Request.mock(url: url, params: params);
  }

  static Future<dynamic> post({String url, Map params}) async {
    return Request.mock(url: url, params: params);
  }

  static Future<dynamic> mock({String url, Map params}) async {
    var responseStr = await rootBundle.loadString('mock/$url.json');
    var responseJson = json.decode(responseStr);
    return responseJson['data'];
  }

  Future<dynamic> request(String host,
      {String method = 'GET',
      dynamic data,
      dynamic queryParameters,
      bool cached = false,
      Map<String, Object> headers,
      cacheDuration = const Duration(days: 1),
      maxStale = const Duration(days: 30)}) async {
    try {
      var dio = new Dio(BaseOptions(method: method, baseUrl: baseUrl));
      if (cached)
        dio.interceptors.add(DioCacheManager(CacheConfig()).interceptor);
      if (headers != null) dio..options.headers = headers;
      var response = await dio.request(
        host,
        data: data,
        queryParameters: queryParameters,
        options: cached
            ? buildCacheOptions(
                cacheDuration,
                maxStale: maxStale,
              )
            : null,
      );
      return response.data;
    } on DioError catch(_) {
      return null;
    }
  }

  /*
   Future<Movie> nowPlaying() async {
    var now = await http
        .get('${URL}now_playing')
        .then((res) => json.decode(res.body))
        .then((obj) => Movie.fromJson(obj));

    return now;
  }
  */

}