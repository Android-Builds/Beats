import 'package:Beats/API/saavn.dart';
import 'package:Beats/model/player.dart';
import 'package:Beats/nowplaying.dart';
import 'package:Beats/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AlbumPage extends StatefulWidget {
  final int index;

  const AlbumPage({
    Key key,
    @required this.index,
  }) : super(key: key);
  @override
  _AlbumPageState createState() => _AlbumPageState(index);
}

class _AlbumPageState extends State<AlbumPage> {
  final int index;

  _AlbumPageState(
    this.index,
  );

  TextStyle small = TextStyle(fontSize: 10.0, fontWeight: FontWeight.w200);
  TextStyle medium = TextStyle(
      fontSize: 13.0, fontWeight: FontWeight.w300, color: Colors.grey[680]);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            SizedBox(height: 20.0),
            Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: featuredPlaylists[index]['listname'],
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      height: 200,
                      width: 200,
                      imageUrl: featuredPlaylists[index]['image'],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 5.0, left: 20.0, right: 20.0, bottom: 5.0),
                  child: Text(featuredPlaylists[index]['listname'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w400)),
                ),
              ],
            ),
            FutureBuilder(
              future: getPlaylistDetails(featuredPlaylists[index]['listid']),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var songdata = snapshot.data['songs'];
                  int duration = 0;
                  songdata.forEach((element) {
                    duration += int.parse(element['duration']);
                  });
                  var data = snapshot.data;
                  duration = Duration(seconds: duration).inMinutes;
                  //print(data);
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 90.0,
                          vertical: 5.0,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 5.0),
                            Text(
                                featuredPlaylists[index]['language']
                                        .toString()
                                        //Make the first letter capital
                                        .replaceFirst(
                                            featuredPlaylists[index]['language']
                                                .toString()
                                                .substring(0, 1),
                                            featuredPlaylists[index]['language']
                                                .toString()
                                                .substring(0, 1)
                                                .toUpperCase()) +
                                    //Separator
                                    ' • ' +
                                    data['list_count'].toString() +
                                    ' Songs • ' +
                                    //Convert duration to minute,
                                    //then separate out hour and minute
                                    (duration / 60 < 1
                                        ? ''
                                        : (duration ~/ 60).toString() +
                                            ' hr ') +
                                    (duration % 60 == 0
                                        ? ''
                                        : (duration % 60).toString() + ' min'),
                                style: medium),
                            SizedBox(height: 5.0),
                            Text(
                                (data['fan_count'] / 1000).toStringAsFixed(1) +
                                    'K fans' +
                                    ' • ' +
                                    (int.parse(data['follower_count']) / 1000)
                                        .toStringAsFixed(1) +
                                    'K followers',
                                style: medium),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: songdata.length,
                        itemBuilder: (BuildContext context, int index) {
                          return FlatButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NowPlaying(
                                        songId:
                                            songdata[index]['id'].toString(),
                                        newSong: !(currentSongId ==
                                            songdata[index]['id']
                                                .toString())))),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 15.0),
                              child: Row(
                                children: [
                                  Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
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
                  return Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child: Center(child: CircularProgressIndicator()));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
