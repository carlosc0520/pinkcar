import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

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
  Set<Polyline> _polyLines = {}; // Conjunto de polilíneas para mostrar la ruta
  late CameraPosition _initialCameraPosition;
  List<String> _originSuggestions = [];
  List<String> _destinationSuggestions = [];
  final String _googleApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962),
      zoom: 14.0,
    );
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
        title: Text('Mapa de Viaje'),
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
            polylines: _polyLines, // Mostrar polilíneas en el mapa
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
                          decoration: InputDecoration(
                            hintText: 'Partida...',
                            contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
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
                        icon: Icon(Icons.search),
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
                            _searchAndNavigate(_originSuggestions[index], isOrigin: true);
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
                          decoration: InputDecoration(
                            hintText: 'Destino...',
                            contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
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
                        icon: Icon(Icons.search),
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
                            _destinationController.text = _destinationSuggestions[index];
                            _searchAndNavigate(_destinationSuggestions[index], isOrigin: false);
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _handleGoToTrip();
        },
        label: Text('Ir al viaje'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _handleGoToTrip() async {
    String origin = _originController.text.trim();
    String destination = _destinationController.text.trim();

    if (origin.isEmpty || destination.isEmpty) {
      // Mostrar alerta si alguno de los campos está vacío
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Campos vacíos'),
          content: Text('Por favor ingresa tanto la partida como el destino.'),
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
    } else {
      // Ambos campos están llenos, proceder a marcar la ruta en el mapa
      await _markRoute(origin, destination);
    }
  }

  Future<void> _markRoute(String origin, String destination) async {
    try {
      final String baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';
      final String request = '$baseUrl?origin=$origin&destination=$destination&key=$_googleApiKey';
      final response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<LatLng> points = _decodePoly(data['routes'][0]['overview_polyline']['points']);
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
      _polyLines.clear(); // Limpiar polilíneas antes de añadir nuevas
      _markers.add(
        Marker(
          markerId: MarkerId('origin'),
          position: points.first,
          infoWindow: InfoWindow(
            title: 'Partida',
            snippet: '${points.first.latitude}, ${points.first.longitude}',
          ),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('destination'),
          position: points.last,
          infoWindow: InfoWindow(
            title: 'Destino',
            snippet: '${points.last.latitude}, ${points.last.longitude}',
          ),
        ),
      );
      _polyLines.add(
        Polyline(
          polylineId: PolylineId('route'),
          points: points,
          color: Colors.blue, // Color de la polilínea
          width: 5, // Ancho de la polilínea
        ),
      );
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngBounds(_boundsFromLatLngList(points), 100.0));
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
      southwest: LatLng(x0!, y0!),
      northeast: LatLng(x1!, y1!),
    );
  }

  Future<void> _searchPlace(String input, bool isOrigin) async {
    if (input.isEmpty) {
      setState(() {
        if (isOrigin) {
          _originSuggestions.clear();
        } else {
          _destinationSuggestions.clear();
        }
      });
      return;
    }

    final String baseUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final String request = '$baseUrl?input=$input&key=$_googleApiKey';
    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List predictions = data['predictions'];
      setState(() {
        if (isOrigin) {
          _originSuggestions = predictions.map((prediction) => prediction['description'] as String).toList();
        } else {
          _destinationSuggestions = predictions.map((prediction) => prediction['description'] as String).toList();
        }
      });
    } else {
      throw Exception('Error fetching suggestions');
    }
  }

  Future<void> _searchAndNavigate(String address, {required bool isOrigin}) async {
    try {
      final String baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json';
      final String request = '$baseUrl?address=$address&key=$_googleApiKey';
      final response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final location = data['results'][0]['geometry']['location'];
        final lat = location['lat'];
        final lng = location['lng'];

        _addMarker(LatLng(lat, lng), address);
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15.0));

        setState(() {
          if (isOrigin) {
            _originSuggestions.clear();
          } else {
            _destinationSuggestions.clear();
          }
        });
      } else {
        throw Exception('Error fetching location');
      }
    } catch (e) {
      print('Error al buscar dirección: $e');
    }
  }

  void _addMarker(LatLng position, String address) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('destination'),
          position: position,
          infoWindow: InfoWindow(
            title: address,
            snippet: 'Lat: ${position.latitude}, Lng: ${position.longitude}',
          ),
        ),
      );
    });
  }
}
