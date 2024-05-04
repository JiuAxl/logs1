import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logs/models/note.dart';
import 'package:logs/widgets/note_dialog_form.dart';
import 'package:logs/widgets/note_list.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  List<Note> _notes = [];

  Future<void> fetchNotes() async {
    _notes.clear();
    _notes = await Note().getNotes();
  }

  void _refreshList(){
    setState(() {

    });
  }

  void _removeNote(String id) async {
    await Note(noteId: id).deleteNote();
    _refreshList();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text("Note Deleted!"),
        )
    );
  }

  void _openNoteDialog(){
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
        ),
        builder: (ctx) => NoteDialogForm(
          mode: Mode.create,
          onAddNote: _refreshList,
        )
    );
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchNotes(),
        builder: (ctx, snapshot) {
          Widget body;
          if (snapshot.connectionState == ConnectionState.waiting) {
            body = const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            body = Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Widget mainContent = Container(
              width: double.infinity,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'OOPS!',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize:  50
                    ),
                  ),
                  SizedBox(height:  5),
                  Text(
                      'There are no available notes found. Try adding some!'
                  )
                ],
              ),
            );

            if (_notes.isNotEmpty) {
              mainContent = NoteList(
                notes: _notes,
                onUpdateNoteList: _refreshList,
                onRemoveNote: _removeNote
              );
            }

            body = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height:  10),
                _notes.isNotEmpty ? const Padding(
                  padding: EdgeInsets.only(left:  15, top:  5, bottom:  5),
                  child: Text(
                    'Notes',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize:  23
                    ),
                  ),
                ) : const SizedBox.shrink(),
                Expanded(child: mainContent),
              ],
            );
          }

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text(
                'logs.',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize:  24
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    icon: const Icon(
                      Icons.logout,
                      size:  25,
                    )
                )
              ],
            ),
            body: body,
            floatingActionButton: FloatingActionButton(
              onPressed: _openNoteDialog,
              child: const Icon(Icons.add),
            ),
          );
        }
    );
  }
}
