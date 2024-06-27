import 'package:flutter/material.dart';
import 'package:pink_car/client/Consultar.dart';
import 'package:pink_car/client/Model/EmprendimientoModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';

class FooterCard extends StatefulWidget {
  const FooterCard({Key? key}) : super(key: key);

  @override
  _FooterCardState createState() => _FooterCardState();
}

class _FooterCardState extends State<FooterCard> {
  List<EmprendimientoModel> imageData = [];
  ConsultarAPI _consultar = ConsultarAPI();

  @override
  void initState() {
    super.initState();
    _loadImageData();
  }

  Future<void> _loadImageData() async {
    try {
      imageData = await _consultar.getEmprendimientos(0);
      setState(
          () {}); // Actualiza el estado para reconstruir el widget con los datos cargados
    } catch (e) {
      print('Error al cargar los datos del footer: $e');
      // Maneja el error según tu aplicación
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageData == null || imageData.isEmpty) {
      return Container(
        height: 120.0,
        color: const Color.fromARGB(255, 238, 82, 100),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      height: 120.0,
      color: const Color.fromARGB(255, 238, 82, 100),
      child: CarouselSlider.builder(
        itemCount: imageData.length,
        options: CarouselOptions(
          height: 120.0,
          autoPlay: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          viewportFraction:
              0.33, // Ajusta esta fracción para mostrar tres imágenes a la vez
        ),
        itemBuilder: (BuildContext context, int index, int realIndex) {
          return _buildFooterCard(imageData[index]);
        },
      ),
    );
  }

  Widget _buildFooterCard(EmprendimientoModel emprendimiento) {
    return GestureDetector(
      onTap: () {
        _launchURL(emprendimiento.imagenLink);
      },
      child: Card(
        color: Colors.transparent,
        margin: const EdgeInsets.all(8.0),
        elevation: 0,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    emprendimiento.imagenLink,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Image.network(
                        'https://cdn-icons-png.flaticon.com/512/1257/1257249.png',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  emprendimiento.descripcion,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir $url';
    }
  }
}
