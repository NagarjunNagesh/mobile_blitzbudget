part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent(this.username, this.password);

  final String username;
  final String password;

  @override
  List<Object> get props => [];
}

class LoginUser extends LoginEvent {
  const LoginUser(String username, String password) : super(username, password);
}

class ForgotPassword extends LoginEvent {
  const ForgotPassword(String username, String password)
      : super(username, password);
}
