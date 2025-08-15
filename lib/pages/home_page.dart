import 'package:flutter/material.dart';
import 'package:habit_tracker/components/drawer.dart';
import 'package:habit_tracker/components/habit_tile.dart';
import 'package:habit_tracker/components/heat_map.dart';
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
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  // Método para editar un hábito
  void editHabitBox(Habit habit) {
    _habitController.text = habit.name;

    showAdaptiveDialog(
      context: context,
      builder:
          (context) => AlertDialog.adaptive(
            content: TextField(
              controller: _habitController,
              decoration: const InputDecoration(labelText: 'Editar Hábito'),
            ),
            actions: [
              //Boton de cancelar
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _habitController.clear();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Text('Cancelar'),
              ),
              //Boton de guardar
              MaterialButton(
                onPressed: () {
                  //Actualizar el nombre del hábito en la base de datos
                  context.read<HabitDatabase>().updateHabitName(
                    habit.id,
                    _habitController.text.trim(),
                  );
                  Navigator.of(context).pop();
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

  // Metodo para eliminar un hábito
  void deleteHabit(Habit habit) {
    showAdaptiveDialog(
      context: context,
      builder:
          (context) => AlertDialog.adaptive(
            title: const Text('Eliminar Hábito'),
            content: const Text(
              '¿Estás seguro de que quieres eliminar este hábito?',
            ),
            actions: [
              // Botón de cancelar
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Text('Cancelar'),
              ),
              // Botón de eliminar
              MaterialButton(
                onPressed: () {
                  context.read<HabitDatabase>().deleteHabit(habit.id);
                  Navigator.of(context).pop();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );
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
      body: ListView(
        children: [
          //HeatMap
          _buildHeatMap(),
          //Lista de hábitos
          _buildHabitList(),
        ],
      ),
    );
  }

  // Método para construir el HeatMap
  Widget _buildHeatMap() {
    //Base de datos de hábitos
    final habitDatabase = context.watch<HabitDatabase>();
    //Habitos actuales
    List<Habit> currentHabits = habitDatabase.currentHabits;
    //Construir el heatmap
    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        //Cuando los datos están listos -> construir el heatmap
        if (snapshot.hasData) {
          return MyHeatMap(
            startDateNow: snapshot.data!,
            datasets: prepareHeatMapData(currentHabits),
          );
        }
        //Manejar en caso de que no haya datos recibidos
        else {
          return Container();
        }
      },
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
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final habit = currentHabits[index];
        final isCompletedToday = isHabitCompletedToday(habit.completedDays);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
          child: HabitTile(
            isCompleted: isCompletedToday,
            text: habit.name,
            onChanged: (value) => checkHabitOnOff(value, habit),
            // Funciones para editar y eliminar el hábito
            // Editar el hábito
            editHabit: (context) => editHabitBox(habit),
            // Eliminar el hábito
            deleteHabit: (context) => deleteHabit(habit),
          ),
        );
      },
    );
  }
}
