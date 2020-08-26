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
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('lang').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final room = Room.fromSnapshot(data);

    return Padding(
      key: ValueKey(room.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
            title: Text("#" + room.name),
            trailing: Text("member: " + room.members.toString()),
            onTap: () =>
                // TODO
                print("taped!")),
      ),
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
