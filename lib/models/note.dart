import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:logs/firebase_options.dart';
import 'package:logs/models/mixins/display_mixin.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;
final CollectionReference notes = FirebaseFirestore.instance.collection('notes');

class Note with DisplayMixin{
  Note({
    this.title,
    this.description,
    this.context,
    this.noteId,
    this.uid,
    this.audioPath,
    this.platform,
  });

  final String? title;
  final String? description;
  final BuildContext? context;
  final String? noteId;
  final String? uid;
  final String? platform;
  final String? audioPath;

  factory Note.fromMap(Map<String, dynamic> data, id){
    return Note(
      title: data['title'],
      description: data['description'],
      uid: data['uid'],
      platform: data['platform'],
      audioPath: data['path'],
      noteId: id
    );
  }


  Future<void> addNote() async {
    try {
      await notes.add({
        'title': title,
        'description': description,
        'uid': _firebase.currentUser?.uid,
        'path': audioPath,
        'platform': getPlatform()
      });
    } on FirebaseException catch (e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future<void> updateNote() async {
    try {
      await notes.doc(noteId).update({
        'title': title,
        'description': description,
        'platform': getPlatform(),
        'path': audioPath
      });
    } on FirebaseException catch (e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future<void> deleteNote() async {
    try {
      await notes.doc(noteId).delete();
    } on FirebaseException catch (e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future<List<Note>> getNotes() async {
    QuerySnapshot querySnapshot = await notes.get();
    final allNotes = querySnapshot.docs.map((doc) => Note.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return allNotes;
  }

  String getPlatform() {
    if (kIsWeb) {
      return 'Web';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return 'Android';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'iOS';
    } else if (defaultTargetPlatform == TargetPlatform.linux) {
      return 'Linux';
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      return 'macOS';
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      return 'Windows';
    } else {
      return 'Unidentified';
    }
  }

}