import 'package:Musify/style/appColors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SongProgressIndicator extends StatefulWidget {
  final double size;
  final String imageUrl;
  const SongProgressIndicator(
      {Key key, @required this.size, @required this.imageUrl})
      : super(key: key);
  @override
  _SongProgressIndicatorState createState() =>
      _SongProgressIndicatorState(size, imageUrl);
}

class _SongProgressIndicatorState extends State<SongProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  final double size;
  final String imageUrl;

  _SongProgressIndicatorState(this.size, this.imageUrl);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: 5000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.repeat();
  }

  @override
  void dispose() {
    super.dispose();
    controller.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: size,
          width: size,
          child: CircularProgressIndicator(
            value: animation.value,
            valueColor: AlwaysStoppedAnimation<Color>(accent),
          ),
        ),
        Container(
          height: size - 10.0,
          width: size - 10.0,
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(imageUrl),
          ),
        )
      ],
    );
  }
}
