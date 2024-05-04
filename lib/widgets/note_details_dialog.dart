import 'package:flutter/material.dart';
import 'package:logs/models/note.dart';

class NoteDetailsDialog extends StatelessWidget {
  const NoteDetailsDialog({
    super.key,
    required this.note
  });

  final Note note;

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Note Details',
                          style: TextStyle(
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
                    const SizedBox(height: 10,),
                    Text(
                      note.title!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18
                      ),
                    ),
                    Text(note.description!),
                    Text('Platform Used: ${note.platform!}'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: (){},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20)
                      ),
                      child: const Text('Notify'),
                    )
                  ],
                )
            ),
          )
      ),
    );
  }
}
