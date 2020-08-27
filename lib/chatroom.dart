import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyChatRoomPage extends StatefulWidget {
  @override
  _MyChatRoomPageState createState() {
    return _MyChatRoomPageState();
  }
}

class _MyChatRoomPageState extends State<MyChatRoomPage> {
  @override
  Widget build(BuildContext context) {
    Args arg = ModalRoute.of(context).settings.arguments;
    String user = arg.auth.user.email;
    String room = arg.room;
    print("chatroom");
    print(user);
    print(room);

    return Scaffold(
      appBar: AppBar(
        title: Text(room + " Chat room"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return _buildUserDialog(user);
                },
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('chat').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');

          Iterable<DocumentSnapshot> roomMessages =
              snapshot.data.documents.where((a) => a.data["room"] == room);

          if (roomMessages.length < 1) {
            return Text("No discussion here, please start!");
          }

          var msgList = roomMessages.toList();
          msgList
              .sort((a, b) => a.data["postedAt"].compareTo(b.data["postedAt"]));
          var rvsdList = msgList.reversed.toList();

          return ListView(
            padding: const EdgeInsets.only(top: 20.0),
            children: rvsdList.map((doc) => _buildListItem(doc.data)).toList(),
          );
        },
      ),
    );
  }
}

Widget _buildListItem(Map<String, dynamic> item) {
  return Text(item["message"]);
}

Widget _buildUserDialog(String user) {
  return AlertDialog(
      title: Center(child: Text("Login User info")),
      content: SingleChildScrollView(child: Text(user)));
}

class Args {
  AuthResult auth;
  String room;

  Args(this.auth, this.room);
}
