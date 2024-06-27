class TripDetails {
  int? driverId;
  String? driverName;
  String? origin = "";
  String? destination = "";
  String? paymentMethod;
  String? cardNumber;
  String? expiryDate;
  String? cvv;
  bool isTripStarted = false;
  double distance = 0.0;
  int estrellas = 0;
  int viajes = 0;
  String modelo = "";
  String matricula = "";
  double total = 0.0;
  int idUsuario = 18;

  TripDetails({
    this.driverId,
    this.driverName,
    this.paymentMethod,
    this.cardNumber,
    this.expiryDate,
    this.cvv,
  });

  get vehicleType => null;

}
