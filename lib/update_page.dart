import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sns_app/post.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage(this.post, {super.key});

  final Post post;

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  String _updateText = '';

  Future<void> _updateFirebasedata() async {
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.post.id)
        .update({
      'name': 'Flutter2',
      'text': _updateText,
      'updateAt': DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Page"),
      ),
      body: Column(children: [
        TextField(
            controller: TextEditingController(text: widget.post.text),
            onChanged: (value) {
              setState(() {
                _updateText = value;
              });
            }),
        ElevatedButton(
          onPressed: _updateText.isEmpty
              ? null
              : () {
                  _updateFirebasedata();
                  Navigator.pop(context);
                },
          child: Text("Update"),
        )
      ]),
    );
  }
}
