import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pink_car/widgets/usuaria/BienvenidaUsuaria.dart';
import 'package:pink_car/widgets/usuaria/EmprendimientosUsuaria.dart';
import 'package:pink_car/widgets/usuaria/drawer.dart';
import 'package:pink_car/widgets/usuaria/footerCard.dart';
import 'package:url_launcher/url_launcher.dart';

class Bienvenidausuaria extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              height: 100.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color.fromRGBO(245, 178, 186, 1),
                    Color.fromRGBO(248, 133, 147, 1),
                  ],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                  ),
                  Text(
                    "Bienvenida ..... ", // Título específico para esta pantalla
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child:
                    Column(), // Contenido dinámico específico para esta pantalla
              ),
            ),
            FooterCard()
          ],
        ),
        drawer: DrawerWidget());
  }
}
