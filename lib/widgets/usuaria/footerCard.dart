import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';

class FooterCard extends StatelessWidget {
  final List<Map<String, String>> imageData = [
    {
      'url':
          'https://1.bp.blogspot.com/-Vz4DEENhYsI/XsABISxWl1I/AAAAAAAAcv8/dN9G4YsJG3gXCyc46LT-_n911qmmvsdjwCLcBGAsYHQ/s1600/E5.jpg',
      'title': 'Imagen 1',
      'link': 'https://www.ejemplo.com/enlace1',
    },
    {
      'url':
          'https://th.bing.com/th/id/OIP.chm63kcVXEErGRc0j5r4ewHaHc?w=1018&h=1024&rs=1&pid=ImgDetMain',
      'title': 'Imagen 2',
      'link': 'https://www.ejemplo.com/enlace2',
    },
    {
      'url':
          'https://th.bing.com/th/id/OIP.I1_zNHdgcL3_LiOZqs-9IwHaGM?w=800&h=670&rs=1&pid=ImgDetMain',
      'title': 'Imagen 3',
      'link': 'https://www.ejemplo.com/enlace3',
    },
    {
      'url':
          'https://th.bing.com/th/id/OIP.CcgKIfLwMLch1N6KTAB13gHaFw?w=2048&h=1593&rs=1&pid=ImgDetMain',
      'title': 'Imagen 4',
      'link': 'https://www.ejemplo.com/enlace4',
    },
  ];

  FooterCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.0,
      color: const Color.fromARGB(255, 238, 82, 100),
      child: CarouselSlider.builder(
        itemCount: imageData.length,
        options: CarouselOptions(
          height: 180.0,
          autoPlay: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          viewportFraction: 0.8,
        ),
        itemBuilder: (BuildContext context, int index, int realIndex) {
          return _buildFooterCard(imageData[index]);
        },
      ),
    );
  }

  Widget _buildFooterCard(Map<String, String> imageData) {
    return GestureDetector(
      onTap: () {
        _launchURL(imageData['link']!);
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
                    imageData['url']!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  imageData['title']!,
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
