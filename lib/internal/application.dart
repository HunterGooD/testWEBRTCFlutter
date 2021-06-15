import 'package:flutter/material.dart';
import 'package:flutter_webrtc_pion/presentation/Authorization.dart';
import 'package:flutter_webrtc_pion/presentation/Home.dart';

import 'config.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter camera',
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: Config.loginRoute,
        routes: {
          Config.loginRoute: (context) => Authorization(),
          Config.homeRoute: (context) => Home(),
          Config.roomRoute: (context) => Authorization(),
          Config.roomJoinRoute: (context) => Authorization(),
        });
  }
}