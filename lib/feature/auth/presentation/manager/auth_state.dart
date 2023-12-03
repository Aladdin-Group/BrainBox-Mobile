import 'package:brain_box/feature/auth/data/models/auth_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';

@immutable
class AuthState extends Equatable{
  final FormzSubmissionStatus status;

  const AuthState({
    this.status = FormzSubmissionStatus.initial,
  });
  AuthState copyWith({FormzSubmissionStatus? status})=>AuthState(
    status: status ?? this.status,
  );

  @override
  List<Object?> get props => [status,];
}