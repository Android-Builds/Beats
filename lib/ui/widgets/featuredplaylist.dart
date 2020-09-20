import 'package:Beats/style/appColors.dart';
import 'package:Beats/ui/albumpage.dart';
import 'package:Beats/ui/widgets/morecontent.dart';
import 'package:Beats/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FeaturedPlayListWidget extends StatelessWidget {
  const FeaturedPlayListWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Text(
            'Featured PlayLists',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 22,
              color: accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.26,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: 11,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              if (index < 10) {
                return Container(
                  padding: EdgeInsets.all(5.0),
                  height: size.height * 0.2,
                  width: size.width * 0.4,
                  child: Column(
                    children: [
                      GestureDetector(
                        child: Hero(
                          tag: featuredPlaylists[index]['listname'],
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CachedNetworkImage(
                              imageUrl: featuredPlaylists[index]['image'],
                            ),
                          ),
                        ),
                        onTap: () {
                          print(featuredPlaylists[index]['listid']);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AlbumPage(
                                        image: featuredPlaylists[index]
                                            ['image'],
                                        tag: featuredPlaylists[index]
                                            ['listname'],
                                      )));
                        },
                      ),
                      SizedBox(height: 10),
                      Text(
                        featuredPlaylists[index]['listname'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return MoreContentWidget();
              }
            },
          ),
        )
      ],
    );
  }
}
