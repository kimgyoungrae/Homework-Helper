import 'package:flutter/material.dart';
import 'package:journal/journal_entry.dart';

// Shows a single journal entry and allows the user to edit it.
class JournalView extends StatefulWidget {
  final JournalEntry entry;

  const JournalView({super.key, required this.entry});

  @override
  State<JournalView> createState() => _JournalViewState();
}

class _JournalViewState extends State<JournalView> {
  late TextEditingController courseController;
  late TextEditingController instructorController;
  late TextEditingController assignmentController;
  late TextEditingController textController;
  DateTime? currentDueDate;

  @override
  void initState() {
    super.initState();
    courseController = TextEditingController(text: widget.entry.course);
    instructorController = TextEditingController(text: widget.entry.instructor);
    assignmentController = TextEditingController(text: widget.entry.assignment);
    textController = TextEditingController(text: widget.entry.text);
    currentDueDate = widget.entry.dueDate;
  }

  @override
  void dispose() {
    courseController.dispose();
    instructorController.dispose();
    assignmentController.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _popBack(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.entry.assignment ?? 'New Entry'),
          backgroundColor: Colors.cyan[600],
        ),
        body: Container(
          color: Colors.cyan[50],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Enter Course',
                    border: UnderlineInputBorder(),
                  ),
                  controller: courseController,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Enter Instructor',
                    border: UnderlineInputBorder(),
                  ),
                  controller: instructorController,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Enter Assignment',
                    border: UnderlineInputBorder(),
                  ),
                  controller: assignmentController,
                ),
                const SizedBox(height: 16),
                TextField(
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Enter Assignment Notes',
                    border: OutlineInputBorder(),
                  ),
                  controller: textController,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _selectDueDate(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan[600],
                  ),
                  child: const Text('Select Due Date', style: TextStyle(color: Colors.white),
                )),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _selectDueTime(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan[600],
                  ),
                  child: const Text('Select Due Time', style: TextStyle(color: Colors.white),
                )),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.cyan[900]!,
              onPrimary: Colors.white,
              onSurface: Colors.cyan[900]!,
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != currentDueDate) {
      setState(() {
        currentDueDate = picked;
      });
    }
  }

  Future<void> _selectDueTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentDueDate ?? DateTime.now()),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.cyan[900]!,
              onPrimary: Colors.white,
              onSurface: Colors.cyan[900]!,
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        currentDueDate = DateTime(
          currentDueDate!.year,
          currentDueDate!.month,
          currentDueDate!.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  void _popBack(BuildContext context) {
    final newEntry = JournalEntry(
      text: textController.text,
      dueDate: currentDueDate,
      assignment: assignmentController.text,
      course: courseController.text,
      instructor: instructorController.text,
      isCompleted: widget.entry.isCompleted,
      createdAt: widget.entry.createdAt,
      updatedAt: DateTime.now(),
      id: widget.entry.id,
    );
    Navigator.pop(context, newEntry);
  }
}
