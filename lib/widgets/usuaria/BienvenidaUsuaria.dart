import 'package:flutter/material.dart';
import 'package:pink_car/client/Consultar.dart';
import 'package:pink_car/client/Model/CodigoModel.dart';
import 'package:pink_car/client/Model/UsuarioModel.dart';
import 'package:pink_car/widgets/usuaria/Viaje.dart';
import 'package:pink_car/widgets/usuaria/drawer.dart';
import 'package:pink_car/widgets/usuaria/footerCard.dart';
import 'package:url_launcher/url_launcher.dart';

class Bienvenidausuaria extends StatefulWidget {
  final int id;

  Bienvenidausuaria({Key? key, required this.id}) : super(key: key);

  @override
  _BienvenidausuariaState createState() => _BienvenidausuariaState();
}

class _BienvenidausuariaState extends State<Bienvenidausuaria> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _isLoading = true;
  UsuarioModel _usuario = UsuarioModel();
  List<CodigoModel> _datos = [];
  final ConsultarAPI _consultar = ConsultarAPI();

  @override
  void initState() {
    super.initState();
    _loadUsuario();
    _consultarAPI();
  }

  Future<void> _loadUsuario() async {
    try {
      _usuario = await _consultar.getUsuarioUser(widget.id);
    } catch (e) {
      print('Error al cargar el usuario: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _consultarAPI() async {
    try {
      // Simulando una consulta a la API para obtener códigos
      _datos = []; // Aquí deberías implementar la lógica real para obtener los datos
    } catch (e) {
      print('Error al consultar los datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  "Bienvenida ${_usuario.nombres ?? ''}",
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
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(20.0),
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hola, ${_usuario.nombres ?? ''}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          'Bienvenida',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Image.asset(
                          'assets/image4.png',
                          width: 50.0,
                          height: 50.0,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 20.0),
                        _buildCuponWidget(),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            _iniciarViaje();
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
      drawer: DrawerWidget(id: widget.id),
    );
  }

  Widget _buildCuponWidget() {
    return _datos.isNotEmpty
        ? Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.pink[100],
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
                  'Tienes un cupón para tu próximo viaje: ${_datos[0].codigo}',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          )
        : Text(
            'Inicia tu próximo viaje ya',
            style: TextStyle(
              fontSize: 14.0,
            ),
          );
  }

  void _iniciarViaje() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Viaje(id: widget.id)),
    );
  }
}

