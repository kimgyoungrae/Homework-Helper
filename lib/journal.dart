
import 'package:journal/journal_entry.dart';
import 'package:isar/isar.dart';

class Journal {
  List<JournalEntry> _entries = [];

  final Isar _isar;

  Journal(Isar isar) : _isar = isar {
    _entries = _isar.journalEntrys.where().findAllSync();
  }

  List<JournalEntry> get entries => List.from(_entries);

  void upsertEntry(JournalEntry entry) {
    final int index = _entries.indexWhere((e) => e.id == entry.id);
    if (index == -1) {
      _entries.add(entry);
    } else {
      _entries[index] = entry;
    }
    _isar.writeTxnSync(() => _isar.journalEntrys.putSync(entry));
  }

  Journal clone() {
    final Journal clonedJournal = Journal(_isar);
    clonedJournal._entries = List.from(_entries);
    return clonedJournal;
  }
}