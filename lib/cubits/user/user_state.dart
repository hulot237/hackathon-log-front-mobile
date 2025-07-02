import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';

enum UserStatus { initial, loading, success, failure }

@immutable
class UserState extends Equatable {
  final User? user;
  final UserStatus status;
  final String? errorMessage;
  final bool isAuthenticated;

  const UserState({
    this.user,
    this.status = UserStatus.initial,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  factory UserState.initial() => const UserState();

  UserState copyWith({
    User? user,
    UserStatus? status,
    String? errorMessage,
    bool? isAuthenticated,
  }) {
    return UserState(
      user: user ?? this.user,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  @override
  List<Object?> get props => [user, status, errorMessage, isAuthenticated];
}
