import 'package:flutter/material.dart';

enum LogType { error, warning, info }

extension LogTypeExtension on LogType {
  String get name {
    switch (this) {
      case LogType.error:
        return 'Error';
      case LogType.warning:
        return 'Warning';
      case LogType.info:
        return 'Info';
    }
  }

  Color get color {
    switch (this) {
      case LogType.error:
        return Colors.red;
      case LogType.warning:
        return Colors.orange;
      case LogType.info:
        return Colors.blue;
    }
  }

  IconData get icon {
    switch (this) {
      case LogType.error:
        return Icons.error_outline;
      case LogType.warning:
        return Icons.warning_amber_outlined;
      case LogType.info:
        return Icons.info_outline;
    }
  }
}

class Log {
  final String id;
  final LogType type;
  final DateTime timestamp;
  final String message;
  final String source;
  final String? stacktrace;
  final Map<String, dynamic>? metadata;

  Log({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.message,
    required this.source,
    this.stacktrace,
    this.metadata,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      id: json['id'],
      type: LogType.values.firstWhere(
        (e) => e.toString() == 'LogType.${json['type']}',
        orElse: () => LogType.info,
      ),
      timestamp: DateTime.parse(json['timestamp']),
      message: json['message'],
      source: json['source'],
      stacktrace: json['stacktrace'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'message': message,
      'source': source,
      'stacktrace': stacktrace,
      'metadata': metadata,
    };
  }
}
