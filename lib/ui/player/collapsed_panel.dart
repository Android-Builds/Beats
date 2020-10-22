import 'package:Beats/API/bloc/api_bloc.dart';
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
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            children: [
              Container(
                height: kToolbarHeight * 0.9,
                width: kToolbarHeight * 0.9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(image),
                  ),
                ),
              ),
              Spacer(),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: title + '\n',
                  style: DefaultTextStyle.of(context)
                      .style
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 15.0),
                  children: <TextSpan>[
                    TextSpan(
                      text: artist,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              (state is ApiLoading || state is ApiError) ? loading() : loaded(),
            ],
          ),
        );
      },
    );
  }

  Widget loading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: CircularProgressIndicator(),
    );
  }

  Widget loaded() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.play_arrow),
          onPressed: () {},
        )
      ],
    );
  }
}
