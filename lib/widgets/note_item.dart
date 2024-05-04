import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logs/models/note.dart';
import 'package:logs/utils/notification_sender.dart';
import 'package:logs/widgets/note_details_dialog.dart';
import 'package:logs/widgets/note_dialog_form.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({
    super.key,
    required this.note,
    required this.onUpdateNoteList
  });

  final Note note;
  final Function() onUpdateNoteList;



  @override
  Widget build(BuildContext context) {

    void openNoteFormDialog(){
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))
          ),
          builder: (ctx) => NoteDialogForm(
            mode: Mode.update,
            note: note,
            onUpdateNote: onUpdateNoteList,
          )
      );
    }

    void openNoteDetailsDialog(){
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))
          ),
          builder: (ctx) => NoteDetailsDialog(note: note)
      );
    }

    return GestureDetector(
      onTap: openNoteDetailsDialog,
      child: Card(
        margin: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 15
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 20
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                      note.title!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16
                      )
                  ),
                  const Spacer(),
                  FirebaseAuth.instance.currentUser?.uid == note.uid ? TextButton.icon(
                      onPressed: openNoteFormDialog,
                      label: const Text('Edit'),
                      icon: const Icon(Icons.edit_rounded,
                          size: 16)
                  ) : Container()
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text(note.description!),
                  const Spacer(),
                  TextButton.icon(
                      onPressed: NotificationSender().showNotification,
                      label: const Text('Notify'),
                      icon: const Icon(
                        Icons.notifications, size: 16)
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
