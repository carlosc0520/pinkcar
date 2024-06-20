import 'package:flutter/material.dart';
import 'package:pink_car/widgets/login/RegisterConductoraArchivos.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
      ),
      home: RegisterConductoraArchivos(),
    );
  }
}
