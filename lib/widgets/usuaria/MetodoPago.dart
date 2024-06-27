import 'package:flutter/material.dart';
import 'package:pink_car/client/Model/TripDetails.dart';

class MetodoPago extends StatefulWidget {
  final ScrollController scrollController;
  final Function(TripDetails) handleTripDetailsChange;
  final TripDetails tripDetails;

  const MetodoPago({
    Key? key,
    required this.scrollController,
    required this.handleTripDetailsChange,
    required this.tripDetails,
  }) : super(key: key);

  @override
  _MetodoPagoState createState() => _MetodoPagoState();
}

class _MetodoPagoState extends State<MetodoPago> {
  String _selectedPayment = 'Pago en Efectivo'; // Método de pago por defecto
  bool _showCardDetails = false;
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  TextEditingController _cvvController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TripDetails _tripDetailsChildren = TripDetails();

  // Objeto para almacenar detalles seleccionados
  Map<String, dynamic>? _selectedDetails;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.tripDetails.driverId != null) {
      _selectedDetails = {
        'driverId': widget.tripDetails.driverId,
        'driverName': widget.tripDetails.driverName,
        'paymentMethod': widget.tripDetails.paymentMethod,
        'paymentMethodId':
            _getPaymentMethodId(widget.tripDetails.paymentMethod!),
      };

      if (widget.tripDetails.paymentMethod != null) {
        _selectedPayment = widget.tripDetails.paymentMethod!;
        _showCardDetails =
            (widget.tripDetails.paymentMethod == 'Pago con Tarjeta');
      }
    }

    if (widget.tripDetails.cardNumber != null) {
      _cardNumberController.text = widget.tripDetails.cardNumber!;
    }
    if (widget.tripDetails.expiryDate != null) {
      _expiryDateController.text = widget.tripDetails.expiryDate!;
    }
    if (widget.tripDetails.cvv != null) {
      _cvvController.text = widget.tripDetails.cvv!;
    }
  }

  void _updateTripDetails() {
    _tripDetailsChildren = TripDetails(
      driverId: _selectedDetails?['driverId'],
      driverName: _selectedDetails?['driverName'],
      paymentMethod: _selectedPayment,
      cardNumber: _showCardDetails ? _cardNumberController.text : null,
      expiryDate: _showCardDetails ? _expiryDateController.text : null,
      cvv: _showCardDetails ? _cvvController.text : null,
    );

    widget.handleTripDetailsChange(_tripDetailsChildren);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 4.0,
                width: 50.0,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Lista de Conductoras',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            _buildDriverItem(
                1, 'assets/image1.png', 'Lucía Pérez', 'Categoría A'),
            _buildDriverItem(
                2, 'assets/image1.png', 'María Rodríguez', 'Categoría B'),
            _buildDriverItem(
                3, 'assets/image1.png', 'Ana Martínez', 'Categoría A'),
            const SizedBox(height: 24.0),
            const Divider(thickness: 1.0, color: Colors.grey),
            const SizedBox(height: 16.0),
            const Text(
              'Opciones de Pago',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            _buildPaymentOption('Pago en Efectivo', 1),
            _buildPaymentOption('Pago con Tarjeta', 2),
            _buildPaymentOption('Yape', 3),
            _buildPaymentOption('Pay', 4),
            const SizedBox(height: 24.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showPaymentSelectionDialog();
                },
                child: const Text('Seleccionar Tipo de Pago'),
              ),
            ),
            if (_showCardDetails) _buildCardDetailsForm(),
            const SizedBox(height: 24.0),
            if (_selectedDetails != null) ...[
              const Text(
                'Detalles Seleccionados:',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text('Conductora: ${_selectedDetails!['driverId']}'),
              Text('Método de Pago: ${_selectedDetails!['paymentMethod']}'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDriverItem(
      int driverId, String imagePath, String name, String category) {
    bool isSelected =
        _selectedDetails != null && _selectedDetails!['driverId'] == driverId;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedDetails = null; // Deseleccionar si ya está seleccionado
          } else {
            _selectedDetails = {
              'driverId': driverId,
              'driverName': name,
              'paymentMethod': _selectedPayment,
              'paymentMethodId': _getPaymentMethodId(_selectedPayment),
            };
          }
          _updateTripDetails();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: AssetImage(imagePath),
            ),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.blue : Colors.black,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String label, int paymentMethodId) {
    return Visibility(
      visible: _selectedPayment == label,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPayment = label;
            _showCardDetails = (label == 'Pago con Tarjeta');
            if (_selectedDetails != null) {
              _selectedDetails!['paymentMethod'] = _selectedPayment;
              _selectedDetails!['paymentMethodId'] = paymentMethodId;
            }
            _updateTripDetails();
          });
        },
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: _selectedPayment == label ? Colors.blue : Colors.grey,
                  width: 2.0,
                ),
              ),
              child: Image.asset(
                _getPaymentImagePath(label),
                height: 64.0,
                width: 64.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: _selectedPayment == label ? Colors.blue : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardDetailsForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24.0),
          const Text(
            'Detalles de la Tarjeta',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Número de Tarjeta',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese el número de tarjeta';
              }
              if (value.length != 16) {
                return 'El número de tarjeta debe tener 16 dígitos';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _expiryDateController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de Expiración (YYYY/MM)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la fecha de expiración';
                    }
                    if (!RegExp(r'^\d{4}/\d{2}$').hasMatch(value)) {
                      return 'Formato de fecha inválido (YYYY/MM)';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: TextFormField(
                  controller: _cvvController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'CVV (3 dígitos)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el CVV';
                    }
                    if (value.length != 3) {
                      return 'El CVV debe tener 3 dígitos';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateTripDetails();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Detalles de tarjeta actualizados'),
                      ),
                    );
                  }
                },
                child: const Text('Agregar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar diálogo sin actualizar
                },
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getPaymentImagePath(String paymentMethod) {
    switch (paymentMethod) {
      case 'Pago en Efectivo':
        return 'assets/image6.png';
      case 'Pago con Tarjeta':
        return 'assets/image5.png';
      case 'Yape':
        return 'assets/image7.png';
      case 'Pay':
        return 'assets/image8.png';
      default:
        return '';
    }
  }

  int _getPaymentMethodId(String paymentMethod) {
    switch (paymentMethod) {
      case 'Pago en Efectivo':
        return 1;
      case 'Pago con Tarjeta':
        return 2;
      case 'Yape':
        return 3;
      case 'Pay':
        return 4;
      default:
        return 0;
    }
  }

  void _showPaymentSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Seleccione el Método de Pago'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPaymentOptionDialogTile(
                'Pago en Efectivo',
                'assets/image6.png',
                () {
                  setState(() {
                    _selectedPayment = 'Pago en Efectivo';
                    _showCardDetails = false;
                    _updateTripDetails();
                  });
                  Navigator.of(context).pop();
                },
              ),
              _buildPaymentOptionDialogTile(
                'Pago con Tarjeta',
                'assets/image5.png',
                () {
                  setState(() {
                    _selectedPayment = 'Pago con Tarjeta';
                    _showCardDetails = true;
                    _updateTripDetails();
                  });
                  Navigator.of(context).pop();
                },
              ),
              _buildPaymentOptionDialogTile(
                'Yape',
                'assets/image7.png',
                () {
                  setState(() {
                    _selectedPayment = 'Yape';
                    _showCardDetails = false;
                    _updateTripDetails();
                  });
                  Navigator.of(context).pop();
                },
              ),
              _buildPaymentOptionDialogTile(
                'Pay',
                'assets/image8.png',
                () {
                  setState(() {
                    _selectedPayment = 'Pay';
                    _showCardDetails = false;
                    _updateTripDetails();
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentOptionDialogTile(
    String label,
    String imagePath,
    VoidCallback onTap,
  ) {
    return ListTile(
      title: Row(
        children: [
          Image.asset(
            imagePath,
            height: 24.0,
            width: 24.0,
          ),
          const SizedBox(width: 16.0),
          Text(label),
        ],
      ),
      onTap: onTap,
    );
  }
}
