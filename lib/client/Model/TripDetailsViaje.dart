import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetailsViaje {
  final String originAddress;
  final String destinationAddress;
  final double distance;
  final int? driverId;
  final String? driverName;
  final String? paymentMethod;
  final String? cardNumber;
  final String? expiryDate;
  final String? cvv;

  TripDetailsViaje({
    required this.originAddress,
    required this.destinationAddress,
    required this.distance,
    this.driverId,
    this.driverName,
    this.paymentMethod,
    this.cardNumber,
    this.expiryDate,
    this.cvv,
  });

  factory TripDetailsViaje.fromJson(Map<String, dynamic> json) {
    return TripDetailsViaje(
      originAddress: json['originAddress'],
      destinationAddress: json['destinationAddress'],
      distance: json['distance'].toDouble(),
      driverId: json['driverId'],
      driverName: json['driverName'],
      paymentMethod: json['paymentMethod'],
      cardNumber: json['cardNumber'],
      expiryDate: json['expiryDate'],
      cvv: json['cvv'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'originAddress': originAddress,
      'destinationAddress': destinationAddress,
      'distance': distance,
      'driverId': driverId,
      'driverName': driverName,
      'paymentMethod': paymentMethod,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvv': cvv,
    };
  }
}
