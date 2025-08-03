import 'package:isar/isar.dart';

part 'habit.g.dart';
@Collection()

class Habit {
  //Id del hábito, se incrementa automáticamente
  Id id= Isar.autoIncrement;
  //Nombre del hábito
  late String name;

  //Dias completados del hábito
  List<DateTime> completedDays = [
    // DateTime(year, month, day)
  ];
}
