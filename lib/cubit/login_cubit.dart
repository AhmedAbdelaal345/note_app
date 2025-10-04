import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/cubit/login_state.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(InitState());
  void loginUser(String email, String password) async {
    emit(LoadingState());
    try {
      FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(SucessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(ErrorState(errorMessage: "No user found for that email."));
      } else if (e.code == 'wrong-password') {
        emit(
          ErrorState(errorMessage: "Wrong password provided for that user."),
        );
      } else {
        emit(ErrorState(errorMessage: e.message.toString()));
      }
    } catch (e) {
      emit(ErrorState(errorMessage: e.toString()));
    }
  }

void loginInWithGoogle() async {
  emit(LoadingState());
  try {
    // Initialize GoogleSignIn with your configuration
    await GoogleSignIn.instance.initialize(
      serverClientId: '887018026031-gq1jmh1t64g9orpumb55o22idkrvmcmk.apps.googleusercontent.com',
    );
    
    final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();
    
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    
    await FirebaseAuth.instance.signInWithCredential(credential);
    emit(SucessState());
  } on GoogleSignInException catch (e) {
    emit(ErrorState(errorMessage: e.description ?? "Google Sign In failed"));
    print(e);
  } on FirebaseAuthException catch (e) {
    emit(ErrorState(errorMessage: e.message ?? "Authentication failed"));
    print(e);
  } catch (e) {
    emit(ErrorState(errorMessage: e.toString()));
    print(e);
  }
}
}