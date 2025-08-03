import 'package:flutter/material.dart';
import 'package:habit_tracker/util/appcolors.dart';

class HabitTile extends StatelessWidget {
  final bool isCompleted;
  final String text;
  final void Function(bool?)? onChanged;

  const HabitTile({super.key, required this.isCompleted, required this.text, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    );
  }
}
