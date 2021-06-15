import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_webrtc_pion/domain/repository/auth_repository.dart';
import 'package:flutter_webrtc_pion/internal/config.dart';

class AuthRepo extends AuthRepository {
  @override
  Future<dynamic> signIn({String login, String password}) async {
    final String url = Config.url;

    Dio dio = new Dio();
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 5000;

    dynamic JSONResponse;
    print(" Login : ${login} : Password ${password}");
    try {
      var apiRes = await dio.post(url + "/api/signin",
          data: {"login": login, "password": password});
      JSONResponse = jsonDecode(apiRes.toString());

    } on DioError catch(e) {
      if (e.response != null) {
        JSONResponse = e.response.data;
      } else {
        print(e);
      }
    }


    return JSONResponse;
  }
}
