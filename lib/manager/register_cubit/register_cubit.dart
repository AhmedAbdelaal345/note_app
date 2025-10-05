import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:note_app/manager/login_cubit/login_state.dart';
import 'package:note_app/utils/app_constants.dart';

class RegisterCubit extends Cubit<LoginState> {
  RegisterCubit() : super(InitState());
  UserCredential ?credential;
  
  void userRegister(String email, String password) async {
    emit(LoadingState());
    try {
     credential= await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(SucessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(ErrorState(errorMessage: "The password provided is too weak."));
      } else if (e.code == 'email-already-in-use') {
        emit(
          ErrorState(
            errorMessage: "The account already exists for that email.",
          ),
        );
      } else {
        emit(ErrorState(errorMessage: e.message.toString()));
      }
    } catch (e) {
      emit(ErrorState(errorMessage: e.toString()));
    }
  }

  void registerInWithGoogle() async {
    emit(LoadingState());
    try {
      await GoogleSignIn.instance.initialize(
        serverClientId:
            '887018026031-gq1jmh1t64g9orpumb55o22idkrvmcmk.apps.googleusercontent.com',
      );

      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(SucessState());
    } on GoogleSignInException catch (e) {
      emit(ErrorState(errorMessage: e.description ?? "Google Sign In failed"));
    } on FirebaseAuthException catch (e) {
      emit(ErrorState(errorMessage: e.message ?? "Authentication failed"));
    } catch (e) {
      emit(ErrorState(errorMessage: e.toString()));
    }
  }

  void addUserToFirestore(String email, String uid, String password) async {
    try {
      await FirebaseFirestore.instance
          .collection(AppConstants.users)
          .doc(uid)
          .set({
            AppConstants.email: email,
            AppConstants.password: password,
            AppConstants.uid: uid,
          }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      emit(ErrorState(errorMessage: e.message.toString()));
    } catch (e) {
      emit(ErrorState(errorMessage: e.toString()));
    }
  }
}
