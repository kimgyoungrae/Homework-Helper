import 'package:isar/isar.dart';
part 'journal_entry.g.dart';

@collection
class JournalEntry {

  final Id? id;
  final String text;
  final DateTime updatedAt;
  final DateTime createdAt;
  final DateTime? dueDate;
  final String? assignment;
  final String? course;
  final String? instructor;
  final bool? isCompleted;

  factory JournalEntry.fromText({String text = ''}) {
    final when = DateTime.now();
    return JournalEntry(
        text: text,
        id: Isar.autoIncrement,
        updatedAt: when,
        createdAt: when,
        dueDate: when,
        assignment: text,
        course: text,
        instructor: text,
        isCompleted: false
        );
  }

  JournalEntry(
      {required this.text,
      required this.id,
      required this.updatedAt,
      required this.createdAt,
      required this.dueDate,
      required this.assignment,
      required this.course,
      required this.instructor,
      required this.isCompleted,
      });

  JournalEntry.withCurrentTime({
    required this.text,
    Id? id,
    DateTime? dueDate,
    required this.assignment,
    required this.course,
    required this.instructor,
    required this.isCompleted,
  })  : id = id ?? Isar.autoIncrement,
        updatedAt = DateTime.now(),
        createdAt = DateTime.now(),
        dueDate = dueDate ?? DateTime.now();

  // Constructor to create a copy of the current JournalEntry with updated fields
  // Invariant: The copied entry should have the same id as the original
  JournalEntry.withUpdatedText(JournalEntry entry, newText, DateTime newDueDate, String newAssingment, String newCourse, 
  String newInstructor, bool updateCompleted)
      : id = entry.id,
        createdAt = entry.createdAt,
        updatedAt = DateTime.now(),
        text = newText,
        dueDate = newDueDate,
        assignment = newAssingment,
        course = newCourse,
        instructor = newInstructor,
        isCompleted = updateCompleted;

}

