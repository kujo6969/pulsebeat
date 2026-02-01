import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing3/screens/home/home.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PulseBeat',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: .fromSeed(
          seedColor: Color.fromRGBO(250, 172, 179, 1),
          primary: Color.fromRGBO(231, 92, 124, 1),
          secondary: Color.fromRGBO(124, 0, 0, 1),
          tertiary: Color.fromRGBO(204, 68, 92, 1),
          surface: Color.fromRGBO(250, 172, 179, 0.9),
          brightness: Brightness.light,
        ),
      ),

      home: const HomePage(),
    );
  }
}
