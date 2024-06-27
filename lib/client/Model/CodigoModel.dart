class CodigoModel {
  final int? idcodigo;
  final String? codigo;
  final String? descripcion;
  final bool? status;
  final String? message;
  final int? id;
  final String? fcrcn; // Se agrega el campo para fcrcn

  CodigoModel({
    this.idcodigo,
    this.codigo,
    this.descripcion,
    this.status,
    this.message,
    this.id,
    this.fcrcn,
  });

  factory CodigoModel.fromJson(Map<String, dynamic> json) {
    return CodigoModel(
      idcodigo: json['idcodigo'],
      codigo: json['codigo'],
      descripcion: json['descripcion'],
      status: json['status'],
      message: json['message'],
      id: json['id'],
      fcrcn: json['fcrcn'], // Se agrega la asignación para fcrcn
    );
  }
}
