import 'package:Beats/API/bloc/api_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shimmer/shimmer.dart';

class TopSongs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: BlocProvider(
        create: (context) => ApiBloc(),
        child: BlocBuilder<ApiBloc, ApiState>(
          builder: (context, state) {
            BlocProvider.of<ApiBloc>(context).add(FetchApi());
            if (state is ApiLoaded) {
              return loaded(state.map, size);
            } else if (state is ApiError) {
              return error(state.message);
            } else {
              return loading(size);
            }
          },
        ),
      ),
    );
  }

  Widget loading(size) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      enabled: true,
      child: Center(
        child: Container(
          height: size * 0.8,
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: 1.2,
            scrollDirection: Axis.horizontal,
            children: List.generate(10, (index) {
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: size * 0.3,
                      width: size * 0.3,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      height: 6.0,
                      width: size * 0.3,
                      color: Colors.grey,
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget error(String message) {
    return Center(
      child: Row(
        children: [
          Icon(Ionicons.ios_sad),
          Spacer(),
          Text(message),
        ],
      ),
    );
  }

  Widget loaded(map, size) {
    // print(map);

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
            return Container(
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
            );
          }),
        ),
      ),
    );
  }
}
