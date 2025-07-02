import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../models/log.dart';

@immutable
class LogState extends Equatable {
  final List<Log> logs;
  final List<Log> filteredLogs;
  final LogType? selectedType;
  final DateTime? startDate;
  final DateTime? endDate;
  final String searchQuery;
  final bool isLoading;
  final String? error;

  const LogState({
    required this.logs,
    required this.filteredLogs,
    this.selectedType,
    this.startDate,
    this.endDate,
    this.searchQuery = '',
    this.isLoading = false,
    this.error,
  });

  factory LogState.initial() => const LogState(
        logs: [],
        filteredLogs: [],
      );

  LogState copyWith({
    List<Log>? logs,
    List<Log>? filteredLogs,
    LogType? selectedType,
    bool clearSelectedType = false,
    DateTime? startDate,
    bool clearStartDate = false,
    DateTime? endDate,
    bool clearEndDate = false,
    String? searchQuery,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return LogState(
      logs: logs ?? this.logs,
      filteredLogs: filteredLogs ?? this.filteredLogs,
      selectedType: clearSelectedType ? null : (selectedType ?? this.selectedType),
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  // Statistics getters
  int get totalLogs => logs.length;
  
  int get errorCount => logs.where((log) => log.type == LogType.error).length;
  
  int get warningCount => logs.where((log) => log.type == LogType.warning).length;
  
  int get infoCount => logs.where((log) => log.type == LogType.info).length;
  
  // Get logs grouped by day for the chart
  Map<DateTime, int> get logsByDay {
    final Map<DateTime, int> result = {};
    
    // Get the last 7 days
    final now = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day - i);
      result[date] = 0;
    }
    
    // Count logs for each day
    for (final log in logs) {
      final date = DateTime(log.timestamp.year, log.timestamp.month, log.timestamp.day);
      if (result.containsKey(date)) {
        result[date] = (result[date] ?? 0) + 1;
      }
    }
    
    return result;
  }
  
  // Get recent logs (last 5)
  List<Log> get recentLogs {
    final sortedLogs = List<Log>.from(logs)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sortedLogs.take(5).toList();
  }

  @override
  List<Object?> get props => [
        logs,
        filteredLogs,
        selectedType,
        startDate,
        endDate,
        searchQuery,
        isLoading,
        error,
      ];
}
