import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habit_tracker/util/appcolors.dart';

class HabitTile extends StatelessWidget {
  final bool isCompleted;
  final String text;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;

  const HabitTile({super.key, required this.isCompleted, required this.text, this.onChanged, this.editHabit, this.deleteHabit});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          //Opciones
          //Editar
          SlidableAction(onPressed: editHabit,
          backgroundColor: AppColors.editColor,
          icon: Icons.edit,
          borderRadius: BorderRadius.circular(8.0),
          label: 'Editar',
          ),
          //Borrar
          SlidableAction(onPressed: deleteHabit,
          backgroundColor: AppColors.deleteColor,
          icon: Icons.delete,
          borderRadius: BorderRadius.circular(8.0),
          label: 'Borrar',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          if (onChanged != null) {
            onChanged!(!isCompleted);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color:
                isCompleted
                    ? AppColors.checkColor
                    : Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.all(5.0),
        
          child: ListTile(
            title: Text(text),
            leading: Checkbox(
              activeColor: AppColors.checkColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              value: isCompleted,
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }
}
