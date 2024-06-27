import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pink_car/widgets/usuaria/BienvenidaUsuaria.dart';
import 'package:pink_car/widgets/usuaria/EmprendimientosUsuaria.dart';
import 'package:pink_car/widgets/usuaria/drawer.dart';
import 'package:pink_car/widgets/usuaria/footerCard.dart';
import 'package:url_launcher/url_launcher.dart';

class LayoutUsuaria extends StatelessWidget {
  final String title; // Título de la vista
  final Widget child; // Contenido dinámico de la vista
  int id;

  LayoutUsuaria(
      {this.title = "", this.child = const SizedBox(), this.id = 15});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final List<Map<String, String>> imageData = [
    {
      'url':
          'https://1.bp.blogspot.com/-Vz4DEENhYsI/XsABISxWl1I/AAAAAAAAcv8/dN9G4YsJG3gXCyc46LT-_n911qmmvsdjwCLcBGAsYHQ/s1600/E5.jpg',
      'title': 'Imagen 1',
      'link': 'https://www.ejemplo.com/enlace1',
    },
    {
      'url':
          'https://th.bing.com/th/id/OIP.chm63kcVXEErGRc0j5r4ewHaHc?w=1018&h=1024&rs=1&pid=ImgDetMain',
      'title': 'Imagen 2',
      'link': 'https://www.ejemplo.com/enlace2',
    },
    {
      'url':
          'https://th.bing.com/th/id/OIP.I1_zNHdgcL3_LiOZqs-9IwHaGM?w=800&h=670&rs=1&pid=ImgDetMain',
      'title': 'Imagen 3',
      'link': 'https://www.ejemplo.com/enlace3',
    },
    {
      'url':
          'https://th.bing.com/th/id/OIP.CcgKIfLwMLch1N6KTAB13gHaFw?w=2048&h=1593&rs=1&pid=ImgDetMain',
      'title': 'Imagen 4',
      'link': 'https://www.ejemplo.com/enlace4',
    },
  ];

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
      drawer: DrawerWidget(id: id),
    );
  }
}
