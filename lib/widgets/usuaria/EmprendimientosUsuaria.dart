import 'package:flutter/material.dart';
import 'package:pink_car/client/Consultar.dart';
import 'package:pink_car/client/Model/EmprendimientoModel.dart';
import 'package:pink_car/widgets/usuaria/drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class Emprendimientos extends StatefulWidget {
  final int id;
  Emprendimientos({Key? key, required this.id}) : super(key: key);

  @override
  _EmprendimientosState createState() => _EmprendimientosState();
}

class _EmprendimientosState extends State<Emprendimientos> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _imagenLinkController = TextEditingController();
  late List<EmprendimientoModel> _emprendimientos = [];
  final _consultar = ConsultarAPI();

  @override
  void initState() {
    super.initState();
    _consultarEmprendimientos();
  }

  Future<void> _consultarEmprendimientos() async {
    try {
      _emprendimientos = await _consultar.getEmprendimientos(
          widget.id); // Obtener emprendimientos desde la API
      setState(() {}); // Actualizar la interfaz con los datos obtenidos
    } catch (e) {
      print('Error al consultar emprendimientos: $e');
    }
  }

  Future<void> _agregarEmprendimiento() async {
    String descripcion = _descripcionController.text;
    String imagenLink = _imagenLinkController.text;

    if (descripcion.isEmpty || imagenLink.isEmpty) {
      // alerta
      _consultar.mostrarError(context, "Por favor, complete todos los campos");
      return;
    }

    EmprendimientoModel nuevoEmprendimiento = EmprendimientoModel(
      descripcion: descripcion,
      imagenLink: imagenLink,
    );

    try {
      final respuesta = await _consultar.registrarEmprendimiento(
        descripcion,
        imagenLink,
        widget.id,
      );

      if (respuesta.essatisfactoria == true) {
        _consultar.mostrarError(
            context, "Emprendimiento registrado correctamente",
            title: "Exito!");

        // setear valores
        _descripcionController.text = '';
        _imagenLinkController.text = '';
      } else {
        _consultar.mostrarError(
            // ignore: use_build_context_synchronously
            context,
            respuesta.mensaje ?? "Error al registrar el emprendimiento");
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      _consultar.mostrarError(context, "Error al registrar el emprendimiento");
    } finally {
      setState(() {
        // _isLoading = false;
      });
    }

    _emprendimientos.add(nuevoEmprendimiento);
    _descripcionController.clear();
    _imagenLinkController.clear();
    setState(() {});
  }

  // void _mostrarSnackBar(String message) {
  //   _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(message)));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Emprendimientos', style: TextStyle(color: Colors.white)),
        backgroundColor:
            Colors.pink, // Color de fondo de la barra de navegación
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Formulario para agregar emprendimientos
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Agregar Emprendimiento',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: _descripcionController,
                      decoration: InputDecoration(
                        // color de borde
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.pink),
                        ),
                        labelText: 'Descripción (máximo 20 caracteres)',
                      ),
                      maxLength: 20,
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                        controller: _imagenLinkController,
                        decoration: InputDecoration(
                          labelText: 'Link de Imagen',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.pink),
                          ),
                        ),
                        maxLength: 100000),
                    SizedBox(height: 10.0),
                    ElevatedButton(
                      onPressed: _agregarEmprendimiento,
                      child: Text('Registrar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(), // Separador entre el formulario y la lista de emprendimientos

          // Lista de emprendimientos registrados
          Expanded(
            child: _emprendimientos.isEmpty
                ? Center(child: Text('No hay emprendimientos registrados'))
                : ListView.builder(
                    itemCount: _emprendimientos.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 2.0,
                        margin: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          leading: Image.network(
                            _emprendimientos[index].imagenLink,
                            width: 50.0,
                            height: 50.0,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Image.network(
                                'https://cdn-icons-png.flaticon.com/512/1257/1257249.png',
                                width: 50.0,
                                height: 50.0,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                          title: Text(_emprendimientos[index].descripcion),
                          onTap: () {
                            _launchURL(_emprendimientos[index].imagenLink);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      drawer: DrawerWidget(id: widget.id),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir el enlace $url';
    }
  }
}
