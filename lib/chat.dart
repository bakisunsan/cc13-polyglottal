import 'package:flutter/material.dart';

class MyChatPage extends StatefulWidget {
  @override
  _MyChatPageState createState() {
    return _MyChatPageState();
  }
}

class _MyChatPageState extends State<MyChatPage> {
  @override
  Widget build(BuildContext context) {
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
