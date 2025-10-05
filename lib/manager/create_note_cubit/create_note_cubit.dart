import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/manager/create_note_cubit/create_note_state.dart';
import 'package:note_app/utils/app_constants.dart';

class CreateNoteCubit extends Cubit<CreateNoteState> {
  CreateNoteCubit() : super(InitState());
  int counter = 0;
  var user = FirebaseFirestore.instance.collection(AppConstants.users);
  Future<QuerySnapshot<Map<String, dynamic>>>? todos;
  Future<DocumentSnapshot<Map<String, dynamic>>>? noteDetails;
  void addTodos(String uid, String title, String content) {
    emit(LoadingState());

    try {
      user
          .doc(uid)
          .collection(AppConstants.collectionName)
          .doc(counter.toString())
          .set({
            AppConstants.title: title,
            AppConstants.content: content,
            AppConstants.createdAt: FieldValue.serverTimestamp(),
            AppConstants.uid: counter,
          });
      counter++;
      emit(SuccessState());
    } on FirebaseException catch (e) {
      emit(ErrorState(error: e.toString()));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }

  void getTodos(String uid) {
    emit(LoadingState());
    try {
      todos = user
          .doc(uid)
          .collection(AppConstants.collectionName)
          .orderBy(
            AppConstants.createdAt,
            descending: true,
          ) // Order by createdAt field
          .get();
      emit(InitState()); // Emit InitState after setting the future
    } on FirebaseException catch (e) {
      emit(ErrorState(error: e.toString()));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }

  void deleteTodos(String uid, int idForTodos) {
    emit(LoadingState());
    try {
      user
          .doc(uid)
          .collection(AppConstants.collectionName)
          .doc(idForTodos.toString())
          .delete();
      emit(SuccessState());
    } on FirebaseException catch (e) {
      emit(ErrorState(error: e.toString()));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }

  void clearTodos(String uid) {
    emit(LoadingState());
    try {
      user.doc(uid).collection(AppConstants.collectionName).doc().delete();
      emit(SuccessState());
    } on FirebaseException catch (e) {
      emit(ErrorState(error: e.toString()));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }

  void resetState() {
    emit(InitState());
  }

  void update(String uid, String idForTodos, String title, String content) {
    user
        .doc(uid)
        .collection(AppConstants.collectionName)
        .doc(idForTodos)
        .update({AppConstants.title: title, AppConstants.content: content});
  }

  void getNoteDetails(String uid, String docId) {
    emit(LoadingState());
    try {
      noteDetails = user
          .doc(uid)
          .collection(AppConstants.collectionName)
          .doc(docId)
          .get();
      emit(InitState());
    } on FirebaseException catch (e) {
      emit(ErrorState(error: e.toString()));
    } catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }
}
