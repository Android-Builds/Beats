import 'package:Beats/API/bloc/api_bloc.dart';
import 'package:Beats/model/player/bloc/player_bloc.dart';
import 'package:Beats/style/appColors.dart';
import 'package:Beats/ui/custom_widgets/marquee_text.dart';
import 'package:Beats/ui/player/play_pause_button.dart';
import 'package:Beats/ui/player/progressindicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollapsedPanel extends StatelessWidget {
  final String image;
  final String title;
  final String artist;

  const CollapsedPanel({
    Key key,
    @required this.image,
    @required this.title,
    @required this.artist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApiBloc, ApiState>(
      builder: (context, state) {
        if (state is ApiLoaded) {
          BlocProvider.of<PlayerBloc>(context).add(LoadPlayer(state.map));
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Row(
              children: [
                //SongProgressIndicator(image: image),
                Container(
                  height: kToolbarHeight * 0.9,
                  width: kToolbarHeight * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(image),
                    ),
                  ),
                ),
                SizedBox(width: 15.0),
                SizedBox(
                  width: 220.0,
                  child: MarqueeWidget(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          artist,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 13.0,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Spacer(),
                BlocBuilder<PlayerBloc, PlayerState>(
                  builder: (context, state) {
                    if (state is PlayerLoaded)
                      return loaded();
                    else
                      return loading();
                  },
                )
                //(state is ApiLoading || state is ApiError) ? loading() : loaded(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget loading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: CircularProgressIndicator(
        strokeWidth: 3.0,
        backgroundColor: accent.withAlpha(80),
        valueColor: AlwaysStoppedAnimation<Color>(accent),
      ),
    );
  }

  Widget loaded() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.scale(scale: 1.3, child: SongProgressIndicator()),
        Transform.scale(scale: 0.95, child: PlayPauseButton()),
      ],
    );
  }
}
