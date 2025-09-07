import 'package:flutter/material.dart';
import 'package:habit_tracker/models/app_settings.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HabitDatabase extends ChangeNotifier {
  static Database? _db;

  // Inicializar la base de datos
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, "habits.db");

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Tabla de AppSettings
        await db.execute('''
          CREATE TABLE app_settings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            firstLaunch INTEGER
          )
        ''');

        // Tabla de Habits
        await db.execute('''
          CREATE TABLE habits (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            completedDays TEXT
          )
        ''');
      },
    );
  }

  // ========== APP SETTINGS ==========

  Future<void> saveFirstLaunch() async {
    final db = _db!;
    final res = await db.query("app_settings", limit: 1);
    if (res.isEmpty) {
      final settings = AppSettings(firstLaunch: DateTime.now());
      await db.insert("app_settings", settings.toMap());
    }
  }

  Future<DateTime?> getFirstLaunchDate() async {
    final db = _db!;
    final res = await db.query("app_settings", limit: 1);
    if (res.isNotEmpty) {
      return AppSettings.fromMap(res.first).firstLaunch;
    }
    return null;
  }

  // ========== HABITS CRUD ==========

  final List<Habit> currentHabits = [];

  Future<void> addHabit(String habitName) async {
    final db = _db!;
    final newHabit = Habit(name: habitName);
    await db.insert("habits", newHabit.toMap());
    await readHabits();
  }

  Future<void> readHabits() async {
    final db = _db!;
    final res = await db.query("habits");
    currentHabits.clear();
    currentHabits.addAll(res.map((e) => Habit.fromMap(e)).toList());
    notifyListeners();
  }

  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    final db = _db!;
    final res = await db.query("habits", where: "id = ?", whereArgs: [id]);
    if (res.isNotEmpty) {
      final habit = Habit.fromMap(res.first);
      final today = DateTime.now();

      if (isCompleted &&
          !habit.completedDays.any((d) =>
              d.year == today.year && d.month == today.month && d.day == today.day)) {
        habit.completedDays.add(DateTime(today.year, today.month, today.day));
      } else {
        habit.completedDays.removeWhere((d) =>
            d.year == today.year && d.month == today.month && d.day == today.day);
      }

      await db.update("habits", habit.toMap(), where: "id = ?", whereArgs: [id]);
    }
    await readHabits();
  }

  Future<void> updateHabitName(int id, String newName) async {
    final db = _db!;
    await db.update(
      "habits",
      {"name": newName},
      where: "id = ?",
      whereArgs: [id],
    );
    await readHabits();
  }

  Future<void> deleteHabit(int id) async {
    final db = _db!;
    await db.delete("habits", where: "id = ?", whereArgs: [id]);
    await readHabits();
  }
}
