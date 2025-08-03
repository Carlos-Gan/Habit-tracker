import 'package:flutter/material.dart';
import 'package:habit_tracker/components/drawer.dart';
import 'package:habit_tracker/components/habit_tile.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/util/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    //Leer los habitos existentes el la app
    Provider.of<HabitDatabase>(context, listen: false).readHabits();

    super.initState();
  }

  // Controlador para el campo de texto del nuevo hábito
  final TextEditingController _habitController = TextEditingController();

  // Método para crear un nuevo hábito
  void createNewHabit() {
    showAdaptiveDialog(
      context: context,
      builder:
          (context) => AlertDialog.adaptive(
            title: const Text('Nuevo Hábito'),
            content: TextField(
              controller: _habitController,
              decoration: const InputDecoration(labelText: 'Nombre del hábito'),
            ),
            actions: [
              // Botón para cancelar la creación del hábito
              MaterialButton(
                onPressed: () {
                  // Cerrar el diálogo sin hacer nada
                  Navigator.of(context).pop();
                  // Limpiar el controlador
                  _habitController.clear();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Text('Cancelar'),
              ),
              // Botón para guardar el nuevo hábito
              MaterialButton(
                onPressed: () {
                  //Obtener el nombre del hábito
                  String habitName = _habitController.text.trim();
                  //Guardar en la bd
                  context.read<HabitDatabase>().addHabit(habitName);
                  //Cierrar el diálogo
                  Navigator.of(context).pop();
                  // Limpiar el controlador
                  _habitController.clear();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Text('Guardar'),
              ),
            ],
          ),
    );
  }

  // Método para marcar un hábito como completado o no
  void checkHabitOnOff(bool? value, Habit habit) {
    // Actualizar el estado del hábito en la base de datos
    if( value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      body: _buildHabitList(),
    );
  }

  // Método para construir la lista de hábitos
  Widget _buildHabitList() {
    //Base de datos de hábitos
    final habitDatabase = context.watch<HabitDatabase>();
    final currentHabits = habitDatabase.currentHabits;

    if (currentHabits.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'No hay hábitos todavía.\n Presiona + para agregar uno.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: currentHabits.length,
      itemBuilder: (context, index) {
        final habit = currentHabits[index];
        final isCompletedToday = isHabitCompletedToday(habit.completedDays);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: HabitTile(isCompleted: isCompletedToday, text: habit.name, onChanged: (value) => checkHabitOnOff(value, habit)),
        );
      },
    );
  }
}
