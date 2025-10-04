import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/cubit/login_cubit.dart';
import 'package:note_app/cubit/register_cubit.dart';
import 'package:note_app/pages/create_note_page.dart';
import 'package:note_app/pages/login_page.dart';
import 'package:note_app/pages/notes_details_page.dart';
import 'package:note_app/pages/register_page.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
      ],

      child: MaterialApp(
        title: 'Notes APP',
        routes: {
          ShowNotesPage.id: (context) => const ShowNotesPage(),
          NotesDetailsPage.id: (context) => const NotesDetailsPage(),
          CreateNotePage.id: (context) => const CreateNotePage(),
          RegisterPage.id: (context) => const RegisterPage(),
        },
        home: LoginPage(),
      ),
    );
  }
}
