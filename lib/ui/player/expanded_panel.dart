import 'package:Beats/model/player/bloc/player_bloc.dart';
import 'package:Beats/model/player/player.dart';
import 'package:Beats/ui/custom_widgets/marquee_text.dart';
import 'package:Beats/ui/player/control_buttons.dart';
import 'package:Beats/ui/player/seekbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpandedPanel extends StatelessWidget {
  final String image;
  final String title;
  final String artist;
  final String header;

  const ExpandedPanel({
    Key key,
    this.image,
    this.title,
    this.artist,
    this.header,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.expand_more),
              // onPressed: () {
              //   controller.close();
              // },
            ),
            title: SizedBox(
              width: size.width * 0.6,
              child: MarqueeWidget(
                animationDuration: Duration(seconds: 15),
                pauseDuration: Duration(seconds: 2),
                backDuration: Duration(seconds: 15),
                child: Text(
                  header,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              height: size.width * 0.9,
              width: size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(image),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: BlocBuilder<PlayerBloc, PlayerState>(
              builder: (context, state) {
                if (state is PlayerInitial || state is PlayerLoading)
                  return SizedBox.shrink();
                else
                  return StreamBuilder<Duration>(
                    stream: player.durationStream,
                    builder: (context, snapshot) {
                      final duration = snapshot.data ?? Duration.zero;
                      return StreamBuilder<Duration>(
                        stream: player.positionStream,
                        builder: (context, snapshot) {
                          var position = snapshot.data ?? Duration.zero;
                          if (position > duration) {
                            position = duration;
                          }
                          return SeekBar(
                            duration: duration,
                            position: position,
                            onChangeEnd: (newPosition) {
                              player.seek(newPosition);
                            },
                          );
                        },
                      );
                    },
                  );
              },
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              children: [
                SizedBox(
                  width: size.width * 0.8,
                  child: MarqueeWidget(
                    animationDuration: Duration(seconds: 10),
                    backDuration: Duration(seconds: 10),
                    pauseDuration: Duration(seconds: 2),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                SizedBox(
                  width: size.width * 0.8,
                  child: MarqueeWidget(
                    animationDuration: Duration(seconds: 10),
                    backDuration: Duration(seconds: 10),
                    pauseDuration: Duration(seconds: 2),
                    child: Text(
                      artist,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 50.0),
          BlocBuilder<PlayerBloc, PlayerState>(
            builder: (context, state) {
              if (state is PlayerInitial || state is PlayerLoading)
                return SizedBox.shrink();
              else
                return ControlButtons(player);
            },
          ),
        ],
      ),
    );
  }
}
