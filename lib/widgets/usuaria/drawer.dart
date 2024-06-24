import 'package:flutter/material.dart';
import 'package:pink_car/widgets/usuaria/BienvenidaUsuaria.dart';
import 'package:pink_car/widgets/usuaria/EmprendimientosUsuaria.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromRGBO(245, 178, 186, 1),
                  Color.fromRGBO(248, 133, 147, 1),
                ],
              ),
            ),
            child: const Text(
              'Menú',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
              ),
            ),
          ),
          ListTile(
            title: const Text('Bienvenida'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Bienvenidausuaria()),
              );
            },
          ),
          ListTile(
            title: const Text('Emprendimientos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Emprendimientos()),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Salir'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
