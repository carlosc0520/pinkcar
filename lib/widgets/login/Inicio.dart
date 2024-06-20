import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Autenticacion.dart';

class InicioPage extends StatelessWidget {
  final Map<String, dynamic> data;

  InicioPage({required this.data});

  @override
  Widget build(BuildContext context) {
    String titulo = data['TITULO'] ?? '';
    int tipo = data['TIPO'] ?? 1; // Valor por defecto 1 si no se proporciona

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/PinkCar.jpg',
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(255, 145, 145, 145).withOpacity(0.4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 20.0),
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
                    padding:
                        EdgeInsets.symmetric(vertical: 60.0, horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          titulo,
                          style: GoogleFonts.montserrat(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 238, 82, 100),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.0),
                        TextButton(
                          onPressed: () {
                            _navigate(context, tipo);
                          },
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    EdgeInsets.symmetric(horizontal: 16.0)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(255, 238, 82, 100)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Continuar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                  width:
                                      8), // Espacio entre el texto y el ícono
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )
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

  void _navigate(BuildContext context, int tipo) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AutenticacionPage(tipo: tipo)),
    );
  }
}
