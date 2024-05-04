import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logs/models/note.dart';
import 'package:logs/widgets/note_item.dart';

class NoteList extends StatelessWidget {
  const NoteList({
    super.key,
    required this.notes,
    required this.onUpdateNoteList,
    required this.onRemoveNote
  });

  final void Function(String id) onRemoveNote;
  final List<Note> notes;
  final Function() onUpdateNoteList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (ctx, index) =>
            Dismissible(
                confirmDismiss: (direction) async {
                  if (FirebaseAuth.instance.currentUser?.uid != notes[index].uid){
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text("Deletion Prohibited! You cannot delete someone's notes"),
                        ));
                    return false;
                  }
                  else{
                    return true;
                  }
                },
                background: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Theme.of(context).colorScheme.error.withOpacity(0.85),
                  ),

                  margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16

                  ),

                ),
                key: ValueKey(notes[index]),
                onDismissed: (direction){
                  onRemoveNote(notes[index].noteId!);
                },
                child: NoteItem(
                  note: notes[index],
                  onUpdateNoteList: onUpdateNoteList
                )
            )
    );
  }
}
