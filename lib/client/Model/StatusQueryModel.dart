class Statusquerymodel {
  int codestado;
  bool essatisfactoria;
  String mensaje;

  Statusquerymodel({
    required this.codestado,
    required this.essatisfactoria,
    required this.mensaje,
  });

  factory Statusquerymodel.fromJson(Map<String, dynamic> json) {
    return Statusquerymodel(
      codestado: json['codEstado'],
      essatisfactoria: json['esSatisfactoria'],
      mensaje: json['mensaje'],
    );
  }
}
