class UsuarioModel {
  final String? nombres;
  final String? email;
  final String? celular;
  final String? dni;
  final String? password;
  final int? role;
  final bool? status;
  final String? message;
  final int? id;
  final String? fcrcn; // Se agrega el campo para fcrcn

  UsuarioModel({
    this.nombres,
    this.email,
    this.celular,
    this.dni,
    this.password,
    this.role,
    this.status,
    this.message,
    this.id,
    this.fcrcn,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      nombres: json['nombres'],
      email: json['email'],
      celular: json['celular'],
      dni: json['dni'],
      password: json['password'],
      role: json['role'],
      status: json['status'],
      message: json['message'],
      id: json['id'],
      fcrcn: json['fcrcn'], // Se agrega la asignación para fcrcn
    );
  }
}
