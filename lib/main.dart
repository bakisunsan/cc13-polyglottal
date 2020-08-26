import 'package:flutter/material.dart';
import './vote.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your Favorite Programming Language',
      home: MyVotePage(),
    );
  }
}
