import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConductoraDatos {
  final String numeroPlaca;
  final String numeroSerie;
  final String color;
  final String modelo;
  final String titular;
  final String marca;
  final List<File?> archivos;

  ConductoraDatos({
    required this.numeroPlaca,
    required this.numeroSerie,
    required this.color,
    required this.modelo,
    required this.titular,
    required this.marca,
    required this.archivos,
  });
}

class RegisterConductoraArchivos extends StatefulWidget {
  final Map<String, dynamic> datos;

  const RegisterConductoraArchivos({Key? key, this.datos = const {}})
      : super(key: key);

  @override
  _RegisterConductoraArchivosState createState() =>
      _RegisterConductoraArchivosState();
}

class _RegisterConductoraArchivosState
    extends State<RegisterConductoraArchivos> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _numeroPlacaController = TextEditingController();
  final TextEditingController _numeroSerieController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _titularController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  List<File?> _archivos =
      List.generate(4, (_) => null); // Para 4 tipos de archivos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Fondo con imagen
          Image.asset(
            'assets/PinkCar.jpg',
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(255, 145, 145, 145)
                  .withOpacity(0.4), // Fondo oscuro transparente
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 20.0),
                    _buildSectionLabel('DATOS VEHÍCULO'),
                    _buildTextField(
                      label: 'Número de Placa',
                      controller: _numeroPlacaController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese el número de placa';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      label: 'Número de Serie',
                      controller: _numeroSerieController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese el número de serie';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      label: 'Color',
                      controller: _colorController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese el color';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      label: 'Modelo',
                      controller: _modeloController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese el modelo';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      label: 'Titular',
                      controller: _titularController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese el titular';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      label: 'Marca',
                      controller: _marcaController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese la marca';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    _buildSectionLabel('DOCUMENTOS'),
                    _buildFileInput(label: 'Licencia de Conducir', index: 0),
                    _buildFileInput(label: 'SOAT', index: 1),
                    _buildFileInput(label: 'Certijoven', index: 2),
                    _buildFileInput(label: 'DNI', index: 3),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: _handleContinuar,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor:
                            const Color.fromARGB(255, 238, 82, 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 20.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                'Continuar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        label,
        style: GoogleFonts.montserrat(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    FormFieldValidator<String>? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: const InputDecoration(
            fillColor: Color(0xFFF5F5F5),
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 255, 180, 189),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2.5,
                color: Color.fromARGB(255, 255, 180, 189),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }

  Widget _buildFileInput({required String label, required int index}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8.0),
        InkWell(
          onTap: () {
            // Implementar lógica para seleccionar archivo
            // Esto es solo un ejemplo, puedes usar plugins como file_picker para seleccionar archivos
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 180, 189).withOpacity(0.4),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: const Color.fromARGB(255, 255, 180, 189),
                width: 2.0,
              ),
            ),
            child: Row(
              children: <Widget>[
                Icon(Icons.attach_file,
                    color: const Color.fromARGB(255, 238, 82, 100)),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    _archivos[index]?.path ?? 'Subir archivo',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 238, 82, 100),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }

  void _handleContinuar() {
    if (_formKey.currentState!.validate()) {
      // Validaciones pasaron, construir objeto de datos
      final conductoraDatos = ConductoraDatos(
        numeroPlaca: _numeroPlacaController.text.trim(),
        numeroSerie: _numeroSerieController.text.trim(),
        color: _colorController.text.trim(),
        modelo: _modeloController.text.trim(),
        titular: _titularController.text.trim(),
        marca: _marcaController.text.trim(),
        archivos: _archivos,
      );

      // Imprimir los datos para verificar
      print('Datos del Registro de Conductora:');
      print('Número de Placa: ${conductoraDatos.numeroPlaca}');
      print('Número de Serie: ${conductoraDatos.numeroSerie}');
      print('Color: ${conductoraDatos.color}');
      print('Modelo: ${conductoraDatos.modelo}');
      print('Titular: ${conductoraDatos.titular}');
      print('Marca: ${conductoraDatos.marca}');
      print('Archivos:');
      conductoraDatos.archivos.forEach((archivo) {
        if (archivo != null) {
          print('Archivo: ${archivo.path}');
          // Aquí puedes implementar la lógica para subir el archivo a un servidor o almacenarlo localmente
        }
      });

      // Aquí puedes navegar a la siguiente pantalla o realizar otras acciones necesarias
    }
  }
}
