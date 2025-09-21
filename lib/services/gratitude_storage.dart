import 'package:hive_flutter/hive_flutter.dart';
import 'package:renbo/models/gratitude.dart';

/// A service class to manage gratitude entries using Hive.
///
/// This class provides static methods to initialize the Hive box,
/// add new gratitude entries, and retrieve all existing entries.
class GratitudeStorage {
  static const String _boxName = 'gratitudes';
  static late Box<Gratitude> _box;

  /// Initializes Hive and opens the gratitude box.
  static Future<void> init() async {
    _box = await Hive.openBox<Gratitude>(_boxName);
  }

  /// Adds a new gratitude entry to the box.
  static void addGratitude(Gratitude gratitude) {
    _box.add(gratitude);
  }

  /// Gets all gratitude entries from the box.
  static List<Gratitude> get gratitudes => _box.values.toList();
}
