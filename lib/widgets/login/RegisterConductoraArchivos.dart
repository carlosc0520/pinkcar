import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';

import 'package:pink_car/client/Consultar.dart';

class ConductoraDatos {
  final String numeroPlaca;
  final String numeroSerie;
  final String color;
  final String modelo;
  final String titular;
  final String marca;
  final Map<String, File?> archivos;
  final Map<String, String> base64Archivos;

  ConductoraDatos({
    required this.numeroPlaca,
    required this.numeroSerie,
    required this.color,
    required this.modelo,
    required this.titular,
    required this.marca,
    required this.archivos,
    Map<String, String>? base64Archivos, // Cambiado para permitir nulo
  }) : base64Archivos = base64Archivos ??
            {
              "LICENCIA": "",
              "SOAT": "",
              "CERTIJOVEN": "",
              "DNI": "",
            };
}

class RegisterConductoraArchivos extends StatefulWidget {
  final Map<String, dynamic> datos;

  const RegisterConductoraArchivos({Key? key, required this.datos})
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
  final Map<String, File?> _archivos = {
    'LICENCIA': null,
    'SOAT': null,
    'CERTIJOVEN': null,
    'DNI': null,
  };

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
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      _buildSectionLabel('DATOS VEHÍCULO'),
                      const SizedBox(height: 20.0),
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
                      const SizedBox(height: 20.0),
                      _buildFileInput(
                          label: 'Licencia de Conducir', key: 'LICENCIA'),
                      _buildFileInput(label: 'SOAT', key: 'SOAT'),
                      _buildFileInput(label: 'Certijoven', key: 'CERTIJOVEN'),
                      _buildFileInput(label: 'DNI', key: 'DNI'),
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
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            SizedBox(width: 10.0), // Espacio entre el label y el TextFormField
            Expanded(
              flex: 7,
              child: TextFormField(
                controller: controller,
                validator: validator,
                decoration: InputDecoration(
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
                  errorStyle: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }

  Widget _buildFileInput({required String label, required String key}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            SizedBox(width: 10.0), // Espacio entre el label y el InkWell
            Expanded(
              flex: 7,
              child: InkWell(
                onTap: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.image,
                  );

                  if (result != null) {
                    setState(() {
                      _archivos[key] = File(result.files.single.path!);
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 238, 82, 100)
                        .withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: const Color.fromARGB(255, 238, 82, 100),
                      width: 2.0,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.attach_file,
                          color: const Color.fromARGB(255, 255, 255, 255)),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Text(
                          _archivos[key]?.path ?? 'Subir archivo',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }

  void _handleContinuar() async {
    if (_formKey.currentState!.validate()) {
      final conductoraDatos = ConductoraDatos(
        numeroPlaca: _numeroPlacaController.text.trim(),
        numeroSerie: _numeroSerieController.text.trim(),
        color: _colorController.text.trim(),
        modelo: _modeloController.text.trim(),
        titular: _titularController.text.trim(),
        marca: _marcaController.text.trim(),
        archivos: _archivos,
      );

      // Iterar sobre los archivos y convertir a base64
      for (var entry in conductoraDatos.archivos.entries) {
        final key = entry.key;
        final archivo = entry.value;
        if (archivo != null) {
          final bytes = await archivo.readAsBytes();
          final base64Archivo = base64Encode(bytes);
          conductoraDatos.base64Archivos[key] = base64Archivo;
        }
      }

      // Aquí se realiza la llamada a la API con los datos, incluyendo los archivos base64
      final _consultar = ConsultarAPI();
      final response = await _consultar.postConductora(
        widget.datos['NOMBRES'],
        widget.datos['EMAIL'],
        widget.datos['CELULAR'],
        widget.datos['DNI'],
        widget.datos['PASSWORD'],
        conductoraDatos.numeroPlaca,
        conductoraDatos.numeroSerie,
        conductoraDatos.color,
        conductoraDatos.modelo,
        conductoraDatos.titular,
        conductoraDatos.marca,
        conductoraDatos.base64Archivos['LICENCIA']!,
        conductoraDatos.base64Archivos['SOAT']!,
        conductoraDatos.base64Archivos['CERTIJOVEN']!,
        conductoraDatos.base64Archivos['DNI']!,
      );

      
      }
  }
}
