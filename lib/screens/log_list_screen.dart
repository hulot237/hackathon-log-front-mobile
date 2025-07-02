import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../models/log.dart';
import '../cubits/log/log_cubit.dart';
import '../cubits/log/log_state.dart';
import 'log_detail_screen.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journaux'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterBottomSheet(context);
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddLogDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Rechercher des journaux...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[100]
              : Colors.grey[800],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return BlocBuilder<LogCubit, LogState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              if (state.selectedType != null || state.startDate != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: const Text('Tout effacer'),
                    onSelected: (_) {
                      context.read<LogCubit>().clearFilters();
                    },
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              
              // Type filters
              for (final type in LogType.values)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    selected: state.selectedType == type,
                    label: Text(type.name),
                    onSelected: (selected) {
                      context.read<LogCubit>().filterByType(selected ? type : null);
                    },
                    backgroundColor: type.color.withOpacity(0.1),
                    selectedColor: type.color.withOpacity(0.3),
                    checkmarkColor: type.color,
                    labelStyle: TextStyle(
                      color: type.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              
              // Date filter indicator
              if (state.startDate != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(
                      DateFormat('MMM d, y').format(state.startDate!),
                    ),
                    onSelected: (_) {
                      context.read<LogCubit>().filterByDate(startDate: null);
                    },
                    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () {
                      context.read<LogCubit>().filterByDate(startDate: null);
                    },
                  ),
                ),
            ],
          ),
        );
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
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucun journal trouvé',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Essayez d\'ajuster vos filtres',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }
        
        return RefreshIndicator(
          onRefresh: () async {
            // In a real app, this would refresh data from the server
            await Future.delayed(const Duration(seconds: 1));
            if (mounted) {
              context.read<LogCubit>().generateMockLogs();
            }
          },
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return _buildLogItem(context, log);
            },
          ),
        );
      },
    );
  }

  Widget _buildLogItem(BuildContext context, Log log) {
    final dateFormat = DateFormat('MMM d, HH:mm');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => LogDetailScreen(log: log),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
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
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      log.source,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    dateFormat.format(log.timestamp),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                log.message,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              if (log.type == LogType.error && log.stacktrace != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
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
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocBuilder<LogCubit, LogState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filtrer les journaux',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<LogCubit>().clearFilters();
                        },
                        child: const Text('Tout effacer'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Type de journal',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: LogType.values.map((type) {
                      return ChoiceChip(
                        selected: state.selectedType == type,
                        label: Text(type.name),
                        onSelected: (selected) {
                          context.read<LogCubit>().filterByType(selected ? type : null);
                        },
                        backgroundColor: type.color.withOpacity(0.1),
                        selectedColor: type.color.withOpacity(0.3),
                        labelStyle: TextStyle(
                          color: type.color,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Date',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: state.startDate ?? DateTime.now(),
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now(),
                      );
                      if (selectedDate != null) {
                        context.read<LogCubit>().filterByDate(startDate: selectedDate);
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      state.startDate != null
                          ? DateFormat('MMM d, y').format(state.startDate!)
                          : 'Sélectionner une date',
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.secondary,
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Appliquer les filtres'),
                    ),
                  ),
                ],
              ),
            );
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
            return AlertDialog(
              title: const Text('Ajouter un nouveau journal'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Type de journal'),
                    const SizedBox(height: 8),
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
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        labelText: 'Message',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: sourceController,
                      decoration: const InputDecoration(
                        labelText: 'Source',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
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
                    }
                  },
                  child: const Text('Ajouter'),
                ),
              ],
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
