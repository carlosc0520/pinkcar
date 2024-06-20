import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Inicio.dart';

class UsuarioPage extends StatelessWidget {
  const UsuarioPage({super.key});

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // imagen borde blanco
                  Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              width: 13.0), // Borde blanco de grosor 2.0
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

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Seleccione el\n tipo de usuario',
                          style: GoogleFonts.montserrat(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 238, 82, 100),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _navigateToInicioPage(context,
                                    'Bienvenido a la \n app para Usuarias', 1);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 25.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 255, 175, 184),
                                          width: 3),
                                      color: const Color.fromARGB(
                                          255, 255, 245, 255),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                              'assets/image1.png',
                                              width: 60.0,
                                              height: 60.0),
                                        ),
                                        const SizedBox(height: 8.0),
                                        const Text(
                                          'Cliente',
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _navigateToInicioPage(
                                    context,
                                    'Bienvenido a la\n app para Conductoras',
                                    2);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  // Cuadro 2: Conductora
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 25.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 255, 175, 184),
                                          width: 3),
                                      color: const Color.fromARGB(
                                          255, 255, 245, 255),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                              'assets/image2.png',
                                              width: 60.0,
                                              height: 60.0),
                                        ),
                                        const SizedBox(height: 8.0),
                                        const Text(
                                          'Conductora',
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        const Text(
                          'Vemos por tu seguridad',
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Color.fromARGB(255, 145, 145, 145),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        const Text(
                          'Pink Cart',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.normal,
                            color: Color.fromARGB(255, 255, 102, 196),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToInicioPage(
      BuildContext context, String tipoUsuario, int tipo) {
    Map<String, dynamic> data = {
      'TITULO': tipoUsuario,
      'TIPO': tipo,
    };

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InicioPage(data: data)),
    );
  }
}
