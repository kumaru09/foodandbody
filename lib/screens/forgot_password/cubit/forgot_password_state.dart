part of 'forgot_password_cubit.dart';

class ForgotPasswordState extends Equatable {
  ForgotPasswordState(
      {this.email = const Email.pure(), this.status = FormzStatus.pure});

  final Email email;
  final FormzStatus status;

  ForgotPasswordState copyWith({Email? email, FormzStatus? status}) {
    return ForgotPasswordState(
        email: email ?? this.email, status: status ?? this.status);
  }

  @override
  List<Object> get props => [email, status];
}
