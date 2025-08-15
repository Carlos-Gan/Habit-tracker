import 'package:flutter/material.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializar la base de datos
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunch();
  runApp(
    MultiProvider(
      providers: [
        //Provedor de habitos
        ChangeNotifierProvider(create: (_) => HabitDatabase()),

        // Proveedor de tema
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const[
        // Agregar delegados de localización si es necesario
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // Inglés
        Locale('es'), // Español
        // Agregar más locales si es necesario
         Locale('fr'), // Francés
         Locale('de'), // Alemán
         Locale('zh'), // Chino
         Locale('ja'), // Japonés
      ],
      home: HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
