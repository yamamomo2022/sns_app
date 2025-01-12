import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sns_app/lobby_page.dart';
import 'package:sns_app/post.dart';

import 'firebase_options.dart';
import 'next_page.dart'; // Add this line
import 'update_page.dart'; // Add this line

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final isLogin = FirebaseAuth.instance.currentUser != null;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLogin ? const MyHomePage(title: 'Home Page') : const lobbyPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    _fetchFirebaseData();
  }

  Future<void> _fetchFirebaseData() async {
    await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('createAt', descending: true)
        .get()
        .then((event) {
      final docs = event.docs;
      setState(() {
        posts = docs.map(
          (doc) {
            final data = doc.data();
            final id = doc.id;
            final text = data['text'];
            final createAt = data['createAt']?.toDate();
            final updateAt = data['updateAt']?.toDate();
            return Post(
                id: id, text: text, createAt: createAt, updateAt: updateAt);
          },
        ).toList();
      });
    });
  }

  Future _delete(post) async {
    await FirebaseFirestore.instance.collection('posts').doc(post.id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            //logout Bottom
            IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) {
                  return const lobbyPage();
                }), (route) => false);
              },
              icon: Icon(Icons.logout),
            ),
          ]),
      // body: Center(
      //   child: ListView.builder(itemCount: _firebaseDataList.length, itemBuilder: (context, index) {
      //     return ListTile(
      //       title: Text(_firebaseDataList[index]),
      //     );
      //   }),
      // ),
      body: Center(
        child: ListView(
            children: posts
                .map((post) => ListTile(
                    onTap: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UpdatePage(post)));
                      _fetchFirebaseData();
                    },
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1.0),
                      child: Row(
                        children: [
                          Icon(Icons.person,
                              color: Theme.of(context).colorScheme.primary,
                              size: 48),
                          Text(post.text,
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          Spacer(),
                          IconButton(
                              onPressed: () async {
                                await _delete(post);
                                await _fetchFirebaseData();
                              },
                              icon: Icon(Icons.delete))
                        ],
                      ),
                    )))
                .toList()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const AddPage()));
          _fetchFirebaseData();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
