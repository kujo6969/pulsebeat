import 'package:flutter/material.dart';
import 'package:testing3/screens/home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PulseBeat',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: .fromSeed(
          seedColor: Colors.blue,
          primary: Color.fromRGBO(227, 253, 253, 1),
          secondary: Color.fromRGBO(166, 227, 233, 1),
          tertiary: Color.fromRGBO(113, 201, 206, 1),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: .fromSeed(
          seedColor: Color.fromRGBO(45, 60, 89, 1),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}
