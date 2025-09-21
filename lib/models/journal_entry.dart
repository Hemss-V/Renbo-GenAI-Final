import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'journal_entry.g.dart';

@HiveType(typeId: 0)
class JournalEntry extends HiveObject {
  @HiveField(0)
  String id; // removed final so Hive can assign

  @HiveField(1)
  String content;

  @HiveField(2)
  DateTime timestamp;

  @HiveField(3)
  String? emotion;

  @HiveField(4)
  String? imagePath;

  @HiveField(5)
  String? audioPath;

  JournalEntry({
    String? id,
    required this.content,
    required this.timestamp,
    this.emotion,
    this.imagePath,
    this.audioPath,
  }) : id = id ?? const Uuid().v4();

  String get getId => id;
}