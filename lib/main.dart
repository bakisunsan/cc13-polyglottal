import 'package:flutter/material.dart';
import './signIn.dart';
import './vote.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your Favorite Programming Language',
      home: MySignInPage(),
    );
  }
}
