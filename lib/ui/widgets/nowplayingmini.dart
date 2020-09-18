import 'package:Musify/ui/widgets/progressindicator.dart';
import 'package:flutter/material.dart';

class NowPlayingMini extends StatefulWidget {
  final double width;
  final double height;

  const NowPlayingMini({Key key, this.width, this.height}) : super(key: key);
  @override
  _NowPlayingMiniState createState() => _NowPlayingMiniState(width, height);
}

class _NowPlayingMiniState extends State<NowPlayingMini> {
  final double width;
  final double height;

  _NowPlayingMiniState(this.width, this.height);
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
            height: height,
            width: width,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(200.0)),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 100.0),
                    child: Text('Hi'),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: IconButton(
                      iconSize: 45.0,
                      icon: Icon(Icons.play_circle_filled),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            )),
        SongProgressIndicator(
          size: height + 10.0,
          imageUrl:
              'https://images-na.ssl-images-amazon.com/images/I/91SbOZDHMWL.jpg',
        ),
      ],
    );
  }
}
