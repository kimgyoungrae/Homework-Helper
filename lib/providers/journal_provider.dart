import 'package:flutter/material.dart';
import 'package:journal/models/journal.dart';
import 'package:journal/models/journal_entry.dart';
import 'package:isar/isar.dart';

class JournalProvider extends ChangeNotifier {
  final Journal _journal;


  JournalProvider(Isar isar) : _journal = Journal(isar);

  Journal get journal => _journal.clone();

  void upsertJournalEntry(JournalEntry entry) {
    _journal.upsertEntry(entry);
    notifyListeners();
  }

}
