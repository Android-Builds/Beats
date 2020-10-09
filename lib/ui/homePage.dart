import 'dart:async';
import 'dart:ui';
import 'package:Beats/API/saavn.dart';
import 'package:Beats/model/player.dart';
import 'package:Beats/nowplaying.dart';
import 'package:Beats/style/appColors.dart';
import 'package:Beats/ui/topsongs.dart';
import 'package:Beats/ui/widgets/featuredplaylist.dart';
import 'package:Beats/ui/widgets/nowplayingmini.dart';
import 'package:Beats/utils/constants.dart';
import 'package:Beats/utils/themes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

import 'aboutPage.dart';

class Musify extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

const TWO_PI = 3.14 * 2;

class AppState extends State<Musify> {
  TextEditingController searchBar = TextEditingController();
  bool fetchingSongs = false;
  bool searchNow = false;
  Size size;

  // DownloadEngine downloadEngine = new DownloadEngine();

  getLists() async {
    var list = await getFeaturedPlaylists();
    print(list[0].name);
  }

  void initState() {
    super.initState();
    miniPlayer.stream.listen((event) {
      setState(() {});
    });

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xff1c252a),
      statusBarColor: Colors.transparent,
    ));

    //TODO: Add Notification control for media

    // MediaNotification.setListener('play', () {
    //   setState(() {
    //     playerState = PlayerState.playing;
    //     status = 'play';
    //     audioPlayer.play(kUrl);
    //   });
    // });

    // MediaNotification.setListener('pause', () {
    //   setState(() {
    //     status = 'pause';
    //     audioPlayer.pause();
    //   });
    // });

    // MediaNotification.setListener("close", () {
    //   audioPlayer.stop();
    //   dispose();
    //   checker = "Nahi";
    //   MediaNotification.hideNotification();
    // });
  }

  search() async {
    String searchQuery = searchBar.text;
    if (searchQuery.isEmpty) return;
    fetchingSongs = true;
    setState(() {});
    await fetchSongsList(searchQuery);
    fetchingSongs = false;
    setState(() {});
  }

  openNowPlaying() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NowPlaying(songId: currentSongId)));
  }

  @override
  void dispose() {
    super.dispose();
    miniPlayer = new StreamController();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        // backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            getBody(),
            GestureDetector(
              onTap: openNowPlaying,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: player != null
                    ? Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.all(25.0),
                        child: NowPlayingMini(
                          width: size.width,
                          height: 80,
                        ),
                      )
                    : SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double width = 0.0;

  getBody() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              searchedList.isNotEmpty
                  ? ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(height: 80.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 5.0,
                          ),
                          child: Text('Songs', style: title),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: searchedList.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            print(searchedList[index]);
                            return Column(
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NowPlaying(
                                              songId: searchedList[index]['id']
                                                  .toString(),
                                              newSong: !(currentSongId ==
                                                  searchedList[index]['id']
                                                      .toString())))),
                                  child: ListTile(
                                    leading: Container(
                                      height: 40.0,
                                      width: 40.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              searchedList[index]['image']),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      (searchedList[index]['title'])
                                          .toString()
                                          .split("(")[0]
                                          .replaceAll("&quot;", "\"")
                                          .replaceAll("&amp;", "&"),
                                      style: medium.copyWith(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Text(
                                      (searchedList[index]['explicit_content']
                                                      .toString() ==
                                                  '1'
                                              ? '🅴 '
                                              : '') +
                                          searchedList[index]['more_info']
                                              ['singers'] +
                                          ' • ' +
                                          searchedList[index]['more_info']
                                              ['album'],
                                      style: small.copyWith(
                                          fontWeight: FontWeight.w400),
                                    ),
                                    trailing: IconButton(
                                        icon: Icon(Icons.more_vert),
                                        onPressed: null),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        SizedBox(height: 60),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 10.0,
                              ),
                              child: GradientText(
                                "Beats",
                                shaderRect:
                                    Rect.fromLTWH(13.0, 0.0, 100.0, 50.0),
                                gradient: LinearGradient(colors: [
                                  Colors.red[400],
                                  Colors.orangeAccent[700],
                                  Colors.orange,
                                  Colors.yellow,
                                ]),
                                style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              iconSize: 26,
                              alignment: Alignment.center,
                              icon: Icon(Icons.more_vert),
                              color: accent,
                              onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AboutPage(),
                                  ),
                                ),
                              },
                            ),
                          ],
                        ),
                        TopSongs(),
                        FeaturedPlayListWidget(),
                      ],
                    ),
            ],
          ),
        ),
        searchNow
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 20.0,
                ),
                child: TextField(
                  onSubmitted: (String value) {
                    search();
                  },
                  controller: searchBar,
                  style: TextStyle(
                    fontSize: 15,
                    color: accent,
                  ),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    fillColor: Color(0xff263238),
                    filled: true,
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      borderSide: BorderSide(
                        color: Color(0xff263238),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                    prefixIcon: searchNow
                        ? IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              setState(() {
                                searchNow = false;
                              });
                            },
                          )
                        : Container(height: 0.0),
                    suffixIcon: searchedList.isEmpty
                        ? IconButton(
                            icon: fetchingSongs
                                ? SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                accent),
                                      ),
                                    ),
                                  )
                                : Icon(
                                    Icons.search,
                                    color: accent,
                                  ),
                            color: accent,
                            onPressed: () {
                              setState(() {
                                search();
                              });
                            },
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: accent,
                            ),
                            onPressed: () {
                              setState(() {
                                searchedList.clear();
                                searchBar.clear();
                                FocusScope.of(context).unfocus();
                              });
                            }),
                    border: InputBorder.none,
                    hintText: "Search...",
                    hintStyle: TextStyle(
                      color: accent,
                    ),
                    contentPadding: const EdgeInsets.only(
                      left: 18,
                      right: 20,
                      top: 14,
                      bottom: 14,
                    ),
                  ),
                ),
              )
            : Positioned(
                top: 20.0,
                right: 20.0,
                child: FloatingActionButton(
                    child: Icon(Icons.search),
                    backgroundColor: Theme.of(context).backgroundColor,
                    mini: true,
                    onPressed: () {
                      setState(() {
                        width = 400.0;
                        searchNow = true;
                      });
                    }),
              ),
      ],
    );
  }
}
