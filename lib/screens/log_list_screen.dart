import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../cubits/log/log_cubit.dart';
import '../cubits/log/log_state.dart';
import '../cubits/notification/notification_cubit.dart';
import '../cubits/notification/notification_state.dart';
import '../cubits/user/user_cubit.dart';
import '../cubits/user/user_state.dart';
import '../models/log.dart';
import 'log_detail_screen.dart';
import 'notification_screen.dart';

class LogListScreen extends StatefulWidget {
  const LogListScreen({super.key});

  @override
  State<LogListScreen> createState() => _LogListScreenState();
}

class _LogListScreenState extends State<LogListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }
  
  void _onSearchChanged() {
    context.read<LogCubit>().updateSearchQuery(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    // Définir le style de la barre d'état pour qu'elle corresponde à la barre d'application
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Journaux', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tri des journaux à implémenter')),
              );
            },
          ),
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationScreen()),
                      );
                    },
                  ),
                  if (state.unreadCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          state.unreadCount > 9 ? '9+' : state.unreadCount.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              return IconButton(
                icon: state.user != null && state.user!.photoUrl != null
                  ? CircleAvatar(
                      radius: 14,
                      backgroundImage: NetworkImage(state.user!.photoUrl!),
                    )
                  : CircleAvatar(
                      radius: 14,
                      backgroundColor: state.user != null ? state.user!.getAvatarColor() : Colors.grey,
                      child: Text(
                        state.user != null ? state.user!.initials : '?',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(
            child: _buildLogList(),
          ),
        ],
      ).animate().fadeIn(duration: 300.ms),
      // FloatingActionButton supprimé à la demande de l'utilisateur
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Rechercher des journaux...',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
          prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Theme.of(context).colorScheme.primary),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          filled: true,
          fillColor: Colors.grey[100],
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: -0.1, end: 0);
  }

  Widget _buildFilterChips() {
    return BlocBuilder<LogCubit, LogState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey[200]!, width: 1),
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                if (state.selectedType != null || state.startDate != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.refresh, size: 16),
                          const SizedBox(width: 4),
                          const Text('Réinitialiser'),
                        ],
                      ),
                      onSelected: (_) {
                        context.read<LogCubit>().clearFilters();
                      },
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
                      ),
                      elevation: 0,
                      pressElevation: 2,
                    ).animate().scale(duration: 300.ms),
                  ),
                
                // Type filters
                ...LogType.values.map((type) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      selected: state.selectedType == type,
                      showCheckmark: false,
                      avatar: Icon(
                        type.icon,
                        size: 16,
                        color: state.selectedType == type ? Colors.white : type.color,
                      ),
                      label: Text(
                        type.name,
                        style: TextStyle(
                          color: state.selectedType == type ? Colors.white : type.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onSelected: (selected) {
                        context.read<LogCubit>().filterByType(selected ? type : null);
                      },
                      backgroundColor: type.color.withOpacity(0.1),
                      selectedColor: type.color,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: type.color.withOpacity(0.3)),
                      ),
                      elevation: 0,
                      pressElevation: 2,
                    ).animate(target: state.selectedType == type ? 1 : 0).scale(begin: const Offset(0.95, 0.95), end: const Offset(1.0, 1.0)),
                  );
                }).toList(),
                
                // Bouton pour filtrer par date
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ActionChip(
                    avatar: Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: state.startDate != null 
                        ? Colors.white 
                        : Theme.of(context).colorScheme.secondary,
                    ),
                    label: Text(
                      state.startDate != null
                        ? DateFormat('d MMM y', 'fr_FR').format(state.startDate!)
                        : 'Filtrer par date',
                      style: TextStyle(
                        color: state.startDate != null 
                          ? Colors.white 
                          : Theme.of(context).colorScheme.secondary,
                        fontWeight: state.startDate != null ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                    onPressed: () async {
                      // Si une date est déjà sélectionnée, on la réinitialise
                      if (state.startDate != null) {
                        context.read<LogCubit>().filterByDate(startDate: null);
                        return;
                      }
                      
                      // Sinon, on affiche le sélecteur de date amélioré
                      final ThemeData theme = Theme.of(context);
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now(),
                        locale: const Locale('fr', 'FR'),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: theme.copyWith(
                              colorScheme: theme.colorScheme.copyWith(
                                primary: Theme.of(context).colorScheme.secondary,
                                onPrimary: Colors.white,
                                surface: Colors.white,
                                onSurface: Colors.black87,
                              ),
                              dialogBackgroundColor: Colors.white,
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: Theme.of(context).colorScheme.secondary,
                                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      
                      if (selectedDate != null) {
                        context.read<LogCubit>().filterByDate(startDate: selectedDate);
                      }
                    },
                    backgroundColor: state.startDate != null 
                      ? Theme.of(context).colorScheme.secondary 
                      : Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(
                        color: state.startDate != null 
                          ? Colors.transparent 
                          : Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 400.ms, delay: 200.ms);
      },
    );
  }

  Widget _buildLogList() {
    return BlocBuilder<LogCubit, LogState>(
      builder: (context, state) {
        final logs = state.filteredLogs;
        
        if (logs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey[400],
                ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                const SizedBox(height: 16),
                Text(
                  'Aucun journal trouvé',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 8),
                Text(
                  'Essayez d\'ajuster vos filtres',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ).animate().fadeIn(delay: 400.ms),
                const SizedBox(height: 24),
                FilledButton.tonal(
                  onPressed: () {
                    context.read<LogCubit>().clearFilters();
                    _searchController.clear();
                  },
                  child: const Text('Réinitialiser les filtres'),
                ).animate().fadeIn(delay: 600.ms).move(delay: 600.ms, begin: const Offset(0, 20), end: Offset.zero),
              ],
            ),
          );
        }
        
        return Stack(
          children: [
            RefreshIndicator(
              color: Theme.of(context).colorScheme.primary,
              backgroundColor: Colors.white,
              onRefresh: () async {
                // In a real app, this would refresh data from the server
                await Future.delayed(const Duration(seconds: 1));
                if (mounted) {
                  context.read<LogCubit>().generateMockLogs();
                }
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 80), // Padding en bas pour le FAB
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  return _buildLogItem(context, log);
                },
              ),
            ),
            // Overlay gradient at the bottom to improve FAB visibility
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 40,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0),
                      Colors.white.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLogItem(BuildContext context, Log log) {
    final dateFormat = DateFormat('d MMM, HH:mm', 'fr_FR');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => LogDetailScreen(log: log),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icône du type de log avec un conteneur coloré
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: log.type.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: log.type.color.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      log.type.icon,
                      color: log.type.color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Message principal
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          log.message,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Métadonnées
                        Wrap(
                          spacing: 8, // Espace horizontal entre les éléments
                          runSpacing: 4, // Espace vertical entre les lignes
                          children: [
                            // Type de log
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: log.type.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                log.type.name,
                                style: TextStyle(
                                  color: log.type.color,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            // Horodatage
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 12,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  dateFormat.format(log.timestamp),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            // Source
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.code,
                                  size: 12,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    log.source,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Flèche de navigation
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ],
              ),
              // Stacktrace pour les erreurs
              if (log.type == LogType.error && log.stacktrace != null) ...[  
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.code,
                        size: 16,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          log.stacktrace!.split('\n').first,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 50.ms).move(delay: 50.ms, begin: const Offset(0, 10), end: Offset.zero);
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return BlocBuilder<LogCubit, LogState>(
          builder: (context, state) {
            return Container(
              padding: EdgeInsets.only(
                top: 24.0,
                left: 24.0,
                right: 24.0,
                bottom: 24.0 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Poignée de la feuille modale
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // En-tête
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.filter_list,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Filtrer les journaux',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: () {
                          context.read<LogCubit>().clearFilters();
                        },
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Tout effacer'),
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  // Types de journaux
                  Row(
                    children: [
                      Icon(
                        Icons.label_important,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Type de journal',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: LogType.values.map((type) {
                      return ChoiceChip(
                        selected: state.selectedType == type,
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              type.icon,
                              size: 16,
                              color: state.selectedType == type ? Colors.white : type.color,
                            ),
                            const SizedBox(width: 4),
                            Text(type.name),
                          ],
                        ),
                        onSelected: (selected) {
                          context.read<LogCubit>().filterByType(selected ? type : null);
                        },
                        backgroundColor: type.color.withOpacity(0.1),
                        selectedColor: type.color,
                        labelStyle: TextStyle(
                          color: state.selectedType == type ? Colors.white : type.color,
                          fontWeight: FontWeight.w500,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(color: type.color.withOpacity(0.3)),
                        ),
                        elevation: 0,
                        pressElevation: 2,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ).animate(target: state.selectedType == type ? 1 : 0)
                        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.0, 1.0));
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  // Sélection de date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Date',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: state.startDate ?? DateTime.now(),
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now(),
                        locale: const Locale('fr', 'FR'),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Theme.of(context).colorScheme.primary,
                                onPrimary: Colors.white,
                                surface: Colors.white,
                                onSurface: Colors.black,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (selectedDate != null) {
                        context.read<LogCubit>().filterByDate(startDate: selectedDate);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            state.startDate != null
                                ? DateFormat('d MMMM y', 'fr_FR').format(state.startDate!)
                                : 'Sélectionner une date',
                            style: TextStyle(
                              color: state.startDate != null
                                  ? Theme.of(context).colorScheme.secondary
                                  : Colors.grey[600],
                              fontWeight: state.startDate != null ? FontWeight.w500 : FontWeight.normal,
                            ),
                          ),
                          const Spacer(),
                          if (state.startDate != null)
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                context.read<LogCubit>().filterByDate(startDate: null);
                              },
                              color: Colors.grey[600],
                              iconSize: 18,
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Bouton d'application
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: const Text('Appliquer les filtres', style: TextStyle(color: Colors.white)),
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms).slide(begin: const Offset(0, 0.1), end: Offset.zero);
          },
        );
      },
    );
  }

  void _showAddLogDialog(BuildContext context) {
    LogType selectedType = LogType.info;
    final messageController = TextEditingController();
    final sourceController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              backgroundColor: Colors.white,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // En-tête
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.add_circle,
                              color: Theme.of(context).colorScheme.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Ajouter un nouveau journal',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1, end: 0),
                      const Divider(height: 32),
                      
                      // Type de journal
                      Row(
                        children: [
                          Icon(
                            Icons.label_important,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Type de journal',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
                      const SizedBox(height: 12),
                      SegmentedButton<LogType>(
                        segments: LogType.values.map((type) {
                          return ButtonSegment<LogType>(
                            value: type,
                            label: Text(type.name),
                            icon: Icon(type.icon),
                          );
                        }).toList(),
                        selected: {selectedType},
                        onSelectionChanged: (Set<LogType> selection) {
                          setState(() {
                            selectedType = selection.first;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (states) {
                              if (states.contains(MaterialState.selected)) {
                                return selectedType.color;
                              }
                              return Colors.transparent;
                            },
                          ),
                          foregroundColor: MaterialStateProperty.resolveWith<Color>(
                            (states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.white;
                              }
                              return selectedType.color;
                            },
                          ),
                        ),
                      ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
                      const SizedBox(height: 24),
                      
                      // Message
                      Row(
                        children: [
                          Icon(
                            Icons.message,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Message',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(duration: 300.ms, delay: 300.ms),
                      const SizedBox(height: 12),
                      TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: 'Entrez le message du journal...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: selectedType.color),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        maxLines: 3,
                      ).animate().fadeIn(duration: 300.ms, delay: 400.ms),
                      const SizedBox(height: 24),
                      
                      // Source
                      Row(
                        children: [
                          Icon(
                            Icons.code,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Source',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(duration: 300.ms, delay: 500.ms),
                      const SizedBox(height: 12),
                      TextField(
                        controller: sourceController,
                        decoration: InputDecoration(
                          hintText: 'Entrez la source du journal...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: selectedType.color),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          contentPadding: const EdgeInsets.all(16),
                          prefixIcon: Icon(Icons.laptop, color: Colors.grey[600]),
                        ),
                      ).animate().fadeIn(duration: 300.ms, delay: 600.ms),
                      const SizedBox(height: 32),
                      
                      // Boutons d'action
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close),
                            label: const Text('Annuler'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ).animate().fadeIn(duration: 300.ms, delay: 700.ms),
                          const SizedBox(width: 16),
                          FilledButton.icon(
                            onPressed: () {
                              if (messageController.text.isNotEmpty && sourceController.text.isNotEmpty) {
                                final logCubit = context.read<LogCubit>();
                                
                                final newLog = Log(
                                  id: 'log_${DateTime.now().millisecondsSinceEpoch}',
                                  type: selectedType,
                                  timestamp: DateTime.now(),
                                  message: messageController.text,
                                  source: sourceController.text,
                                  stacktrace: selectedType == LogType.error
                                      ? 'at com.example.app.MainActivity.onStart(MainActivity.java:32)'
                                      : null,
                                  metadata: {
                                    'device': 'Mobile',
                                    'version': '1.0.0',
                                    'userId': 'user_123',
                                  },
                                );
                                
                                logCubit.addLog(newLog);
                                Navigator.pop(context);
                                
                                // Afficher une confirmation
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Journal ajouté avec succès'),
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    action: SnackBarAction(
                                      label: 'OK',
                                      textColor: Colors.white,
                                      onPressed: () {},
                                    ),
                                  ),
                                );
                              } else {
                                // Afficher une erreur si les champs sont vides
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Veuillez remplir tous les champs'),
                                    backgroundColor: Theme.of(context).colorScheme.error,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text('Ajouter', style: TextStyle(color: Colors.white)),
                            style: FilledButton.styleFrom(
                              backgroundColor: selectedType.color,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ).animate().fadeIn(duration: 300.ms, delay: 800.ms),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
