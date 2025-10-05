import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/pages/create_note_page.dart';
import 'package:note_app/pages/login_page.dart';

class AuthCubit extends Cubit<Widget> {
  AuthCubit() : super(SizedBox());

  void userLogedIn() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        emit(LoginPage());
        print('User is currently signed out!');
      } else {
        emit(CreateNotePage());
        print('User is signed in!');
      }
    });
  }
}
