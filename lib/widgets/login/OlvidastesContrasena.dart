import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pink_car/client/Consultar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'dart:convert';

import 'package:pink_car/widgets/login/ValidacionCodigo.dart';

class Olvidastescontrasena extends StatefulWidget {
  final int tipo;

  const Olvidastescontrasena({super.key, this.tipo = 1});

  @override
  // ignore: library_private_types_in_public_api
  _OlvidastescontrasenaState createState() => _OlvidastescontrasenaState();
}

class _OlvidastescontrasenaState extends State<Olvidastescontrasena> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _consultar = ConsultarAPI();

  bool _isLoading = false;

  void _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text.trim();

      try {
        final respuesta = await _consultar.recovery(email);
        if (respuesta.status == true) {
          // ignore: use_build_context_synchronously
          _consultar.mostrarError(context, respuesta.message, title: "Éxito",
              onOkPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Recovery(tipo: widget.tipo, email: email)),
            );
          }); 
        } else {
          // ignore: use_build_context_synchronously
          _consultar.mostrarError(context, respuesta.message);
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        _consultar.mostrarError(context, e.toString());
      } finally {
        setState(() {
          _isLoading = false; // Ocultar spinner de carga
        });
      }
    }
  }

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
          ModalProgressHUD(
            inAsyncCall:
                _isLoading, // Mostrar spinner de carga si _isLoading es true
            progressIndicator:
                const CircularProgressIndicator(), // Indicador de carga
            child: Positioned.fill(
              child: Container(
                color: const Color.fromARGB(255, 145, 145, 145)
                    .withOpacity(0.4), // Fondo oscuro transparente
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(bottom: 20.0, top: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.white, width: 13.0),
                          ),
                          child: Image.asset(
                            'assets/image.png',
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.tipo == 1
                                    ? 'Recuperar \nContraseña\n Usuaria'
                                    : 'Recuperar \nContraseña\n Conductora',
                                // centrar
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFD94A0),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              const Text(
                                'Ingrese los siguientes datos',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Email',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  fillColor: Color(0xFFF5F5F5),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(
                                          255, 255, 180, 189), // Borde rosado
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2.5,
                                      color: Color.fromARGB(
                                          255, 255, 180, 189), // Borde rosado
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, ingrese su email';
                                  }
                                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                      .hasMatch(value)) {
                                    return 'Por favor, ingrese un email válido';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20.0),
                              ElevatedButton(
                                onPressed: _handleSignIn,
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFFFEEB7),
                                        Color(0xFFFFB4EE)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 24.0),
                                    child: Text(
                                      'Enviar código',
                                      style: GoogleFonts.montserrat(
                                        color: const Color.fromARGB(
                                            255, 56, 56, 56),
                                        fontWeight: FontWeight.w900,
                                        fontSize: 17.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
