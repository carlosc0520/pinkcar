import 'package:flutter/material.dart';
import 'package:pink_car/widgets/login/Autenticacion.dart';
import 'package:pink_car/widgets/login/Bienvenida.dart';
import 'package:pink_car/widgets/login/Inicio.dart';
import 'package:pink_car/widgets/login/Register.dart';
import 'package:pink_car/widgets/usuaria/BienvenidaUsuaria.dart';
import 'package:pink_car/widgets/usuaria/LayoutUsuaria.dart';
import 'package:pink_car/widgets/usuaria/Viaje.dart';

void main() async {
  
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
      home: Viaje(),
    );
  }
}
