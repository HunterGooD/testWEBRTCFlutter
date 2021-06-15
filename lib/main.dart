import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:core';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/status.dart' as status;

import 'internal/application.dart';
import 'internal/config.dart';

void main() {
  Config.url = "http://10.0.2.2:8080";
  runApp(Application());
}
//
// class GetUserMediaSample extends StatefulWidget {
//   static String tag = 'WEBRTC';
//
//   @override
//   _GetUserMediaSampleState createState() => new _GetUserMediaSampleState();
// }
//
// class _GetUserMediaSampleState extends State<GetUserMediaSample> {
//   MediaStream _localStream;
//   final _localRenderer = new RTCVideoRenderer();
//   List _remoteRenders = [];
//   bool _inCalling = false;
//
//   IOWebSocketChannel _websocket;
//   RTCPeerConnection _peerConnection;
//
//   @override
//   initState() {
//     super.initState();
//     initRenderers();
//   }
//
//   @override
//   deactivate() {
//     super.deactivate();
//     if (_inCalling) {
//       _hangUp();
//     }
//   }
//
//   initRenderers() async {
//     await _localRenderer.initialize();
//   }
//
//   // Future<void> _connect() async {
//   //
//   //
//   // }
//
//   // Platform messages are asynchronous, so we initialize in an async method.
//   _makeCall() async {
//
//     // _connect();
//     final Map<String, dynamic> mediaConstraints = {
//       "audio": true,
//       "video": {
//         "mandatory": {
//           "minWidth": '640',
//           // Provide your own width, height and frame rate here
//           "minHeight": '480',
//           "minFrameRate": '30',
//         },
//         "facingMode": "user",
//         "optional": [],
//       }
//     };
//
//     try {
//       navigator.mediaDevices.getUserMedia(mediaConstraints).then((stream) {
//         _localStream = stream;
//         _localRenderer.srcObject = _localStream;
//       });
//
//       _peerConnection = await createPeerConnection({}, {});
//       _localStream.getTracks().forEach((track) async {
//         await _peerConnection.addTrack(track, _localStream);
//       });
//
//       _peerConnection.onIceCandidate = (candidate) {
//         if (candidate == null) {
//           return;
//         }
//
//         print("JSON ICE:\n\n");
//         print(JsonEncoder().convert({
//           "event": "candidate",
//           "data": JsonEncoder().convert({
//             'sdpMLineIndex': candidate.sdpMlineIndex,
//             'sdpMid': candidate.sdpMid,
//             'candidate': candidate.candidate,
//           })
//         }));
//         print("JSON ICE END\n\n\n");
//
//         _websocket.sink.add(JsonEncoder().convert({
//           "event": "candidate",
//           "data": JsonEncoder().convert({
//             'sdpMLineIndex': candidate.sdpMlineIndex,
//             'sdpMid': candidate.sdpMid,
//             'candidate': candidate.candidate,
//           })
//         }));
//       };
//
//       _peerConnection.onTrack = (event) async {
//         if (event.track.kind == 'video' && event.streams.isNotEmpty) {
//           var renderer = RTCVideoRenderer();
//           await renderer.initialize();
//           renderer.srcObject = event.streams[0];
//           setState(() { _remoteRenders.add(renderer); });
//         }
//       };
//
//
//       _peerConnection.onRemoveStream = (stream) {
//         var rendererToRemove;
//         var newRenderList = [];
//
//         // Filter existing renderers for the stream that has been stopped
//         _remoteRenders.forEach((r) {
//           if (r.srcObject.id == stream.id) {
//             rendererToRemove = r;
//           } else {
//             newRenderList.add(r);
//           }
//         });
//
//         // Set the new renderer list
//         setState(() { _remoteRenders = newRenderList; });
//
//         // Dispose the renderer we are done with
//         if (rendererToRemove != null) {
//           rendererToRemove.dispose();
//         }
//       };
//
//       _websocket = IOWebSocketChannel.connect('ws://10.0.2.2:8080/websocket');
//       _websocket.stream.listen((raw) async {
//         Map<String, dynamic> msg = jsonDecode(raw);
//         // print("MESSAGES:\n\n");
//         // print(msg);
//         // print("END:\n\n");
//         switch (msg['event']) {
//           case 'candidate':
//             Map<String, dynamic> parsed = jsonDecode(msg['data']);
//             print("PARSED:\n\n");
//             print(parsed);
//             print("END:\n\n");
//             _peerConnection
//                 .addCandidate(RTCIceCandidate(parsed['candidate'], "", 0));
//             return;
//           case 'offer':
//             Map<String, dynamic> offer = jsonDecode(msg['data']);
//             // SetRemoteDescription and create answer
//             await _peerConnection.setRemoteDescription(
//                 RTCSessionDescription(offer['sdp'], offer['type']));
//             RTCSessionDescription answer = await _peerConnection.createAnswer({});
//             await _peerConnection.setLocalDescription(answer);
//
//             // Send answer over WebSocket
//             _websocket.sink.add(JsonEncoder().convert({
//               'event': 'answer',
//               'data':
//               JsonEncoder().convert({'type': answer.type, 'sdp': answer.sdp})
//             }));
//             return;
//         }
//       }, onDone: () {
//         print('Closed by server!');
//       });
//     } catch (e) {
//       print("1" + e.toString());
//     }
//     if (!mounted) return;
//
//     setState(() {
//       _inCalling = true;
//     });
//   }
//
//   _hangUp() async {
//     try {
//       await _localStream.dispose();
//       _localRenderer.srcObject = null;
//       _peerConnection = null;
//       _websocket.sink.close(status.goingAway);
//       _remoteRenders = [];
//     } catch (e) {
//       print(e.toString());
//     }
//     setState(() {
//       _inCalling = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'sfu-ws',
//         home: new Scaffold(
//           appBar: new AppBar(
//             title: new Text('GetUserMedia API Test'),
//           ),
//           body: Column(
//             children: [
//               Center(
//                 child: Container(
//                   margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
//                   width: 120,
//                   height: 300,
//                   child: RTCVideoView(_localRenderer),
//                   decoration: new BoxDecoration(color: Colors.black54),
//                 ),
//               ),
//               Row(
//                 children: [
//                   ..._remoteRenders.map((e) =>
//                       Container(
//                         margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
//                         width: 100,
//                         height: 150,
//                         child: RTCVideoView(e),
//                         decoration: new BoxDecoration(color: Colors.black54),
//                       ),).toList()
//                 ],
//               )
//             ],
//           ),
//           floatingActionButton: new FloatingActionButton(
//             onPressed: _inCalling ? _hangUp : _makeCall,
//             tooltip: _inCalling ? 'Hangup' : 'Call',
//             child: Icon(_inCalling ? Icons.call_end : Icons.phone),
//           ),
//         ));
//   }
// }
