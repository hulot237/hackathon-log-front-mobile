import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/notification.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationState.initial()) {
    generateMockNotifications();
  }

  void generateMockNotifications() {
    emit(state.copyWith(isLoading: true));
    
    final random = Random();
    final List<AppNotification> mockNotifications = [];
    
    final titles = [
      'Nouvelle mise à jour disponible',
      'Alerte de sécurité',
      'Maintenance programmée',
      'Erreur détectée',
      'Synchronisation terminée',
      'Connexion suspecte'
    ];
    
    final messages = [
      'Une nouvelle version de l\'application est disponible. Mettez à jour pour bénéficier des dernières fonctionnalités.',
      'Nous avons détecté une activité suspecte sur votre compte. Vérifiez vos paramètres de sécurité.',
      'Une maintenance est programmée pour demain à 2h du matin. L\'application pourrait être indisponible pendant 30 minutes.',
      'Une erreur a été détectée lors de la dernière synchronisation. Veuillez réessayer.',
      'Vos données ont été synchronisées avec succès.',
      'Une connexion depuis un nouvel appareil a été détectée. Est-ce vous?'
    ];
    
    final now = DateTime.now();
    
    // Generate 10 random notifications
    for (int i = 0; i < 10; i++) {
      final typeRandom = random.nextInt(4);
      final NotificationType type = NotificationType.values[typeRandom];
      
      final title = titles[random.nextInt(titles.length)];
      final message = messages[random.nextInt(messages.length)];
      
      // Random timestamp within the last 7 days
      final timestamp = now.subtract(Duration(
        days: random.nextInt(7),
        hours: random.nextInt(24),
        minutes: random.nextInt(60),
      ));
      
      // Random read status with more unread than read
      final isRead = random.nextInt(10) > 6;
      
      mockNotifications.add(AppNotification(
        id: 'notification_$i',
        title: title,
        message: message,
        timestamp: timestamp,
        type: type,
        isRead: isRead,
      ));
    }
    
    // Sort notifications by timestamp (newest first)
    mockNotifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    emit(state.copyWith(
      notifications: mockNotifications,
      isLoading: false,
    ));
  }

  void markAsRead(String notificationId) {
    final updatedNotifications = state.notifications.map((notification) {
      if (notification.id == notificationId) {
        return notification.copyWith(isRead: true);
      }
      return notification;
    }).toList();
    
    emit(state.copyWith(notifications: updatedNotifications));
  }

  void markAllAsRead() {
    final updatedNotifications = state.notifications.map((notification) {
      return notification.copyWith(isRead: true);
    }).toList();
    
    emit(state.copyWith(notifications: updatedNotifications));
  }

  void deleteNotification(String notificationId) {
    final updatedNotifications = state.notifications.where((notification) => 
      notification.id != notificationId
    ).toList();
    
    emit(state.copyWith(notifications: updatedNotifications));
  }

  // Ajouter une nouvelle notification
  void addNotification(AppNotification notification) {
    // Vérifier si une notification avec le même ID existe déjà
    final existingIndex = state.notifications.indexWhere((n) => n.id == notification.id);
    final List<AppNotification> updatedNotifications = List.from(state.notifications);
    
    if (existingIndex >= 0) {
      // Mettre à jour la notification existante
      updatedNotifications[existingIndex] = notification;
    } else {
      // Ajouter la nouvelle notification au début de la liste
      updatedNotifications.insert(0, notification);
    }
    
    emit(state.copyWith(notifications: updatedNotifications));
  }
  
  // Synchroniser avec les notifications Firebase
  Future<void> syncWithFirebaseNotifications() async {
    try {
      // Ici, on pourrait récupérer les notifications depuis Firebase
      // Pour l'instant, nous utilisons les notifications fictives
      
      // Simuler un délai de chargement
      emit(state.copyWith(status: NotificationStatus.loading));
      await Future.delayed(const Duration(milliseconds: 500));
      
      emit(state.copyWith(status: NotificationStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: NotificationStatus.failure,
        errorMessage: 'Erreur lors de la synchronisation des notifications: $e',
      ));
    }
  }

  void clearAllNotifications() {
    emit(state.copyWith(notifications: []));
  }
}
