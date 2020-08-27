import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyVotePage extends StatefulWidget {
  @override
  _MyVotePageState createState() {
    return _MyVotePageState();
  }
}

class _MyVotePageState extends State<MyVotePage> {
  @override
  Widget build(BuildContext context) {
    final AuthResult auth = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Favorite Lang'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.control_point_outlined),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return _buildAddLangDialog();
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return _buildResultDialog();
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            tooltip: 'Next page',
            onPressed: () {
              Navigator.of(context).pushNamed('/chat', arguments: auth);
            },
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildAddLangDialog() {
    String newLang = "";
    return AlertDialog(
      title: Center(child: Text("Add New Language")),
      content: SingleChildScrollView(
        child: Row(
          children: <Widget>[
            Expanded(
                child: new TextField(
              autofocus: true,
              decoration: new InputDecoration(
                  labelText: 'name', hintText: 'new language name'),
              onChanged: (value) {
                newLang = value;
              },
            )),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
            child: Text("Cancel"), onPressed: () => Navigator.pop(context)),
        FlatButton(
            child: Text("OK"), onPressed: () => _addNewLanguage(newLang)),
      ],
    );
  }

  void _addNewLanguage(String name) {
    if (name.isNotEmpty) {
      Firestore.instance
          .collection('lang')
          .add({"name": name, "votes": 0, "members": 0});
      Navigator.pop(context);
    }
  }

  Widget _buildResultDialog() {
    return AlertDialog(
      title: Center(child: Text("Votes Result")),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Center(child: Text("🎉🎉🎉Winner is Dart🎉🎉🎉")),
            Center(child: Image.asset('images/dart_logo.png')),
            Center(child: Text("🎉🎉🎉Winner is Dart🎉🎉🎉")),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("OK"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
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
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.name),
          trailing: Text(record.votes.toString()),
          onTap: () =>
              record.reference.updateData({'votes': FieldValue.increment(1)}),
        ),
      ),
    );
  }
}

class Record {
  final String name;
  final int votes;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['votes'] != null),
        name = map['name'],
        votes = map['votes'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$votes>";
}
