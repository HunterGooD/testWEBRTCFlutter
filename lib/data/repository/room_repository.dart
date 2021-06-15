import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_webrtc_pion/domain/repository/room_repository.dart';
import 'package:flutter_webrtc_pion/internal/config.dart';

class RoomRepo extends RoomRepository {

  @override
  Future<dynamic> getAll() async {
    Dio dio = new Dio();
    dynamic jsonResponse;
    try {
      print(Config.url + "/api/rooms");
      var apiRes = await dio.get(
          Config.url + "/api/rooms",
          options: Options(
              headers: {
                "Authorization": "Bearer " + Config.token
              }
          )
      );
      jsonResponse = jsonDecode(apiRes.toString());
    } on DioError catch (e) {
      if (e.response != null) {
        jsonResponse = e.response.data;
      } else {
        print(e);
      }
    }
    return jsonResponse;
  }

}
