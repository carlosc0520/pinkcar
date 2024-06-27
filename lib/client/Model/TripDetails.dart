class TripDetails {
  int? driverId;
  String? driverName;
  String? paymentMethod;
  String? cardNumber;
  String? expiryDate;
  String? cvv;

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
