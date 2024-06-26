import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pink_car/client/Model/CodigoModel.dart';
import 'package:pink_car/client/Model/EmprendimientoModel.dart';
import 'package:pink_car/client/Model/StatusQueryModel.dart';
import 'package:pink_car/client/Model/StatusResponseModel.dart';
import 'package:pink_car/client/Model/TripDetails.dart';
import 'package:pink_car/client/Model/UsuarioModel.dart';
import 'package:flutter/material.dart';

class ConsultarAPI {
  final String baseUrl;
  final headers = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
  };

  ConsultarAPI({this.baseUrl = 'http://devcar0520-001-site14.etempurl.com'});
  // ConsultarAPI({this.baseUrl = 'https://localhost:7296'});
// http://devcar0520-001-site14.etempurl.com/pinkcar/obtener-usuario
  Future<UsuarioModel> getUsuario(String email, String password) async {
    final uri = Uri.parse(baseUrl).replace(
      path: '/pinkcar/obtener-usuario',
      queryParameters: {
        'EMAIL': email,
        'PASSWORD': password,
      },
    );

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      return UsuarioModel.fromJson(responseBody);
    } else {
      throw Exception('Failed to load usuario');
    }
  }

  // lista de getEmprendimientos
  Future<List<EmprendimientoModel>> getEmprendimientos(int ID) async {
    final uri = Uri.parse(baseUrl)
        .replace(path: '/pinkcar/obtener-emprendimientos', queryParameters: {
      'ID': ID.toString(),
    });

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);

      List<EmprendimientoModel> emprendimientos = [];
      for (var json in jsonResponse) {
        emprendimientos.add(EmprendimientoModel.fromJson(json));
      }

      return emprendimientos;
    } else {
      throw Exception('Failed to load usuario');
    }
  }

  Future<UsuarioModel> getUsuarioUser(int ID) async {
    final uri = Uri.parse(baseUrl).replace(
      path: '/pinkcar/obtener-user',
      queryParameters: {
        'ID': ID.toString(),
      },
    );

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      return UsuarioModel.fromJson(responseBody);
    } else {
      throw Exception('Failed to load usuario');
    }
  }

  Future<Statusresponsemodel> recovery(String email) async {
    final uri = Uri.parse(baseUrl).replace(
      path: '/pinkcar/recovery-usuario',
      queryParameters: {
        'EMAIL': email,
      },
    );

    final response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to recovery usuario');
    }

    Map<String, dynamic> responseBody = jsonDecode(response.body);
    return Statusresponsemodel.fromJson(responseBody);
  }

  Future<Statusresponsemodel> recoveryValidar(
      String email, String codigo) async {
    final uri = Uri.parse(baseUrl).replace(
      path: '/pinkcar/recovery-validar',
      queryParameters: {
        'EMAIL': email,
        'CODIGO': codigo,
      },
    );

    final response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to recovery validar');
    }

    Map<String, dynamic> responseBody = jsonDecode(response.body);
    return Statusresponsemodel.fromJson(responseBody);
  }

  Future<Statusquerymodel> registrarUsuario({
    required String nombres,
    required String email,
    required String celular,
    required String dni,
    required String password,
    required int tipo,
  }) async {
    // peticion GET
    final uri = Uri.parse(baseUrl).replace(
      path: '/pinkcar/registrar-usuario',
      queryParameters: {
        'NOMBRES': nombres,
        'EMAIL': email,
        'CELULAR': celular,
        'DNI': dni,
        'PASSWORD': password,
        'ROLE': tipo.toString(),
      },
    );

    final response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to registrar usuario');
    }

    Map<String, dynamic> responseBody = jsonDecode(response.body);
    return Statusquerymodel.fromJson(responseBody);
  }

  Future<Statusquerymodel> postConductora(
    String nombres,
    String email,
    String celular,
    String dni,
    String password,
    String NUMEROPLACA,
    String NUMEROSERIE,
    String COLOR,
    String MODELO,
    String TITULAR,
    String MARCA,
    String LICENCIA,
    String SOAT,
    String CERTIJOVEN,
    String DNI,
  ) async {
    // ES POST

    final uri = Uri.parse(baseUrl)
        .replace(path: '/pinkcar/registrar-conductora', queryParameters: {
      "NOMBRES": nombres,
      "EMAIL": email,
      "CELULAR": celular,
      "DNI": dni,
      "PASSWORD": password,
      'NUMEROPLACA': NUMEROPLACA,
      'NUMEROSERIE': NUMEROSERIE,
      'COLOR': COLOR,
      'MODELO': MODELO,
      'TITULAR': TITULAR,
      'MARCA': MARCA,
      'LICENCIA': LICENCIA,
      'SOAT': SOAT,
      'CERTIJOVEN': CERTIJOVEN,
      'DNIA': DNI,
    });

    final response = await http.get(uri, headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Failed to registrar usuario');
    }

    Map<String, dynamic> responseBody = jsonDecode(response.body);
    return Statusquerymodel.fromJson(responseBody);
  }

  Future<void> mostrarError(BuildContext context, String mensaje,
      {String title = 'Error', Function? onOkPressed}) {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Evita que se cierre tocando fuera del diálogo
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Fondo blanco
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
          ),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.black, // Texto negro
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  mensaje,
                  style: TextStyle(
                    color: Colors.black87, // Texto negro más suave
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.red, // Botón OK en rojo
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
                if (onOkPressed != null) {
                  onOkPressed(); // Ejecutar la función proporcionada
                }
              },
            ),
          ],
        );
      },
    );
  }

  // CODIGOS *********************************
  Future<List<CodigoModel>> getCodigos(int ID) async {
    final uri = Uri.parse(baseUrl).replace(
      path: '/pinkcar/obtener-codigo',
      queryParameters: {
        'ID': ID.toString(),
      },
    );

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);

      // Mapear la lista de JSON a una lista de CodigoModel
      List<CodigoModel> codigos =
          jsonResponse.map((json) => CodigoModel.fromJson(json)).toList();
      print(codigos);
      return codigos;
    } else {
      throw Exception('Failed to load usuario');
    }
  }

  Future<Statusquerymodel> agregarViaje(TripDetails entidad) async {
    final uri = Uri.parse(baseUrl).replace(
      path: '/pinkcar/registrar-viaje',
      queryParameters: {
        'ORIGEN': entidad.origin,
        'DESTINO': entidad.destination,
        'IDCONDUCTORA': entidad.driverId.toString(),
        'DISTANCIA': entidad.distance.toString(),
        'TOTAL': entidad.total.toString(),
        'IDUSUARIO': entidad.idUsuario.toString(),
      },
    );

    final response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to registrar usuario');
    }

    Map<String, dynamic> responseBody = jsonDecode(response.body);
    return Statusquerymodel.fromJson(responseBody);
  }

  Future<Statusquerymodel> registrarEmprendimiento(
      String descripcion, String imagenLink, int id) async {
    final uri = Uri.parse(baseUrl).replace(
      path: '/pinkcar/registrar-empredimiento',
      queryParameters: {
        'DESCRIPCION': descripcion,
        'IMAGENLINK': imagenLink.toString(),
        'ID': id.toString(),
      },
    );

    final response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to registrar usuario');
    }

    Map<String, dynamic> responseBody = jsonDecode(response.body);
    return Statusquerymodel.fromJson(responseBody);
  }
}
