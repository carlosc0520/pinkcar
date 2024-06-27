// ignore_for_file: library_private_types_in_public_api

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pink_car/client/Model/TripDetailsViaje.dart';

class TripDetailsView extends StatefulWidget {
  final TripDetailsViaje tripDetails;
  final ScrollController scrollController;

  // ignore: use_super_parameters
  const TripDetailsView({
    Key? key,
    required this.tripDetails,
    required this.scrollController,
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

  int _generateRandomNumber(int min, int max) =>
      min + _random.nextInt(max - min + 1);

  String _generateRandomCarModel() =>
      carModels[_random.nextInt(carModels.length)];

  String _generateRandomCarPlate() =>
      carPlates[_random.nextInt(carPlates.length)];

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
                    // Ensures the row takes up all available horizontal space
                    child: Column(
                      children: [
                        // Imagen del conductor
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
                        // Nombre del conductor
                        Text(
                          'Nombres: ${widget.tripDetails.driverName}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        // Calificación del conductor (usando un icono de estrella)
                        const Row(
                          children: [
                            Icon(Icons.star, color: Colors.yellow),
                            Icon(Icons.star, color: Colors.yellow),
                            Icon(Icons.star, color: Colors.yellow),
                            Icon(Icons.star, color: Colors.yellow),
                            Icon(Icons.star, color: Colors.yellow),
                            SizedBox(width: 5),
                            Text('(5 Estrellas)',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Número de viajes del conductor
                        const Text('Viajes: +250',
                            style: TextStyle(fontSize: 18)),
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
                  // Tiempo estimado de llegada
                  Text(
                    'Llega en: ${_generateRandomNumber(10, 15)} min',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  // Método de pago
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
                        // Información del vehículo
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
                                  // Categoría
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
                                  // Modelo del vehículo (aleatorio)
                                  Row(
                                    children: [
                                      const Text(
                                        'Modelo: ',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        _generateRandomCarModel(),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  // Matrícula del vehículo (aleatoria)
                                  Row(
                                    children: [
                                      const Text(
                                        'Matrícula: ',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        _generateRandomCarPlate(),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  // Conductor
                                  Row(
                                    children: [
                                      const Text(
                                        'Conductor: ',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        widget.tripDetails.driverName
                                            .toString(),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // foto vehículo, centrado y ciruclo gris, debe ser la imagen
                            const CircleAvatar(
                              radius: 50,
                              backgroundColor:
                                  Color.fromARGB(255, 245, 245, 245),
                              child: Icon(Icons.directions_car,
                                  color: Colors.black, size: 50),
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
            // Ruta de distancia en km
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.map),
                const SizedBox(width: 10),
                Text(
                  'Ruta de distancia ${widget.tripDetails.distance.toStringAsFixed(2)} km',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Botón para culminar viaje
            ElevatedButton(
              onPressed: () {
                // Acción al culminar viaje
              },
              child: const Text('Culminar Viaje'),
            ),
          ],
        ),
      ),
    );
  }
}
