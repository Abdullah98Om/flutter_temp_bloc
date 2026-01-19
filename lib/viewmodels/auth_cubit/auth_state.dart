part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitialState extends AuthState {}

final class AuthLoggedState extends AuthState {
  final String user;

  const AuthLoggedState(this.user);
  @override
  List<Object> get props => [user];
}

final class AuthNotLoggedState extends AuthState {}
