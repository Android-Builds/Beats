import 'package:Beats/ui/player/mini%20player/mini_player.dart';
import 'package:Beats/ui/player/slidingpanel_expanded.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingPanel extends StatefulWidget {
  @override
  _SlidingPanelState createState() => _SlidingPanelState();
}

class _SlidingPanelState extends State<SlidingPanel> {
  double position = 1;
  PanelController controller;

  @override
  void initState() {
    controller = new PanelController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      renderPanelSheet: false,
      controller: controller,
      color: Theme.of(context).scaffoldBackgroundColor,
      margin: EdgeInsets.only(
        bottom: kToolbarHeight * position,
      ),
      collapsed: MiniPlayer(),
      minHeight: kToolbarHeight * 1.15,
      maxHeight: MediaQuery.of(context).size.height,
      panel: SlidingPanelExpanded(controller: controller),
      onPanelSlide: (pos) {
        position = (pos - 1).abs();
        setState(() {});
      },
    );
  }
}
