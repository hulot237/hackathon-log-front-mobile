import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../models/notification.dart';

enum NotificationStatus { initial, loading, success, failure }

@immutable
class NotificationState extends Equatable {
  final List<AppNotification> notifications;
  final NotificationStatus status;
  final bool isLoading;
  final String? error;
  final String? errorMessage;

  const NotificationState({
    required this.notifications,
    this.status = NotificationStatus.initial,
    this.isLoading = false,
    this.error,
    this.errorMessage,
  });

  factory NotificationState.initial() => const NotificationState(
        notifications: [],
      );

  NotificationState copyWith({
    List<AppNotification>? notifications,
    NotificationStatus? status,
    bool? isLoading,
    String? error,
    String? errorMessage,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  int get unreadCount => notifications.where((notification) => !notification.isRead).length;

  @override
  List<Object?> get props => [notifications, status, isLoading, error, errorMessage];
}
