import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pink_car/client/Model/TripDetails.dart';
import 'package:pink_car/client/Model/TripDetailsViaje.dart';
import 'package:pink_car/widgets/usuaria/TripDetailsView%20.dart';
import 'MetodoPago.dart';
import 'dart:math' show sin, cos, sqrt, atan2;

class Viaje extends StatefulWidget {
  const Viaje({Key? key}) : super(key: key);

  @override
  State<Viaje> createState() => ViajeState();
}

class ViajeState extends State<Viaje> {
  Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  Set<Marker> _markers = {};
  Set<Polyline> _polyLines = {};
  bool _isTripStarted = false;

  late CameraPosition _initialCameraPosition;
  List<String> _originSuggestions = [];
  List<String> _destinationSuggestions = [];
  final String _googleApiKey = 'AIzaSyCwRdmvj1XRynTHqL4kDR_0O4Ifiz7z51M';
  TripDetails _tripDetails = TripDetails();

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = const CameraPosition(
      target: LatLng(-12.0820196, -76.928234),
      zoom: 14.0,
    );
  }

  void handleTripDetailsChange(TripDetails newTripDetails) {
    setState(() {
      _tripDetails = newTripDetails;
    });
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Viaje'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: _markers,
            polylines: _polyLines,
          ),
          Positioned(
            top: 10.0,
            left: 10.0,
            right: 10.0,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _originController,
                          decoration: const InputDecoration(
                            hintText: 'Partida...',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15.0),
                          ),
                          onChanged: (value) {
                            _searchPlace(value, true);
                          },
                          onSubmitted: (value) {
                            _searchAndNavigate(value, isOrigin: true);
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          String query = _originController.text;
                          _searchAndNavigate(query, isOrigin: true);
                        },
                      ),
                    ],
                  ),
                  if (_originSuggestions.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _originSuggestions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_originSuggestions[index]),
                          onTap: () {
                            _originController.text = _originSuggestions[index];
                            _searchAndNavigate(_originSuggestions[index],
                                isOrigin: true);
                            setState(() {
                              _originSuggestions.clear();
                            });
                          },
                        );
                      },
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _destinationController,
                          decoration: const InputDecoration(
                            hintText: 'Destino...',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15.0),
                          ),
                          onChanged: (value) {
                            _searchPlace(value, false);
                          },
                          onSubmitted: (value) {
                            _searchAndNavigate(value, isOrigin: false);
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          String query = _destinationController.text;
                          _searchAndNavigate(query, isOrigin: false);
                        },
                      ),
                    ],
                  ),
                  if (_destinationSuggestions.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _destinationSuggestions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_destinationSuggestions[index]),
                          onTap: () {
                            _destinationController.text =
                                _destinationSuggestions[index];
                            _searchAndNavigate(_destinationSuggestions[index],
                                isOrigin: false);
                            setState(() {
                              _destinationSuggestions.clear();
                            });
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              _handleGoToTrip();
            },
            label: const Text('Agregar Detalles'),
            icon: const Icon(Icons.add),
          ),
          const SizedBox(height: 16.0), // Espacio entre los botones
          FloatingActionButton.extended(
            onPressed: () {
              _startTrip(); // Función para iniciar el viaje
            },
            label: const Text('Iniciar Viaje'),
            icon: const Icon(Icons.directions_car),
          ),
        ],
      ),
    );
  }

  Future<void> _handleGoToTrip() async {
    String origin = _originController.text.trim();
    String destination = _destinationController.text.trim();

    if (origin.isEmpty || destination.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Campos vacíos'),
          content:
              const Text('Por favor ingresa tanto la partida como el destino.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    } else {
      await _markRoute(origin, destination);
      showModalBottomSheet(
        // ignore: use_build_context_synchronously
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.25,
            maxChildSize: 0.75,
            builder: (context, scrollController) {
              return MetodoPago(
                  scrollController: scrollController,
                  handleTripDetailsChange: handleTripDetailsChange,
                  tripDetails: _tripDetails);
            },
          );
        },
      );
    }
  }

  Future<void> _startTrip() async {
    if (_tripDetails.driverId == null) {
      _showErrorDialog('Conductora no seleccionada',
          'Por favor selecciona una conductora antes de iniciar el viaje.');
      return;
    }

    if (_tripDetails.paymentMethod == null) {
      _showErrorDialog('Método de pago no seleccionado',
          'Por favor selecciona un método de pago antes de iniciar el viaje.');
      return;
    }

    if (_originController.text.isEmpty) {
      _showErrorDialog('Campos vacíos',
          'Por favor ingresa tanto la partida como el destino antes de iniciar el viaje.');
      return;
    }

    if (_destinationController.text.isEmpty) {
      _showErrorDialog('Campos vacíos',
          'Por favor ingresa tanto la partida como el destino antes de iniciar el viaje.');
      return;
    }

    if (_tripDetails.paymentMethod == 'Pago con Tarjeta') {
      if (_tripDetails.cardNumber == null ||
          _tripDetails.expiryDate == null ||
          _tripDetails.cvv == null) {
        _showErrorDialog('Datos de tarjeta incompletos',
            'Por favor ingresa todos los datos de la tarjeta antes de iniciar el viaje.');
        return;
      }
    }

    LatLng originLatLng = await _getLatLngFromAddress(_originController.text);
    LatLng destinationLatLng =
        await _getLatLngFromAddress(_destinationController.text);

    double distance = _calculateDistance(
      originLatLng.latitude,
      originLatLng.longitude,
      destinationLatLng.latitude,
      destinationLatLng.longitude,
    );

    if (!_isTripStarted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 16.0),
                      LinearProgressIndicator(),
                      SizedBox(height: 16.0),
                      Text(
                        'Calculando distancia y tarifa...',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -40,
                  child: Image.asset(
                    'assets/image2.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          );
        },
      );

      await Future.delayed(const Duration(seconds: 4));
      Navigator.of(context).pop();
    }
    _isTripStarted = true;
    TripDetailsViaje tripDetailsLocal = TripDetailsViaje(
      originAddress: _originController.text,
      destinationAddress: _destinationController.text,
      distance: distance,
      driverId: _tripDetails.driverId,
      driverName: _tripDetails.driverName,
      paymentMethod: _tripDetails.paymentMethod,
      cardNumber: _tripDetails.cardNumber,
      expiryDate: _tripDetails.expiryDate,
      cvv: _tripDetails.cvv,
    );

    showModalBottomSheet(
      // ignore: use_build_context_synchronously
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.25,
          maxChildSize: 0.75,
          builder: (context, scrollController) {
            return TripDetailsView(
                tripDetails: tripDetailsLocal,
                scrollController: scrollController);
          },
        );
      },
    );
  }

  Future<LatLng> _getLatLngFromAddress(String address) async {
    final String baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json';
    final String request = '$baseUrl?address=$address&key=$_googleApiKey';
    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final location = data['results'][0]['geometry']['location'];
      return LatLng(location['lat'], location['lng']);
    } else {
      throw Exception('Error fetching place coordinates');
    }
  }

  double _calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    const double pi = 3.1415926535897932;
    const double earthRadius = 6378.137; // Radio de la Tierra en kilómetros

    // Convertir grados a radianes
    double lat1 = startLatitude * pi / 180.0;
    double lon1 = startLongitude * pi / 180.0;
    double lat2 = endLatitude * pi / 180.0;
    double lon2 = endLongitude * pi / 180.0;

    // Diferencia de latitud y longitud
    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    // Aplicar la fórmula de Haversine
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Distancia en kilómetros
    double distance = earthRadius * c;
    return distance;
  }

  Future<void> _markRoute(String origin, String destination) async {
    try {
      final String baseUrl =
          'https://maps.googleapis.com/maps/api/directions/json';
      final String request =
          '$baseUrl?origin=$origin&destination=$destination&key=$_googleApiKey';
      final response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<LatLng> points =
            _decodePoly(data['routes'][0]['overview_polyline']['points']);
        _addRoute(points);
      } else {
        throw Exception('Error fetching directions');
      }
    } catch (e) {
      print('Error al buscar dirección: $e');
    }
  }

  List<LatLng> _decodePoly(String poly) {
    var list = <LatLng>[];
    int index = 0, len = poly.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double latDouble = lat / 1E5;
      double lngDouble = lng / 1E5;
      list.add(LatLng(latDouble, lngDouble));
    }

    return list;
  }

  Future<void> _addRoute(List<LatLng> points) async {
    setState(() {
      _markers.clear();
      _polyLines.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('origin'),
          position: points.first,
          infoWindow: InfoWindow(
            title: 'Partida',
            snippet: '${points.first.latitude}, ${points.first.longitude}',
          ),
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: points.last,
          infoWindow: InfoWindow(
            title: 'Destino',
            snippet: '${points.last.latitude}, ${points.last.longitude}',
          ),
        ),
      );
      _polyLines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: points,
          color: Colors.blue,
          width: 5,
        ),
      );
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(_boundsFromLatLngList(points), 100.0),
    );
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
      northeast: LatLng(x1!, y1!),
      southwest: LatLng(x0!, y0!),
    );
  }

  Future<void> _searchPlace(String input, bool isOrigin) async {
    const String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final String request = '$baseUrl?input=$input&key=$_googleApiKey';
    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> suggestions = [];
      for (var item in data['predictions']) {
        suggestions.add(item['description']);
      }
      setState(() {
        if (isOrigin) {
          _originSuggestions = suggestions;
        } else {
          _destinationSuggestions = suggestions;
        }
      });
    } else {
      throw Exception('Error fetching place suggestions');
    }
  }

  Future<void> _searchAndNavigate(String query,
      {required bool isOrigin}) async {
    const String baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json';
    final String request = '$baseUrl?address=$query&key=$_googleApiKey';
    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final location = data['results'][0]['geometry']['location'];
      final LatLng latLng = LatLng(location['lat'], location['lng']);
      _addMarker(latLng, isOrigin ? 'Partida' : 'Destino', query);
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14));
    } else {
      throw Exception('Error fetching place coordinates');
    }
  }

  void _addMarker(LatLng position, String title, String snippet) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(title),
          position: position,
          infoWindow: InfoWindow(
            title: title,
            snippet: snippet,
          ),
        ),
      );
    });
  }

  // agregar conductor para dialog error
  void _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}
