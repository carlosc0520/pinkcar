// ignore_for_file: library_private_types_in_public_api

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pink_car/client/Consultar.dart';
import 'package:pink_car/client/Model/TripDetails.dart';
import 'package:pink_car/client/Model/TripDetailsViaje.dart';

class TripDetailsView extends StatefulWidget {
  final TripDetails tripDetails;
  final ScrollController scrollController;
  final Function(TripDetails) handleTripDetailsChange;
  final Function? clearAll;
  const TripDetailsView({
    Key? key,
    required this.tripDetails,
    required this.scrollController,
    required this.handleTripDetailsChange,
    this.clearAll
  }) : super(key: key);

  @override
  _TripDetailsViewState createState() => _TripDetailsViewState();
}

class _TripDetailsViewState extends State<TripDetailsView> {
  final Random _random = Random();
  final List<String> carModels = [
    'Sedan',
    'SUV',
    'Hatchback',
    'Coupé',
    'Convertible',
    'Pickup'
  ];
  final List<String> carPlates = [
    'ABC123',
    'DEF456',
    'GHI789',
    'JKL012',
    'MNO345',
    'PQR678'
  ];

  ConsultarAPI _consultarAPI = ConsultarAPI();

  int _generateRandomNumber(int min, int max) =>
      min + _random.nextInt(max - min + 1);

  String _generateRandomCarModel() =>
      carModels[_random.nextInt(carModels.length)];

  String _generateRandomCarPlate() =>
      carPlates[_random.nextInt(carPlates.length)];
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.tripDetails.isTripStarted) {
        setState(() {
          widget.tripDetails.isTripStarted = true;
          widget.tripDetails.estrellas = _generateRandomNumber(1, 5);
          widget.tripDetails.viajes = _generateRandomNumber(1, 1000);
          widget.tripDetails.modelo = _generateRandomCarModel();
          widget.tripDetails.matricula = _generateRandomCarPlate();
          widget.tripDetails.total = widget.tripDetails.distance * 0.5;
        });

        widget.handleTripDetailsChange(widget.tripDetails);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
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
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'DATOS DEL VIAJE',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12.0),
              height: 2,
              color: Colors.pinkAccent,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/image1.png'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nombres: ${widget.tripDetails.driverName}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            for (var i = 0;
                                i < widget.tripDetails.estrellas;
                                i++)
                              const Icon(Icons.star, color: Colors.yellow),
                            const SizedBox(width: 5),
                            Text(
                              '(${widget.tripDetails.estrellas} Estrellas)',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Viajes: ${widget.tripDetails.viajes}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Llega en: ${_generateRandomNumber(10, 15)} min',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Método de Pago: ${widget.tripDetails.paymentMethod}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'INFORMACIÓN DEL VEHÍCULO',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          height: 2,
                          color: Colors.pinkAccent,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Categoría: ',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        'Pink Car',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Text(
                                        'Modelo: ',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        widget.tripDetails.modelo,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Text(
                                        'Matrícula: ',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        widget.tripDetails.matricula,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Text(
                                        'Conductor: ',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        '${widget.tripDetails.driverName}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const CircleAvatar(
                              radius: 50,
                              backgroundColor:
                                  Color.fromARGB(255, 245, 245, 245),
                              child: Icon(
                                Icons.directions_car,
                                color: Colors.black,
                                size: 50,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12.0),
              height: 2,
              color: Colors.pinkAccent,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.map),
              const SizedBox(width: 10),
              Text(
                'Ruta de distancia ${widget.tripDetails.distance.toStringAsFixed(2)} km',
                style: const TextStyle(fontSize: 18),
              ),
            ]),
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.monetization_on),
              const SizedBox(width: 10),
              Text(
                'Precio: \S/.${(widget.tripDetails.distance * 0.5).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18),
              ),
            ]),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {  
                await _consultarAPI
                    .agregarViaje(widget.tripDetails)
                    .then((value) {
                      if(value.essatisfactoria == true){
                        widget.clearAll!();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white, // Fondo blanco
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
                              ),
                              title: Text(
                                'Viaje culminado',
                                style: TextStyle(
                                  color: Colors.black
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text(
                                      'El viaje ha sido culminado con éxito',
                                      style: TextStyle(
                                        color: Colors.black
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    'OK',
                                    style: TextStyle(
                                      color: Colors.red, // Botón OK en rojo
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Cerrar el diálogo
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }else{
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white, // Fondo blanco
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
                              ),
                              title: Text(
                                'Error',
                                style: TextStyle(
                                  color: Colors.black
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text(
                                      'Ha ocurrido un error al culminar el viaje',
                                      style: TextStyle(
                                        color: Colors.black
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    'OK',
                                    style: TextStyle(
                                      color: Colors.red, // Botón OK en rojo
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Cerrar el diálogo
                                  },
                                ),
                              ],
                            );
                          },
                        );

                      }
                    });
              },
              child: const Text('Culminar Viaje'),
            ),
          ],
        ),
      ),
    );
  }
}
