import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AlbumPage extends StatefulWidget {
  final String image;
  final String tag;

  const AlbumPage({Key key, this.image, this.tag}) : super(key: key);
  @override
  _AlbumPageState createState() => _AlbumPageState(image, tag);
}

class _AlbumPageState extends State<AlbumPage> {
  final String image;
  final String tag;

  _AlbumPageState(this.image, this.tag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: tag,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    height: 200,
                    width: 200,
                    imageUrl: image,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(tag,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
