abstract class CreateNoteState {}

class InitState extends CreateNoteState {}

class SuccessState extends CreateNoteState {}

class LoadingState extends CreateNoteState {}

class ErrorState extends CreateNoteState {
  String error;
  ErrorState({required this.error});
}
