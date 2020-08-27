import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      body: _buildBody(context, auth),
    );
  }

  Widget _buildBody(BuildContext context, AuthResult auth) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('lang').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return LinearProgressIndicator();
          default:
            return GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              shrinkWrap: true,
              children: snapshot.data.documents.map((document) {
                return Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      border: Border.all(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: GridTile(
                        header: Center(
                          child: RichText(
                            text: TextSpan(
                                text: document.data["name"],
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                          ),
                        ),
                        child: GestureDetector(
                            onTap: () {
                              var channel = document.data["name"];

                              var snackBar = SnackBar(
                                  content: Text(
                                      "Hello! Welocome to $channel channel"));
                              Scaffold.of(context).showSnackBar(snackBar);

                              final record = Room.fromSnapshot(document);
                              record.reference.updateData(
                                  {'members': FieldValue.increment(1)});

                              Future.delayed(new Duration(seconds: 2)).then(
                                  (value) => Navigator.of(context)
                                          .pushNamed('/chatroom', arguments: {
                                        "auth": auth,
                                        "room": channel
                                      }));
                            },
                            child: Container(
                                child: document.data["logo"] != null
                                    ? Image.network(document.data["logo"])
                                    : Icon(Icons.chat_outlined))),
                        footer: Center(
                          child: RichText(
                            text: TextSpan(
                                text: "member: " +
                                    document.data["members"].toString(),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold)),
                          ),
                        )));
              }).toList(),
            );
        }
      },
    );
  }
}

class Room {
  final String name;
  final int members;
  final DocumentReference reference;

  Room.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['members'] != null),
        name = map['name'],
        members = map['members'];

  Room.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$members>";
}
