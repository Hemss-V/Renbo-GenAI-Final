import 'package:hive/hive.dart';

part 'gratitude.g.dart';

/// A model class for a single gratitude entry.
///
/// It uses Hive for local data storage and is defined with
/// a typeId of 1 to differentiate it from JournalEntry.
@HiveType(typeId: 1)
class Gratitude extends HiveObject {
  @HiveField(0)
  late String text;

  @HiveField(1)
  late DateTime timestamp;

  Gratitude({required this.text, required this.timestamp});
}
