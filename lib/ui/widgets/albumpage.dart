import 'package:Beats/API/saavn.dart';
import 'package:Beats/model/player.dart';
import 'package:Beats/ui/player/nowplaying2.dart';
import 'package:Beats/style/appColors.dart';
import 'package:Beats/utils/themes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AlbumPage extends StatefulWidget {
  final data;

  const AlbumPage({
    Key key,
    this.data,
  }) : super(key: key);
  @override
  _AlbumPageState createState() => _AlbumPageState(data);
}

class _AlbumPageState extends State<AlbumPage> {
  final data;

  _AlbumPageState(
    this.data,
  );

  @override
  void initState() {
    super.initState();
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 300.0,
              stretch: true,
              stretchTriggerOffset: 150.0,
              onStretchTrigger: () {
                return;
              },
              flexibleSpace: FlexibleSpaceBar(
                //title: Text(featuredPlaylists[index]['listname']),
                stretchModes: [
                  StretchMode.zoomBackground,
                  StretchMode.fadeTitle,
                ],
                background: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(18.0),
                    bottomLeft: Radius.circular(18.0),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: data['image']
                        .toString()
                        .replaceAll("150x150", "500x500")
                        .replaceAll('http', 'https')
                        .replaceAll('httpss', 'https'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                FutureBuilder(
                  future: getAlbumDetails(data['id']),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data);
                      var songdata = snapshot.data['songs'];
                      int duration = 0;
                      songdata.forEach((element) {
                        duration += int.parse(element['duration']);
                      });
                      var albumdata = snapshot.data;
                      duration = Duration(seconds: duration).inMinutes;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 35.0,
                              vertical: 10.0,
                            ),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['more_info']['language']
                                              .toString()
                                              //Make the first letter capital
                                              .replaceFirst(
                                                  data['more_info']['language']
                                                      .toString()
                                                      .substring(0, 1),
                                                  data['more_info']['language']
                                                      .toString()
                                                      .substring(0, 1)
                                                      .toUpperCase()) +
                                          ' Album' +
                                          //Separator
                                          ' • ' +
                                          data['more_info']['year'],
                                      style: medium,
                                    ),
                                    SizedBox(height: 5.0),
                                    Text(
                                      (data['explicit_content'].toString() ==
                                                  '1'
                                              ? '🅴 • '
                                              : '') +
                                          songdata.length.toString() +
                                          (songdata.length > 1
                                              ? ' Songs'
                                              : ' Song') +
                                          ' • ' +
                                          albumdata['primary_artists'],
                                      style: medium,
                                    )
                                    // Text(
                                    //   (data['fan_count'] / 1000)
                                    //           .toStringAsFixed(1) +
                                    //       'K fans' +
                                    //       ' • ' +
                                    //       (int.parse(data['follower_count']) /
                                    //               1000)
                                    //           .toStringAsFixed(1) +
                                    //       'K followers',
                                    //   style: medium,
                                    // ),
                                  ],
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                  ),
                                  child: FloatingActionButton(
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NowPlaying2(
                                                songId: songdata[0]['id']
                                                    .toString(),
                                                newSong: !(currentSongId ==
                                                    songdata[0]['id']
                                                        .toString())))),
                                    backgroundColor: accent,
                                    child: Icon(
                                      Icons.play_arrow_outlined,
                                      size: 30.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: songdata.length,
                            itemBuilder: (BuildContext context, int index) {
                              return FlatButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NowPlaying2(
                                            songId: songdata[index]['id']
                                                .toString(),
                                            newSong: !(currentSongId ==
                                                songdata[index]['id']
                                                    .toString())))),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 12.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 50.0,
                                        width: 50.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                songdata[index]['image']),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      SizedBox(
                                        width: 200.0,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              songdata[index]['song'],
                                              maxLines: 2,
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(fontSize: 15.0),
                                            ),
                                            SizedBox(height: 5.0),
                                            Text(
                                              songdata[index]['album'] +
                                                  ' - ' +
                                                  songdata[index]['singers'],
                                              maxLines: 2,
                                              overflow: TextOverflow.clip,
                                              style: small,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    } else {
                      // return Container(
                      //     height: MediaQuery.of(context).size.height / 2,
                      //     child: Center(child: CircularProgressIndicator()));
                      return Container(
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 10.0,
                              ),
                              height: 25.0,
                              child: LinearProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.grey[50].withAlpha(20)),
                                backgroundColor: Colors.transparent,
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
