import 'package:Beats/model/player.dart';
import 'package:Beats/style/appColors.dart';
import 'package:Beats/ui/widgets/morecontent.dart';
import 'package:Beats/ui/widgets/moretopsongs.dart';
import 'package:Beats/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../nowplaying.dart';

class TopSongs extends StatefulWidget {
  const TopSongs({
    Key key,
  }) : super(key: key);

  @override
  _TopSongsState createState() => _TopSongsState();
}

class _TopSongsState extends State<TopSongs> {
  ScrollController controller = new ScrollController();
  int scrollCount = 0;

  @override
  void initState() {
    scrollCount = 0;
    super.initState();
    controller.addListener(() {
      if (controller.position.atEdge && controller.position.pixels != 0) {
        if (++scrollCount == 2) {
          scrollCount = 0;
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MoreTopSongs()));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10.0,
          ),
          child: Text(
            "Top 10 Songs",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 22,
              color: accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.20,
          child: ListView.builder(
            controller: controller,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: 11,
            itemBuilder: (context, index) {
              if (index < 10) {
                return getTopSong(
                  topsongs[index]["image"],
                  topsongs[index]["title"],
                  topsongs[index]["more_info"]["artistMap"]["primary_artists"]
                      [0]["name"],
                  topsongs[index]["id"],
                );
              } else {
                return MoreContentWidget();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget getTopSong(String image, String title, String subtitle, String id) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    NowPlaying(songId: id, newSong: !(currentSongId == id))));
      },
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.30,
            child: Card(
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: CachedNetworkImage(imageUrl: image),
              ),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            title
                .split("(")[0]
                .replaceAll("&amp;", "&")
                .replaceAll("&#039;", "'")
                .replaceAll("&quot;", "\""),
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white38,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
