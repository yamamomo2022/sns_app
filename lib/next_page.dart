import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String _text = '';

  Future<void> _addFirebasedata() async {
    await FirebaseFirestore.instance.collection("posts").add(
        {
          'name': 'Flutter',
          'text': _text,
          'createAt': DateTime.now(),
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children:[
          TextField(
            onChanged: (value) {
              print(value);
              _text = value;
            }
          ),
          ElevatedButton(
              onPressed: () {
                _addFirebasedata()  ;
                Navigator.pop(context);
          } ,
          child: Text("add"),
          )
        ]
      ),
    );
  }
}
