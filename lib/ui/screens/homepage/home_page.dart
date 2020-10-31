import 'package:Beats/API/bloc/api_bloc.dart';
import 'package:Beats/ui/player/mini_player.dart';
import 'package:Beats/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Beats/API/saavn.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TopSongsList(map: topsongs),
              Home(),
            ],
          ),
        ),
        BlocBuilder<ApiBloc, ApiState>(
          builder: (context, state) {
            if (state is ApiInitial) {
              return SizedBox.shrink();
            } else {
              return MiniPlayer(
                image: topsongs[listindex]['image'],
                title: topsongs[listindex]['title'],
                artist: topsongs[listindex]['subtitle']
                    .toString()
                    .split('-')[1]
                    .trimLeft(),
              );
            }
          },
        ),
      ],
    );
  }
}

// RaisedButton(
//   child: Text('Top Songs'),
//   onPressed: () {
//     apicall = topSongs();
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => TopSongs(),
//       ),
//     );
//   },
// ),

class TopSongsList extends StatelessWidget {
  final map;
  const TopSongsList({
    Key key,
    @required this.map,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return BlocBuilder<ApiBloc, ApiState>(
      builder: (context, state) {
        return Center(
          child: Container(
            height: size * 0.8,
            child: GridView.count(
              physics: BouncingScrollPhysics(),
              crossAxisCount: 2,
              shrinkWrap: true,
              childAspectRatio: 1.2,
              scrollDirection: Axis.horizontal,
              children: List.generate(map.length, (index) {
                var data = map[index];
                return FlatButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    listindex = index;
                    apicall = fetchSongDetails(data['id']);
                    BlocProvider.of<ApiBloc>(context).add(FetchApi());
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: size * 0.3,
                          width: size * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            image: DecorationImage(
                              scale: 2.0,
                              image: CachedNetworkImageProvider(
                                data['image'],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        SizedBox(
                          width: size * 0.3,
                          child: Text(
                            data['title'],
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
