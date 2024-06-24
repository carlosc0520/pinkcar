import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pink_car/client/Consultar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pink_car/widgets/login/OlvidastesContrasena.dart';
import 'package:pink_car/widgets/login/Register.dart';
import 'package:pink_car/widgets/login/RegisterConductor.dart';
import 'package:pink_car/widgets/usuaria/BienvenidaUsuaria.dart';
import 'package:pink_car/widgets/usuaria/LayoutUsuaria.dart';

class AutenticacionPage extends StatefulWidget {
  final int tipo;

  const AutenticacionPage({super.key, this.tipo = 1});

  @override
  // ignore: library_private_types_in_public_api
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
        var usuario = await _consultar.getUsuario(email, password);
        if (usuario.status == true) {
          print(usuario.role);
          if (usuario.role == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Bienvenidausuaria()),
            );
          }
        } else {
          _consultar.mostrarError(
              context, usuario.message ?? 'Error de autenticación');
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
    _emailController.text = 'CCARBAJALMT0520@GMAIL.COM';
    _passwordController.text = '123456';
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Imagen con borde blanco
                    Container(
                      margin: const EdgeInsets.only(bottom: 20.0, top: 10),
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
                                'Iniciar sesión',
                                style: GoogleFonts.montserrat(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFD94A0),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              const Text(
                                'Regístrate y continúa',
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
                              const SizedBox(height: 8.0),
                              TextFormField(
                                controller: _passwordController,
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
                                      'Ingresar',
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
                              const SizedBox(height: 20.0),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Olvidastescontrasena(
                                                tipo: widget.tipo)),
                                  );
                                },
                                child: const Text(
                                  '¿Olvidaste tu contraseña?',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      widget.tipo == 1
                                          ? MaterialPageRoute(
                                              builder: (context) =>
                                                  Register(tipo: widget.tipo))
                                          : MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterConductor(
                                                      tipo: widget.tipo)));
                                },
                                child: const Text(
                                  'Crear usuario',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Color(0xFFFD94A0),
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
