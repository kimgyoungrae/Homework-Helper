import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:journal/providers/journal_provider.dart';
import 'package:journal/views/journal_view.dart';
import 'package:journal/models/journal_entry.dart';
import 'package:intl/intl.dart';
import 'package:journal/models/journal.dart';
import 'package:provider/provider.dart';

class AllEntriesView extends StatelessWidget {
  final Journal journal;
  const AllEntriesView({required this.journal, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        backgroundColor: Colors.cyan[600],
        title: const Text('Homework Assignments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add new entry',
            onPressed: () {
              final newEntry = JournalEntry.withCurrentTime(
                text: '',
                assignment: '',
                course: '',
                instructor: '',
                isCompleted: false,
              );
              Provider.of<JournalProvider>(context, listen: false).upsertJournalEntry(newEntry);
              _navigateToEntry(context, newEntry);
            }
          ),
        ],
      ),
      body: Consumer<JournalProvider>(
        builder: (context, journalProvider, child) {
          return ListView.builder(
            itemCount: journalProvider.journal.entries.length,
            itemBuilder: (context, index) {
              final entry = journalProvider.journal.entries[index];
              return _createListElementForEntry(context, entry);
            },
          );
        },
      ),
    );
  }

  Card _createListElementForEntry(BuildContext context, JournalEntry entry) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.white,
      elevation: 3,
      child: ListTile(
        leading: Icon(Icons.library_books),
        title: Text(entry.assignment!),
        subtitle: Text('${_formatDateTime(entry.dueDate!)}\n${entry.course!}\n${entry.instructor!}'),
        onTap: () => _navigateToEntry(context, entry),
      ),
    );
  }

  Future<void> _navigateToEntry(BuildContext context, JournalEntry entry) async {
    final newEntry = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => JournalView(entry: entry))
    );

    if (!context.mounted || newEntry == null) return;

    final journal = Provider.of<JournalProvider>(context, listen: false); // get non listening reference to journalprovider
    journal.upsertJournalEntry(newEntry); // call provider's upsert method with entry
  }

  String _formatDateTime(DateTime when) {
    return 'Due: ${DateFormat.yMd().add_jm().format(when)}';
  }
}