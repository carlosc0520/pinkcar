import 'package:flutter/material.dart';
import 'package:pink_car/client/Model/CodigoModel.dart';
import 'package:pink_car/widgets/usuaria/Viaje.dart';
import 'package:pink_car/widgets/usuaria/drawer.dart';
import 'package:pink_car/widgets/usuaria/footerCard.dart';
import 'package:pink_car/client/Consultar.dart';
import 'package:url_launcher/url_launcher.dart';

class Bienvenidausuaria extends StatefulWidget {
  final int id;
  Bienvenidausuaria({Key? key, this.id = 18}) : super(key: key);

  @override
  _BienvenidausuariaState createState() => _BienvenidausuariaState();
}

class _BienvenidausuariaState extends State<Bienvenidausuaria> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool isLoading = true;
  late List<CodigoModel> datos = [];
  final _consultar = ConsultarAPI();

  @override
  void initState() {
    super.initState();
    _consultarAPI();
  }

  Future<void> _consultarAPI() async {
    try {
      // datos = await _consultar.getCodigos(widget.id);
      // / datos null
      datos = [];
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

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
                  "Bienvenida ...", // Título específico para esta pantalla
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
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(20.0),
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hola, Nombre', // Aquí puedes obtener el nombre del usuario si lo tienes disponible
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          'Bienvenida', // Mensaje de bienvenida
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Image.asset(
                          'assets/image4.png', // Ruta de la imagen que deseas mostrar
                          width: 50.0,
                          height: 50.0,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 20.0),
                        datos.isNotEmpty
                            ? Container(
                                padding: EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: Colors
                                      .pink[100], // Color del cuadro rosado
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                      datos.isNotEmpty
                                          ? 'Tienes un cupón para tu próximo viaje: ${datos[0].codigo}' // Mensaje si hay datos de cupón
                                          : 'Inicia tu próximo viaje ya', // Mensaje si no hay datos de cupón
                                      style: TextStyle(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Text(
                                'Inicia tu próximo viaje ya', // Mensaje si no hay datos de cupón
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            _iniciarViaje(); // Función para iniciar el viaje
                          },
                          child: Text('Iniciar Viaje'),
                        ),
                      ],
                    ),
                  ),
          ),
          FooterCard(),
        ],
      ),
      drawer: DrawerWidget(),
    );
  }

  void _iniciarViaje() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Viaje()),
    );
  }
}
