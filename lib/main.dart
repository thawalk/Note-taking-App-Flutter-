import 'package:flutter/material.dart';
import 'views/note_list.dart';

void main() => runApp(App());

class App extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Notes',
      home: NoteList(),

    );
  }
}

