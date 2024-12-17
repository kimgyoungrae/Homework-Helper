import 'package:flutter/material.dart';
import 'package:journal/journal_entry.dart';
import 'package:journal/journal_provider.dart';
import 'package:journal/all_entries_view.dart';
import 'package:provider/provider.dart';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([JournalEntrySchema], directory: dir.path);
  runApp(
    ChangeNotifierProvider(
      create: (context) => JournalProvider(isar),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journal App',
      debugShowCheckedModeBanner: false, // to not block the + buttong
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: AllEntriesView(journal: Provider.of<JournalProvider>(context).journal),
    );
  }
}
