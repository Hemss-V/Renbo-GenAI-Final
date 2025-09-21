import 'package:hive_flutter/hive_flutter.dart';
import '../models/journal_entry.dart';

class JournalStorage {
  static const String _boxName = 'journalEntries';
  static late Box<JournalEntry> _box;

  static Future<void> init() async {
    _box = await Hive.openBox<JournalEntry>(_boxName);
  }

  static Future<void> addEntry(JournalEntry entry) async {
    await _box.put(entry.getId, entry);
  }

  static Future<void> updateEntry(JournalEntry entry) async {
    await _box.put(entry.getId, entry);
  }

  static Future<void> deleteEntry(String id) async {
    await _box.delete(id);
  }

  static Future<List<JournalEntry>> getEntries() async {
    var entries = _box.values.toList();
    entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return entries;
  }
}
