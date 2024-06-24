import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pink_car/client/Consultar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pink_car/widgets/login/RegisterConductoraArchivos.dart';
import 'Autenticacion.dart';

class RegisterConductor extends StatefulWidget {
  final int tipo;

  const RegisterConductor({super.key, this.tipo = 2});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterConductorState createState() => _RegisterConductorState();
}

class _RegisterConductorState extends State<RegisterConductor> {
  final _formKey = GlobalKey<FormState>();
  final _nombresController = TextEditingController();
  final _emailController = TextEditingController();
  final _celularController = TextEditingController();
  final _dniController = TextEditingController();
  final _passwordController = TextEditingController();
  final _consultar = ConsultarAPI();

  bool _isLoading = false;

  void _handleRegisterConductor() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // ignore: unused_local_variable
      final nombres = _nombresController.text.trim();
      // ignore: unused_local_variable
      final email = _emailController.text.trim();
      // ignore: unused_local_variable
      final celular = _celularController.text.trim();
      // ignore: unused_local_variable
      final dni = _dniController.text.trim();
      // ignore: unused_local_variable
      final password = _passwordController.text.trim();
      // ignore: unused_local_variable
      final tipo = widget.tipo;

      try {
        // navigaer a otra ventana, pasarle los datos en objeto
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterConductoraArchivos(datos: {
              "NOMBRES": nombres,
              "EMAIL": email,
              "CELULAR": celular,
              "DNI": dni,
              "PASSWORD": password,
              "TIPO": tipo,
            },),
          ),
        );
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
                                'Registro de Conductora',
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
                                onPressed: _handleRegisterConductor,
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: const Color.fromARGB(
                                          255, 238, 82, 100)),
                                  child: Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 20.0),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
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
