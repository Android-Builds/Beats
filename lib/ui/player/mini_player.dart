import 'package:Beats/ui/player/collapsed_panel.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'expanded_panel.dart';

class MiniPlayer extends StatelessWidget {
  final map;
  final String image;
  final String title;
  final String artist;

  const MiniPlayer({
    Key key,
    @required this.image,
    @required this.title,
    @required this.artist,
    this.map,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(map);
    final size = MediaQuery.of(context).size;
    return SlidingUpPanel(
      maxHeight: size.height,
      minHeight: kToolbarHeight * 1.2,
      collapsed: CollapsedPanel(
        title: title,
        image: image,
        artist: artist,
      ),
      panel: ExpandedPanel(
        title: map['title'],
        image: image,
        artist: map['subtitle'].toString().split('-')[0].trimLeft(),
        header: map['header_desc']
            .toString()
            .split("(")[0]
            .replaceAll("&amp;", "&")
            .replaceAll("&#039;", "'")
            .replaceAll("&quot;", "\""),
      ),
    );
  }
}
