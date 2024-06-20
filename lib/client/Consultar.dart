import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pink_car/client/Model/UsuarioModel.dart';
import 'package:flutter/material.dart';

class ConsultarAPI {
  final String baseUrl;
  final headers = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
  };

  ConsultarAPI({this.baseUrl = 'https://localhost:7296'});

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

  Future<void> mostrarError(BuildContext context, String mensaje) {
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
            'Error',
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
              },
            ),
          ],
        );
      },
    );
  }
}
