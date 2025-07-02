import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/log.dart';
import '../cubits/log/log_cubit.dart';

class LogDetailScreen extends StatelessWidget {
  final Log log;

  const LogDetailScreen({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du journal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareLog(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildMessageSection(context),
            const SizedBox(height: 24),
            if (log.stacktrace != null) ...[
              _buildStacktraceSection(context),
              const SizedBox(height: 24),
            ],
            _buildMetadataSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final dateFormat = DateFormat('d MMMM y • HH:mm:ss', 'fr_FR');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: log.type.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                log.type.icon,
                color: log.type.color,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: log.type.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      log.type.name.toUpperCase(),
                      style: TextStyle(
                        color: log.type.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ID: ${log.id}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              dateFormat.format(log.timestamp),
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.source_outlined,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              'Source: ${log.source}',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMessageSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Message'),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          child: Text(
            log.message,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStacktraceSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle(context, 'Stacktrace'),
            IconButton(
              icon: const Icon(Icons.copy, size: 20),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: log.stacktrace!));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Trace d\'erreur copiée dans le presse-papiers'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              tooltip: 'Copy to clipboard',
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[100]
                : Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            log.stacktrace!,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
              height: 1.5,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[800]
                  : Colors.grey[300],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetadataSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle(context, 'Métadonnées'),
            IconButton(
              icon: const Icon(Icons.copy, size: 20),
              onPressed: () {
                final metadataString = log.metadata?.entries
                    .map((e) => '${e.key}: ${e.value}')
                    .join('\n');
                Clipboard.setData(ClipboardData(text: metadataString ?? ''));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Métadonnées copiées dans le presse-papiers'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              tooltip: 'Copy to clipboard',
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (log.metadata != null && log.metadata!.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
              ),
            ),
            child: Column(
              children: log.metadata!.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          '${entry.key}:',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          entry.value?.toString() ?? 'null',
                          style: const TextStyle(
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
              ),
            ),
            child: const Text('No metadata available'),
          ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void _shareLog(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    
    final logText = '''
Log ID: ${log.id}
Type: ${log.type.name}
Timestamp: ${dateFormat.format(log.timestamp)}
Source: ${log.source}
Message: ${log.message}
${log.stacktrace != null ? '\nStacktrace:\n${log.stacktrace}' : ''}
${log.metadata != null && log.metadata!.isNotEmpty ? '\nMetadata:\n${log.metadata!.entries.map((e) => '${e.key}: ${e.value}').join('\n')}' : ''}
''';

    Clipboard.setData(ClipboardData(text: logText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Détails du journal copiés dans le presse-papiers'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer le journal'),
          content: const Text('Êtes-vous sûr de vouloir supprimer ce journal ? Cette action ne peut pas être annulée.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<LogCubit>().deleteLog(log.id);
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to previous screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Journal supprimé avec succès'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
}
