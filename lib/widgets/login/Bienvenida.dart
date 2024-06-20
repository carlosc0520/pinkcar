import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Usuario.dart';

class BienvenidaPage extends StatelessWidget {
  const BienvenidaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/PinkCar.jpg',
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                color:
                    const Color.fromARGB(255, 145, 145, 145).withOpacity(0.4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'BIENVENIDO',
                            style: GoogleFonts.montserrat(
                              fontSize: 23.0,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 238, 82, 100),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15.0),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UsuarioPage()),
                                );
                              },
                              child: Image.asset(
                                'assets/image.png',
                                width: 150.0,
                                height: 150.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          Text(
                            'Pink Car',
                            style: GoogleFonts.montserrat(
                              fontSize: 18.0,
                              fontWeight: FontWeight.normal,
                              color: const Color.fromARGB(255, 255, 102, 196),
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
          ),
        ],
      ),
    );
  }
}
