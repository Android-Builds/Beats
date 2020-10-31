import 'package:Beats/ui/custom_widgets/marquee_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ExpandedPanel extends StatelessWidget {
  final String image;
  final String title;

  const ExpandedPanel({
    Key key,
    this.image,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: size.width * 0.9,
            width: size.width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: CachedNetworkImageProvider(image),
              ),
            ),
          ),
          SizedBox(height: 50.0),
          SizedBox(
            width: size.width * 0.6,
            child: MarqueeWidget(
              child: Text(title + title + title + title),
            ),
          ),
        ],
      ),
    );
  }
}
