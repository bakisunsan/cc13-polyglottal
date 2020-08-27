import 'package:flutter/material.dart';
import './signIn.dart';
import './vote.dart';
import './chat.dart';
import './chatroom.dart';

void main() => runApp(
      MaterialApp(
        initialRoute: '/signIn',
        routes: <String, WidgetBuilder>{
          '/signIn': (BuildContext context) => MySignInPage(),
          '/vote': (BuildContext context) => MyVotePage(),
          '/chat': (BuildContext context) => MyChatPage(),
          '/chatroom': (BuildContext context) => MyChatRoomPage(),
        },
      ),
    );
