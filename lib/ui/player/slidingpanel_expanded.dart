import 'package:Beats/model/player.dart';
import 'package:Beats/ui/player/main_player.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingPanelExpanded extends StatelessWidget {
  final PanelController controller;

  const SlidingPanelExpanded({Key key, @required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          AppBar(
            centerTitle: true,
            title: RichText(
              maxLines: 2,
              textAlign: TextAlign.center,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Now Playing\n',
                    style: TextStyle(
                      wordSpacing: 2,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  TextSpan(
                      text: song?.album ?? '',
                      style: TextStyle(fontSize: 11.0)),
                ],
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.keyboard_arrow_down),
              onPressed: () => controller.close(),
            ),
          ),
          MainAudioPlayer(size: size),
        ],
      ),
    );
  }
}
