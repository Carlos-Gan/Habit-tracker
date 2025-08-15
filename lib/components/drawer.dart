import 'package:flutter/material.dart';
import 'package:habit_tracker/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    //final localizations = AppLocalizations.of(context)!;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Text(
              'Habit Tracker',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Modo oscuro"),
                    const Spacer(),
                    // Switch para cambiar el tema
                    Switch(
                      value: Provider.of<ThemeProvider>(context).isDarkMode,
                      onChanged: (value) {
                        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Mostrar texto en el HeatMap'),
                    const Spacer(),
                    // Switch para mostrar el texto en el HeatMap
                    Switch(
                      value: Provider.of<ThemeProvider>(context).showHeatMapText,
                      onChanged: (value) {
                        Provider.of<ThemeProvider>(context, listen: false).toggleHeatMapText();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Acerca de'),
            onTap: () {
              // Show about dialog
            },
          ),
        ],
      ),
    );
  }
}