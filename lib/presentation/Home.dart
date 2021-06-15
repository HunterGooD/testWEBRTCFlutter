import 'package:flutter/material.dart';
import 'package:flutter_webrtc_pion/data/repository/room_repository.dart';
import 'package:flutter_webrtc_pion/domain/state/room/main_room_state.dart';
import 'package:flutter_webrtc_pion/domain/state/room/room_state.dart';
import 'package:flutter_webrtc_pion/internal/config.dart';

import 'DialogMessage.dart';

class Home extends StatefulWidget {
  RoomState roomState;

  Home({Key key}) : super(key: key) {
    roomState = new MainRoomState(new RoomRepo());
  }

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey _keyLoader = new GlobalKey();
  List rooms;

  @override
  void initState() {
    super.initState();
    _getRooms();
  }

  _getRooms() async {
    var res =  await widget.roomState.getAll();
    if( res["rooms"] != null ){
      setState(() {
        rooms = res["rooms"];
      });
    } else if (res["error"]) {
      DialogMessage.showMyDialog(
          context, "Ошибка сервера", "Ошибка. ${res['error']}", "Повтор");
    } else {
      DialogMessage.showMyDialog(
          context, "Ошибка", "Проверьте интеренет соединение", "Ок");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Webrtc Test'),
          actions: [
            Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(Config.fio != null ? Config.fio : "")),
            IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () {
                  Config.token = "";
                  Navigator.pushNamedAndRemoveUntil(
                      context, Config.loginRoute, (route) => false);
                }),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            ...rooms.map((e) => _createCard(titleCard: e["Name"], password: e["Password"])).toList(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: null, //TODO: в дальнейшем создание комнаты
        ));
  }

  Widget _createCard({String titleCard = "Null", password = ""}) {
    return Container(
        width: double.maxFinite,
        child: GestureDetector(
          // onTap: _openRoom(title: titleCard),
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.group, size: 45),
                  title: Text("$titleCard"),
                  subtitle: password == "" ? Text("Без пароля") : Text("Для входа требуется пароль"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Войти в комнату"),
                    IconButton(onPressed: () => _openRoom(title: titleCard), icon: Icon(Icons.input))
                  ],
                )
              ],
            ),

          ),
        ));
  }

  _openRoom({String title}) {
    print(title);
  }
}
