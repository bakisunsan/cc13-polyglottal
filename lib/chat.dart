import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyChatPage extends StatefulWidget {
  @override
  _MyChatPageState createState() {
    return _MyChatPageState();
  }
}

class _MyChatPageState extends State<MyChatPage> {
  @override
  Widget build(BuildContext context) {
    final AuthResult auth = ModalRoute.of(context).settings.arguments;
    print("chat");
    print(auth);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Talk about langs'),
      ),
      body: const Center(
        child: Text(
          'This is the chat page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
