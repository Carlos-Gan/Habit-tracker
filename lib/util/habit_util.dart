// Utilidades para el manejo de hábitos

import 'package:habit_tracker/models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any(
    (date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day,
  );
}

//Preparar el mapa de calor
Map<DateTime, int> prepareHeatMapData(List<Habit> habits) {
  Map<DateTime, int> dataset = {};
  for (var habit in habits) {
    for (var date in habit.completedDays) {
      //Normalizar la fecha para evitar problemas de hora
      final normalizeDate = DateTime(date.year, date.month, date.day);
      //Si la fecha ya existe, incrementar el contador
      if (dataset.containsKey(normalizeDate)) {
        dataset[normalizeDate] = dataset[normalizeDate]! + 1;
      } else {
        // Si la fecha no existe, agregarla con un contador de 1
        dataset[normalizeDate] = 1;
      }
    }
  }
  return dataset;
}
