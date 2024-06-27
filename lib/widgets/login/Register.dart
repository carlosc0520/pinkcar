import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pink_car/client/Consultar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'Autenticacion.dart';

class Register extends StatefulWidget {
  final int tipo;

  const Register({super.key, this.tipo = 1});
  @override
  // ignore: library_private_types_in_public_api
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _nombresController = TextEditingController();
  final _emailController = TextEditingController();
  final _celularController = TextEditingController();
  final _dniController = TextEditingController();
  final _passwordController = TextEditingController();
  final _consultar = ConsultarAPI();

  bool _isLoading = false;

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final nombres = _nombresController.text.trim();
      final email = _emailController.text.trim();
      final celular = _celularController.text.trim();
      final dni = _dniController.text.trim();
      final password = _passwordController.text.trim();

      try {
        final respuesta = await _consultar.registrarUsuario(
          nombres: nombres,
          email: email,
          celular: celular,
          dni: dni,
          password: password,
          tipo: widget.tipo,
        );

        if (respuesta.essatisfactoria == true) {
          // ignore: use_build_context_synchronously
          _consultar.mostrarError(context, "Usuario registrado correctamente",
              title: "Exito!", onOkPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AutenticacionPage(tipo: widget.tipo),
              ),
            );
          });
        } else {
          // ignore: use_build_context_synchronously
          _consultar.mostrarError(
              // ignore: use_build_context_synchronously
              context,
              respuesta.mensaje ?? "Error al registrar usuario");
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        _consultar.mostrarError(context, e.toString());
      } finally {
        setState(() {
          _isLoading = false;
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
          Image.asset(
            'assets/PinkCar.jpg',
            fit: BoxFit.cover,
          ),
          ModalProgressHUD(
            inAsyncCall: _isLoading,
            progressIndicator: const CircularProgressIndicator(),
            child: Positioned.fill(
              child: Container(
                color:
                    const Color.fromARGB(255, 145, 145, 145).withOpacity(0.4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(bottom: 20.0, top: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 13.0,
                            ),
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
                    Flexible(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            children: <Widget>[
                              Text(
                                'Registro de Usuario',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              const Text(
                                'Ingrese los siguientes datos',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              _buildTextField(
                                label: 'Nombres y Apellidos',
                                controller: _nombresController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, ingrese su nombre completo';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10.0),
                              _buildTextField(
                                label: 'Email',
                                controller: _emailController,
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
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 10.0),
                              _buildTextField(
                                label: 'Celular',
                                controller: _celularController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, ingrese su número de celular';
                                  }
                                  if (!RegExp(r'^[0-9]{9}$').hasMatch(value)) {
                                    return 'Por favor, ingrese un número de celular válido';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.phone,
                              ),
                              const SizedBox(height: 10.0),
                              _buildTextField(
                                label: 'DNI',
                                controller: _dniController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, ingrese su número de DNI';
                                  }
                                  if (!RegExp(r'^[0-9]{8}$').hasMatch(value)) {
                                    return 'Por favor, ingrese un número de DNI válido';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 10.0),
                              _buildTextField(
                                label: 'Contraseña',
                                controller: _passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, ingrese su contraseña';
                                  }
                                  if (value.length < 6) {
                                    return 'La contraseña debe tener al menos 6 caracteres';
                                  }
                                  return null;
                                },
                                obscureText: true,
                              ),
                              const SizedBox(height: 20.0),
                              ElevatedButton(
                                onPressed: _handleRegister,
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.black,
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 20.0),
                                    child: const Text(
                                      'Registrarse',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0,
                                        color: Colors.white,
                                      ),
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required FormFieldValidator<String>? validator,
    TextInputType? keyboardType,
    bool obscureText = false,
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
          keyboardType: keyboardType,
          obscureText: obscureText,
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
      ],
    );
  }
}
