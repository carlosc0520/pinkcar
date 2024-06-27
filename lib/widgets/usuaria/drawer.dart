import 'package:flutter/material.dart';
import 'package:pink_car/client/Consultar.dart';
import 'package:pink_car/client/Model/UsuarioModel.dart';
import 'package:pink_car/widgets/login/Autenticacion.dart';
import 'package:pink_car/widgets/usuaria/BienvenidaUsuaria.dart';
import 'package:pink_car/widgets/usuaria/EmprendimientosUsuaria.dart';

class DrawerWidget extends StatefulWidget {
  final int id;
  DrawerWidget({Key? key, required this.id}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late ConsultarAPI _consultar;
  late UsuarioModel _usuario;

  @override
  void initState() {
    super.initState();
    _consultar = ConsultarAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image.png'), // Aquí debes colocar la ruta de tu imagen de fondo
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 12.0,
                  left: 12.0,
                  child: const Text(
                    'Menú',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Bienvenida'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Bienvenidausuaria(id: widget.id)),
              );
            },
          ),
          ListTile(
            title: const Text('Emprendimientos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Emprendimientos(id: widget.id)),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Salir'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AutenticacionPage()));
            },
          ),
        ],
      ),
    );
  }
}
