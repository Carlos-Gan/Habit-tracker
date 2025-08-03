import 'package:flutter/material.dart';
import 'package:habit_tracker/models/app_settings.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  // Aquí puedes definir los métodos para interactuar con la base de datos
  static late Isar isar;

  //Setup

  //Inicializar la base de datos
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.openSync(
       [HabitSchema, AppSettingsSchema],
      directory: dir.path,
    );
  }

  //Guardar primer lanzamiento para el heatmap
  Future<void> saveFirstLaunch() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunch = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  //Obtener primer lanzamiento para el heatmap
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunch;
  }
  //C R U D Operaciones

  //Lista de hábitos
  final List<Habit> currentHabits = [];
  //CREATE. Crear un nuevo hábito
  Future<void> addHabit(String habitName) async {
    //Crear un nuevo hábito
    final newHabit = Habit()..name = habitName;

    //Guardar el nuevo hábito en la base de datos
    await isar.writeTxn(() => isar.habits.put(newHabit));

    //Re-leer de la bd
    readHabits();
  }

  //READ. Leer un hábito
  Future<void> readHabits() async {
    //Leer todos los hábitos de la base de datos
    List<Habit> fetchedHabits = await isar.habits.where().findAll();
    //Dar los habitos actuales
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);
    //Actualizar UI
    notifyListeners();
  }

  //UPDATE. Actualizar un hábito
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    //Encontrar el hábito específico por ID
    final habit = await isar.habits.get(id);
    //Actualizar el estado de completado del hábito
    if (habit != null) {
      await isar.writeTxn(() async {
        //Si esta completado -> agregar fecha a la lista de completedDays
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          //Hoy
          final today = DateTime.now();

          //Agregar la fecha de hoy a completedDays
          habit.completedDays.add(DateTime(today.year, today.month, today.day));

          //Si no se completa -> eliminar fecha de la lista de completedDays
        } else {
          //Eliminar la fecha de hoy de completedDays
          habit.completedDays.removeWhere(
            (date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day,
          );
        }
        //Guardar los cambios en la base de datos
        await isar.habits.put(habit);
      });
    }
    //Releer los hábitos actualizados de la base de datos
    readHabits();
  }

  //UPDATE. Editar un hábito
  Future<void> updateHabitName(int id, String newName) async {
    //Encntrar el hábito específico por ID
    final habit = await isar.habits.get(id);
    //Actualizar el nombre del hábito
    if (habit != null) {
      //Actualizar el nombre del hábito
      await isar.writeTxn(() async {
        habit.name = newName;
        //Guardar los cambios en la base de datos
        await isar.habits.put(habit);
      });
    }
    //Re-leer los hábitos actualizados de la base de datos
    readHabits();
  }

  //DELETE. Eliminar un hábito
  Future<void> deleteHabit(int id) async {
    //Eliminar el hábito específico por ID
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
    //Re-leer los hábitos actualizados de la base de datos
    readHabits();
  }
}
