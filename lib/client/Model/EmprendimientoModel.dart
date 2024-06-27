import 'package:flutter/material.dart';

class EmprendimientoModel {
  final String descripcion;
  final String imagenLink;

  EmprendimientoModel({
    required this.descripcion,
    required this.imagenLink,
  });

  factory EmprendimientoModel.fromJson(Map<String, dynamic> json) {
    return EmprendimientoModel(
      descripcion: json['descripcion'] ?? '',
      imagenLink: json['imagenlink'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'descripcion': descripcion,
      'imagenink': imagenLink,
    };
  }
}
