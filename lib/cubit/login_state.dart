abstract class LoginState {}
class InitState extends LoginState {}
class SucessState extends LoginState {}
class ErrorState extends LoginState {
  String errorMessage;
  ErrorState({required this.errorMessage});
}
class LoadingState extends LoginState {}