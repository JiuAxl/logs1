import 'package:flutter/material.dart';
import 'package:logs/models/note.dart';

enum Mode {update, create}

class NoteDialogForm extends StatefulWidget {
  const NoteDialogForm({
    super.key,
    this.onAddNote,
    this.onUpdateNote,
    this.mode,
    this.note
  });

  final void Function()? onAddNote;
  final void Function()? onUpdateNote;
  final Mode? mode;
  final Note? note;

  @override
  State<NoteDialogForm> createState() => _NoteDialogFormState();
}

class _NoteDialogFormState extends State<NoteDialogForm> {
  final _form = GlobalKey<FormState>();
  final noteTitleController = TextEditingController();
  final noteDescriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.note != null){
      noteTitleController.text = widget.note!.title!;
      noteDescriptionController.text = widget.note!.description!;
    }

  }

  void addNote(Note note) async{
    await note.addNote();
    widget.onAddNote!();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 2),
      content: Text("Note Added!"),
    ));
  }

  void updateNote(Note note) async{
    await note.updateNote();
    widget.onUpdateNote!();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 2),
      content: Text("Note Updated!"),
    ));
  }

  void submitNote(){
    final isValid = _form.currentState!.validate();
    if(!isValid){
      return;
    }
    _form.currentState!.save();
    if (widget.mode == Mode.create) {
      addNote(
        Note(
          title: noteTitleController.text,
          description: noteDescriptionController.text
        )
      );
    } else {
      updateNote(
        Note(
          title: noteTitleController.text,
          description: noteDescriptionController.text,
          noteId: widget.note!.noteId!
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                  bottom: 30
              ),
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.mode == Mode.create
                              ? 'Add Note'
                              : 'Update Note',
                          style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20
                          ),
                        ),
                        IconButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close_rounded))
                      ],
                    ),
                    const SizedBox(height: 25),
                    const Text('Title:', style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextFormField(
                      validator: (value){
                        if (value!.trim().isEmpty || value == null ){
                          return 'Title must not be empty';
                        }
                        return null;
                      },
                      controller: noteTitleController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.note),
                          hintText: 'Enter Note Title'
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text('Genre:', style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextFormField(
                      validator: (value){
                        if (value!.trim().isEmpty || value == null ){
                          return 'Description must not be empty';
                        }
                        return null;
                      },
                      controller: noteDescriptionController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.notes_outlined),
                          hintText: 'Enter Note Description'
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffeddaf3),
                                  padding: const EdgeInsets.symmetric(vertical: 19)
                              ),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xff8e3ba9)
                                  )
                              )
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 19)
                              ),
                              onPressed: submitNote,
                              child: const Text(
                                  'Save',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                  )
                              )
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}
