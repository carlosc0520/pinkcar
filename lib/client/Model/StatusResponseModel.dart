class Statusresponsemodel {
  bool status;
  String message;

  Statusresponsemodel({
    required this.status,
    required this.message,
  });

  factory Statusresponsemodel.fromJson(Map<String, dynamic> json) {
    return Statusresponsemodel(
      status: json['status'],
      message: json['message'],
    );
  }
}
