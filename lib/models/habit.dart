class Habit {
  int? id;
  String name;
  List<DateTime> completedDays;

  Habit({
    this.id,
    required this.name,
    this.completedDays = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      // Guardamos las fechas como una lista separada por comas en string
      'completedDays': completedDays.map((d) => d.toIso8601String()).join(','),
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      completedDays: map['completedDays'] != null && map['completedDays'] != ""
          ? (map['completedDays'] as String)
              .split(',')
              .map((s) => DateTime.parse(s))
              .toList()
          : [],
    );
  }
}
