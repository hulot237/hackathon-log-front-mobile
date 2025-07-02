import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserState.initial()) {
    // Charger l'utilisateur au démarrage
    loadUser();
  }

  // Charger les données de l'utilisateur (simulé pour le moment)
  Future<void> loadUser() async {
    emit(state.copyWith(status: UserStatus.loading));
    
    try {
      // Simuler un délai de chargement
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Créer un utilisateur fictif pour la démonstration
      final user = User(
        id: 'user123',
        name: 'Groupe 3',
        email: 'groupe3@example.com',
        role: 'Administrateur',
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
        lastLogin: DateTime.now(),
        photoUrl: null, // Pas de photo pour l'instant
        preferences: {
          'darkMode': true,
          'notifications': true,
          'language': 'fr',
        },
      );
      
      emit(state.copyWith(
        user: user,
        status: UserStatus.success,
        isAuthenticated: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: UserStatus.failure,
        errorMessage: 'Erreur lors du chargement des données utilisateur: $e',
      ));
    }
  }

  // Mettre à jour le nom de l'utilisateur
  void updateUserName(String name) {
    if (state.user == null) return;
    
    final updatedUser = state.user!.copyWith(name: name);
    emit(state.copyWith(user: updatedUser));
  }

  // Mettre à jour l'email de l'utilisateur
  void updateUserEmail(String email) {
    if (state.user == null) return;
    
    final updatedUser = state.user!.copyWith(email: email);
    emit(state.copyWith(user: updatedUser));
  }

  // Mettre à jour les préférences de l'utilisateur
  void updateUserPreferences(Map<String, dynamic> newPreferences) {
    if (state.user == null) return;
    
    final currentPreferences = state.user!.preferences ?? {};
    final updatedPreferences = {...currentPreferences, ...newPreferences};
    
    final updatedUser = state.user!.copyWith(preferences: updatedPreferences);
    emit(state.copyWith(user: updatedUser));
  }

  // Déconnexion de l'utilisateur
  void logout() {
    emit(UserState.initial());
  }
}
