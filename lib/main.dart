import 'package:flutter/material.dart';
import 'package:note_app/pages/create_note_page.dart';
import 'package:note_app/pages/notes_details_page.dart';
import 'package:note_app/pages/show_notes_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes APP',
      routes: {ShowNotesPage.id: (context) => const ShowNotesPage(),NotesDetailsPage.id:(context)=> const NotesDetailsPage()},
      home: CreateNotePage(),
    );
  }
}
