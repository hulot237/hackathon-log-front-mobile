import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/log.dart';
import 'log_state.dart';

class LogCubit extends Cubit<LogState> {
  LogCubit() : super(LogState.initial()) {
    generateMockLogs();
  }

  void generateMockLogs() {
    emit(state.copyWith(isLoading: true));
    
    final random = Random();
    final List<Log> mockLogs = [];
    
    final sources = [
      'ServiceAuth',
      'AssistantBDD',
      'GestionnaireRéseau',
      'ClientAPI',
      'GestionnaireFichiers',
      'GestionnaireCache',
      'ServiceNotifications',
      'TraceurLocalisation'
    ];
    
    final errorMessages = [
      'Échec de connexion au serveur',
      'Jeton d\'authentification expiré',
      'Échec de la requête de base de données',
      'Délai d\'attente de la requête réseau dépassé',
      'Fichier non trouvé',
      'Permission refusée'
    ];
    
    final warningMessages = [
      'Connexion réseau lente détectée',
      'Avertissement de mémoire faible',
      'Tentative 3 sur 5',
      'Cache invalidé',
      'Utilisation de la configuration de secours',
      'Utilisation d\'API obsolète détectée'
    ];
    
    final infoMessages = [
      'Utilisateur connecté avec succès',
      'Données synchronisées',
      'Cache mis à jour',
      'Paramètres modifiés',
      'Tâche en arrière-plan terminée',
      'Nouvelle version disponible'
    ];
    
    final now = DateTime.now();
    
    // Generate 20 random logs
    for (int i = 0; i < 20; i++) {
      final typeRandom = random.nextInt(3);
      final LogType type = LogType.values[typeRandom];
      
      String message;
      if (type == LogType.error) {
        message = errorMessages[random.nextInt(errorMessages.length)];
      } else if (type == LogType.warning) {
        message = warningMessages[random.nextInt(warningMessages.length)];
      } else {
        message = infoMessages[random.nextInt(infoMessages.length)];
      }
      
      final source = sources[random.nextInt(sources.length)];
      
      // Random timestamp within the last 7 days
      final timestamp = now.subtract(Duration(
        days: random.nextInt(7),
        hours: random.nextInt(24),
        minutes: random.nextInt(60),
      ));
      
      // Only errors have stacktrace
      String? stacktrace;
      if (type == LogType.error) {
        stacktrace = '''
Exception in thread "main" java.lang.NullPointerException
    at com.example.myproject.Book.getTitle(Book.java:16)
    at com.example.myproject.Author.getBookTitles(Author.java:25)
    at com.example.myproject.Bootstrap.main(Bootstrap.java:14)''';
      }
      
      // Random metadata
      Map<String, dynamic>? metadata = {
        'userId': 'user_${random.nextInt(10000)}',
        'sessionId': 'session_${random.nextInt(5000)}',
        'deviceInfo': {
          'platform': random.nextBool() ? 'iOS' : 'Android',
          'version': '${random.nextInt(10) + 1}.${random.nextInt(10)}.${random.nextInt(10)}',
        },
        'requestId': 'req_${random.nextInt(100000)}',
      };
      
      mockLogs.add(Log(
        id: 'log_$i',
        type: type,
        timestamp: timestamp,
        message: message,
        source: source,
        stacktrace: stacktrace,
        metadata: metadata,
      ));
    }
    
    // Sort logs by timestamp (newest first)
    mockLogs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    emit(state.copyWith(
      logs: mockLogs,
      filteredLogs: mockLogs,
      isLoading: false,
    ));
  }

  void addLog(Log log) {
    final updatedLogs = [...state.logs, log];
    emit(state.copyWith(
      logs: updatedLogs,
      filteredLogs: _applyFilters(updatedLogs),
    ));
  }

  void deleteLog(String logId) {
    final updatedLogs = state.logs.where((log) => log.id != logId).toList();
    emit(state.copyWith(
      logs: updatedLogs,
      filteredLogs: _applyFilters(updatedLogs),
    ));
  }

  void filterByType(LogType? type) {
    emit(state.copyWith(
      selectedType: type,
      filteredLogs: _applyFilters(state.logs, newType: type),
    ));
  }

  void filterByDate({DateTime? startDate, DateTime? endDate}) {
    emit(state.copyWith(
      startDate: startDate,
      endDate: endDate,
      filteredLogs: _applyFilters(
        state.logs,
        newStartDate: startDate,
        newEndDate: endDate,
      ),
    ));
  }

  void searchLogs(String query) {
    emit(state.copyWith(
      searchQuery: query,
      filteredLogs: _applyFilters(state.logs, newQuery: query),
    ));
  }

  void updateSearchQuery(String query) {
    searchLogs(query);
  }

  void clearFilters() {
    emit(state.copyWith(
      selectedType: null,
      clearSelectedType: true,
      clearStartDate: true,
      clearEndDate: true,
      searchQuery: '',
      filteredLogs: state.logs,
    ));
  }

  List<Log> _applyFilters(
    List<Log> logs, {
    LogType? newType,
    DateTime? newStartDate,
    DateTime? newEndDate,
    String? newQuery,
  }) {
    final type = newType ?? state.selectedType;
    final startDate = newStartDate ?? state.startDate;
    final endDate = newEndDate ?? state.endDate;
    final query = newQuery ?? state.searchQuery;
    
    return logs.where((log) {
      // Filter by type
      if (type != null && log.type != type) {
        return false;
      }
      
      // Filter by date range
      if (startDate != null) {
        // Créer une date de début à minuit (00:00:00)
        final start = DateTime(startDate.year, startDate.month, startDate.day);
        // Créer une date de fin à 23:59:59 du même jour
        final end = DateTime(startDate.year, startDate.month, startDate.day, 23, 59, 59, 999);
        
        // Vérifier si le timestamp du log est dans la journée sélectionnée
        final logDate = log.timestamp;
        if (logDate.isBefore(start) || logDate.isAfter(end)) {
          return false;
        }
      }
      
      // Note: La logique pour endDate est conservée mais n'est pas utilisée actuellement
      if (endDate != null) {
        final end = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59, 999);
        if (log.timestamp.isAfter(end)) {
          return false;
        }
      }
      
      // Filter by search query
      if (query.isNotEmpty) {
        final lowercaseQuery = query.toLowerCase();
        return log.message.toLowerCase().contains(lowercaseQuery) ||
            log.source.toLowerCase().contains(lowercaseQuery) ||
            (log.stacktrace?.toLowerCase().contains(lowercaseQuery) ?? false);
      }
      
      return true;
    }).toList();
  }
}
