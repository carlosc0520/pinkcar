import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pink_car/client/Consultar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AutenticacionPage extends StatefulWidget {
  final int tipo;

  AutenticacionPage({this.tipo = 1});

  @override
  _AutenticacionPageState createState() => _AutenticacionPageState();
}

class _AutenticacionPageState extends State<AutenticacionPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _consultar = ConsultarAPI();
  
  bool _isLoading = false; // Estado para controlar el spinner de carga

  void _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Mostrar spinner de carga
      });

      // Obtener email y contraseña desde los controladores
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        // Llamar al método getUsuario para la autenticación
        final usuario = await _consultar.getUsuario(email, password);
        if (usuario.status == true) {
          // Si el usuario es autenticado, navegar a la página de inicio
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => InicioPage(data: usuario.data),
          //   ),
          // );
        } else {
          _consultar.mostrarError(context, usuario.message ?? 'Error de autenticación');
        }
      } catch (e) {
        // alerta de errror
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
            inAsyncCall: _isLoading, // Mostrar spinner de carga si _isLoading es true
            progressIndicator: CircularProgressIndicator(), // Indicador de carga
            child: Positioned.fill(
              child: Container(
                color: const Color.fromARGB(255, 145, 145, 145)
                    .withOpacity(0.4), // Fondo oscuro transparente
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Imagen con borde blanco
                    Container(
                      margin: EdgeInsets.only(bottom: 20.0, top: 10),
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

                    // Cuadro con formulario de autenticación
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.only(left: 50.0, right: 50.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Iniciar sesión',
                                style: GoogleFonts.montserrat(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFD94A0),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'Regístrate y continúa',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 20.0),
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
                              SizedBox(height: 8.0),
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
                              SizedBox(height: 20.0),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Contraseña',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.0),
                              TextFormField(
                                controller: _passwordController,
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
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, ingrese su contraseña';
                                  }
                                  if (value.length < 6) {
                                    return 'La contraseña debe tener al menos 6 caracteres';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20.0),
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
                                    gradient: LinearGradient(
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
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 24.0),
                                    child: Text(
                                      'Ingresar',
                                      style: GoogleFonts.montserrat(
                                        color:
                                            const Color.fromARGB(255, 56, 56, 56),
                                        fontWeight: FontWeight.w900,
                                        fontSize: 17.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Text(
                                '¿Olvidaste tu contraseña?',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'Crear usuario',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Color(0xFFFD94A0),
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
