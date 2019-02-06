import 'package:flutter/material.dart';
import './screens/note_list.dart';
import './screens/note_detail.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blueAccent
      ),
      home: NoteList(),
    );
  }
}
