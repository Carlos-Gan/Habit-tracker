import 'package:flutter/material.dart';
import 'package:habit_tracker/theme/dark_mode.dart';
import 'package:habit_tracker/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  //Predeterminado el modo claro
  ThemeData _themeData = lightMode;

  //Obtener el tema actual
  ThemeData get themeData => _themeData;

  //Booleano para saber si es el modo oscuro
  bool get isDarkMode => _themeData == darkMode;

  //Cambiar el tema
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners(); // Notificar a los oyentes que el tema ha cambiado
  }

  //Cambiar entre modo claro y oscuro
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode; // Cambiar a modo oscuro
    } else {
      themeData = lightMode; // Cambiar a modo claro
    }
  }
  //Booleano para mostrar el texto en el HeatMap
  bool _showHeatMapText = false;
  bool get showHeatMapText => _showHeatMapText;
  //Cambiar el estado del texto en el HeatMap
  void toggleHeatMapText() {
    _showHeatMapText = !_showHeatMapText;
    notifyListeners(); // Notificar a los oyentes que el estado ha cambiado
  }
}
