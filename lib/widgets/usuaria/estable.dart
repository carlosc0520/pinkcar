import 'package:flutter/material.dart';
import 'package:pink_car/client/Model/TripDetails.dart';

class MetodoPago extends StatefulWidget {
  final ScrollController scrollController;

  // return MetodoPago(scrollController: scrollController, _tripDetails: _tripDetails);

  const MetodoPago(
      {Key? key,
      required this.scrollController,
      required handleTripDetailsChange(TripDetails tripDetails)})
      : super(key: key);

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
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
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
            SizedBox(height: 16.0),
            Text(
              'Lista de Conductoras',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            _buildDriverItem(
                1, 'assets/image1.png', 'Lucía Pérez', 'Categoría A'),
            _buildDriverItem(
                2, 'assets/image1.png', 'María Rodríguez', 'Categoría B'),
            _buildDriverItem(
                3, 'assets/image1.png', 'Ana Martínez', 'Categoría A'),
            SizedBox(height: 24.0),
            Divider(thickness: 1.0, color: Colors.grey),
            SizedBox(height: 16.0),
            Text(
              'Opciones de Pago',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            _buildPaymentOption('Pago en Efectivo', 1),
            _buildPaymentOption('Pago con Tarjeta', 2),
            _buildPaymentOption('Yape', 3),
            _buildPaymentOption('Pay', 4),
            SizedBox(height: 24.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showPaymentSelectionDialog();
                },
                child: Text('Seleccionar Tipo de Pago'),
              ),
            ),
            if (_showCardDetails) _buildCardDetailsForm(),
            SizedBox(height: 24.0),
            if (_selectedDetails != null) ...[
              Text(
                'Detalles Seleccionados:',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
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
              'paymentMethod': _selectedPayment,
              'paymentMethodId': _getPaymentMethodId(_selectedPayment),
            };
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
            SizedBox(width: 16.0),
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
                SizedBox(height: 4.0),
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
          });
        },
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
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
            SizedBox(height: 8.0),
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
          SizedBox(height: 24.0),
          Text(
            'Detalles de la Tarjeta',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: _cardNumberController,
            decoration: InputDecoration(
              labelText: 'Número de Tarjeta',
              hintText: 'Ingrese el número de su tarjeta',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
              ),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese el número de tarjeta';
              }
              if (value.length != 16) {
                return 'El número de tarjeta debe tener 16 dígitos';
              }
              if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                return 'Ingrese solo números';
              }
              return null;
            },
          ),
          SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _expiryDateController,
                  decoration: InputDecoration(
                    labelText: 'Fecha de Vencimiento',
                    hintText: 'YYYY/MM',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese la fecha de vencimiento';
                    }
                    // FORMAT YYYY/MM
                    if (!RegExp(r'^\d{4}\/\d{2}$').hasMatch(value)) {
                      return 'Formato inválido (YYYY/MM)';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: _cvvController,
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    hintText: 'CVV',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el CVV';
                    }
                    if (value.length != 3) {
                      return 'El CVV debe tener 3 dígitos';
                    }
                    if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                      return 'Ingrese solo números';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 24.0),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton(1),
                  _buildButton(2),
                  _buildButton(3),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton(4),
                  _buildButton(5),
                  _buildButton(6),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton(7),
                  _buildButton(8),
                  _buildButton(9),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _appendToField('0');
                  },
                  child: Text('0'),
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _removeLastCharacter();
                  },
                  child: Icon(Icons.backspace_outlined),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _validateAndAddCard();
                },
                child: Text('Agregar'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showCardDetails = false;
                  });
                },
                child: Text('Cancelar'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _appendToField(String digit) {
    setState(() {
      _cardNumberController.text = _cardNumberController.text + digit;
    });
  }

  Widget _buildButton(int number) {
    return ElevatedButton(
      onPressed: () {
        _appendToField(number.toString());
      },
      child: Text(
        number.toString(),
        style: TextStyle(
          fontSize: 24.0,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(16.0),
        shape: CircleBorder(),
      ),
    );
  }

  void _removeLastCharacter() {
    setState(() {
      if (_cardNumberController.text.isNotEmpty) {
        _cardNumberController.text = _cardNumberController.text
            .substring(0, _cardNumberController.text.length - 1);
      }
    });
  }

  void _validateAndAddCard() {
    if (_formKey.currentState!.validate()) {
      // Simulating card validation and saving
      _showSnackbar('Tarjeta agregada correctamente');
      setState(() {
        _showCardDetails = false;
        // Update selected details object if available
        if (_selectedDetails != null) {
          _selectedDetails!['paymentMethod'] = _selectedPayment;
          _selectedDetails!['paymentMethodId'] =
              _getPaymentMethodId(_selectedPayment);
        }
      });
    } else {
      _showSnackbar('Por favor corrija los errores');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showPaymentSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Seleccionar Tipo de Pago'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPaymentOptionDialog('Pago en Efectivo', 1),
            _buildPaymentOptionDialog('Pago con Tarjeta', 2),
            _buildPaymentOptionDialog('Yape', 3),
            _buildPaymentOptionDialog('Pay', 4),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptionDialog(String label, int paymentMethodId) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPayment = label;
          _showCardDetails = (label == 'Pago con Tarjeta');
          // Update selected details object if available
          if (_selectedDetails != null) {
            _selectedDetails!['paymentMethod'] = _selectedPayment;
            _selectedDetails!['paymentMethodId'] = paymentMethodId;
          }
        });
        Navigator.of(context).pop();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Image.asset(
                _getPaymentImagePath(label),
                height: 32.0,
                width: 32.0,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPaymentImagePath(String label) {
    switch (label) {
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

  int _getPaymentMethodId(String label) {
    switch (label) {
      case 'Pago en Efectivo':
        return 1;
      case 'Pago con Tarjeta':
        return 2;
      case 'Yape':
        return 3;
      case 'Pay':
        return 4;
      default:
        return 0; // Invalid
    }
  }
}
