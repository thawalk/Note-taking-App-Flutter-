import 'package:flutter/material.dart';
import 'package:flutter_app/providers/note_provider.dart';

enum NoteMode { Editing, Adding }

class Note extends StatefulWidget {
  final NoteMode noteMode;
  final Map<String, dynamic> note;

  Note(this.noteMode, this.note);

  @override
  NoteState createState() {
    return new NoteState();
  }
}

class NoteState extends State<Note> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  //List<Map<String, String>> get _notes => NoteInheritedWidget.of(context).notes;

  @override
  void didChangeDependencies() {
    if (widget.noteMode == NoteMode.Editing) {
      _titleController.text = widget.note['title']; //to show the current saved data in the fields before editing
      _textController.text = widget.note['text'];
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.noteMode == NoteMode.Adding ? 'Add note' : 'Edit note'), //ternary operation to display editing or adding in the appbar
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(hintText: 'Note title'),
            ),
            Container(
              height: 8,
            ),
            TextField(
              controller: _textController,
              decoration: InputDecoration(hintText: 'Note text'),
            ),
            Container(
              height: 16.0, //to add a gap between the title and text field
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // to space out the buttons underneath the text fields evenly
              children: <Widget>[
                _NoteButton('Save', Colors.blue, () {
                  final title = _titleController.text;
                  final text = _textController.text;

                  if (widget?.noteMode == NoteMode.Adding) {
                    NoteProvider.insertNote({'title': title, 'text': text}); //use the db method made in the note_provider to insert the data of the new note
                  } else if (widget?.noteMode == NoteMode.Editing) {
                    NoteProvider.updateNote({ //use the db method made in note_provider to update the changes
                      'id': widget.note['id'],
                      'title': _titleController.text,
                      'text': _textController.text,
                    });
                  }

                  Navigator.pop(context);
                }),
                Container(
                  height: 16.0,
                ),
                _NoteButton('Discard', Colors.grey, () {
                  Navigator.pop(context);
                }),
                widget.noteMode == NoteMode.Editing
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: _NoteButton('Delete', Colors.red, () async {
                          await NoteProvider.deleteNote(widget.note['id']);
                          Navigator.pop(context);
                        }),
                      )
                    : Container()
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _NoteButton extends StatelessWidget {
  final String _text;
  final Color _color;
  final Function _onPressed;

  _NoteButton(this._text, this._color, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: _onPressed,
      child: Text(
        _text,
        style: TextStyle(color: Colors.white),
      ),
      height: 40,
      minWidth: 100,
      color: _color,
    );
  }
}
