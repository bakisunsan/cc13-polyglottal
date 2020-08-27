import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

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
      body: Container(
          child: Stack(children: [
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('chat').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');

            if (snapshot.data == null ||
                snapshot.data.documents == null ||
                snapshot.data.documents.length < 1) {
              return Text("No discussion here, please start!");
            }

            Iterable<DocumentSnapshot> roomMessages =
                snapshot.data.documents.where((a) => a.data["room"] == room);

            var msgList = roomMessages.toList();
            msgList.sort(
                (a, b) => a.data["postedAt"].compareTo(b.data["postedAt"]));
            var rvsdList = msgList.reversed.toList();

            return ListView(
              padding: const EdgeInsets.only(top: 20.0),
              children:
                  rvsdList.map((doc) => _buildListItem(doc.data)).toList(),
            );
          },
        )
      ])),
    );
  }
}

Widget _buildListItem(Map<String, dynamic> item) {
  String message = item["message"];
  String user = item["sendBy"].split("@")[0];
  DateTime postedAt = item["postedAt"].toDate();

// user + "\n" + DateFormat('MM/dd/yyyy HH:mm').format(postedAt)
  return Padding(
    key: ValueKey(message),
    padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
    child: Container(
        decoration: BoxDecoration(),
        child: ListTile(
          title: Text(message),
          trailing: RichText(
            text: TextSpan(
                text: user +
                    "\n" +
                    DateFormat('MM/dd/yyyy HH:mm').format(postedAt),
                style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
        )),
  );
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
