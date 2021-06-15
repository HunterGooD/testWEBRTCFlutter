import 'package:flutter_webrtc_pion/data/repository/room_repository.dart';

abstract class RoomState {
  RoomState(RoomRepo roomRepository) {
    _roomRepository = roomRepository;
  }

  RoomRepo _roomRepository;

  Future<dynamic> getAll(
      {String login, String password}) async {
    final data = await _roomRepository.getAll();
    return data;
  }
}
