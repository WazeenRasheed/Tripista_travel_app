import 'package:flutter/material.dart';
import 'Database/database_functions.dart';
import 'Screens/splash_screen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(
        colorSchemeSeed: Colors.white,
      useMaterial3: true
      ),
    );
  }
}
