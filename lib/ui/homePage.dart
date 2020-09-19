import 'dart:async';
import 'dart:ui';
import 'package:Musify/model/downloadengine.dart';
import 'package:Musify/ui/topsongs.dart';
import 'package:Musify/ui/widgets/featuredplaylist.dart';
import 'package:Musify/ui/widgets/nowplayingmini.dart';
import 'package:Musify/ui/widgets/progressindicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_media_notification/flutter_media_notification.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:Musify/API/saavn.dart';
import 'package:Musify/music.dart';
import 'package:Musify/style/appColors.dart';
import 'package:Musify/ui/aboutPage.dart';

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

  // getSongDetails(String id, var context) async {
  //   try {
  //     await fetchSongDetails(id);
  //     print(kUrl);
  //   } catch (e) {
  //     artist = "Unknown";
  //     print(e);
  //   }
  //   setState(() {
  //     checker = "Haa";
  //   });
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => AudioApp(),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        // backgroundColor: Colors.transparent,

        //TODO: Implement mini player

        //backgroundColor: Color(0xff384850),
        // bottomNavigationBar: kUrl != ""
        //     ? Container(
        //         height: 75,
        //         //color: Color(0xff1c252a),
        //         decoration: BoxDecoration(
        //             borderRadius: BorderRadius.only(
        //                 topLeft: Radius.circular(18),
        //                 topRight: Radius.circular(18)),
        //             color: Color(0xff1c252a)),
        //         child: Padding(
        //           padding: const EdgeInsets.only(top: 5.0, bottom: 2),
        //           child: GestureDetector(
        //             onTap: () {
        //               checker = "Nahi";
        //               if (kUrl != "") {
        //                 Navigator.push(
        //                   context,
        //                   MaterialPageRoute(builder: (context) => AudioApp()),
        //                 );
        //               }
        //             },
        //             child: Row(
        //               children: <Widget>[
        //                 Padding(
        //                   padding: const EdgeInsets.only(
        //                     top: 8.0,
        //                   ),
        //                   child: IconButton(
        //                     icon: Icon(
        //                       MdiIcons.appleKeyboardControl,
        //                       size: 22,
        //                     ),
        //                     onPressed: null,
        //                     disabledColor: accent,
        //                   ),
        //                 ),
        //                 Padding(
        //                   padding: const EdgeInsets.only(
        //                       left: 0.0, top: 7, bottom: 7, right: 15),
        //                   child: ClipRRect(
        //                     borderRadius: BorderRadius.circular(8.0),
        //                     child: CachedNetworkImage(
        //                       imageUrl: image,
        //                       fit: BoxFit.fill,
        //                     ),
        //                   ),
        //                 ),
        //                 Padding(
        //                   padding: const EdgeInsets.only(top: 0.0),
        //                   child: Column(
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     children: <Widget>[
        //                       Text(
        //                         title,
        //                         style: TextStyle(
        //                             color: accent,
        //                             fontSize: 17,
        //                             fontWeight: FontWeight.w600),
        //                       ),
        //                       Text(
        //                         artist,
        //                         style:
        //                             TextStyle(color: accentLight, fontSize: 15),
        //                       )
        //                     ],
        //                   ),
        //                 ),
        //                 Spacer(),
        //                 IconButton(
        //                   icon: playerState == PlayerState.playing
        //                       ? Icon(MdiIcons.pause)
        //                       : Icon(MdiIcons.playOutline),
        //                   color: accent,
        //                   splashColor: Colors.transparent,
        //                   onPressed: () {
        //                     setState(() {
        //                       if (playerState == PlayerState.playing) {
        //                         audioPlayer.pause();
        //                         playerState = PlayerState.paused;
        //                         MediaNotification.showNotification(
        //                             title: title,
        //                             author: artist,
        //                             artUri: image,
        //                             isPlaying: false);
        //                       } else if (playerState == PlayerState.paused) {
        //                         audioPlayer.play(kUrl);
        //                         playerState = PlayerState.playing;
        //                         MediaNotification.showNotification(
        //                             title: title,
        //                             author: artist,
        //                             artUri: image,
        //                             isPlaying: true);
        //                       }
        //                     });
        //                   },
        //                   iconSize: 45,
        //                 )
        //               ],
        //             ),
        //           ),
        //         ),
        //       )
        //     : SizedBox.shrink(),

        body: Stack(
          children: [
            getBody(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.all(25.0),
                child: NowPlayingMini(
                  width: size.width,
                  height: 80,
                ),
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
            children: <Widget>[
              searchedList.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: searchedList.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Card(
                            color: Colors.black12,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 0,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10.0),
                              onTap: () {
                                // getSongDetails(
                                //     searchedList[index]["id"], context);
                              },
                              onLongPress: () {
                                topSongs();
                              },
                              splashColor: accent,
                              hoverColor: accent,
                              focusColor: accent,
                              highlightColor: accent,
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        MdiIcons.musicNoteOutline,
                                        size: 30,
                                        color: accent,
                                      ),
                                    ),
                                    title: Text(
                                      (searchedList[index]['title'])
                                          .toString()
                                          .split("(")[0]
                                          .replaceAll("&quot;", "\"")
                                          .replaceAll("&amp;", "&"),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      searchedList[index]['more_info']
                                          ["singers"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    trailing: IconButton(
                                      color: accent,
                                      icon: Icon(MdiIcons.downloadOutline),
                                      // onPressed: () =>
                                      //     downloadEngine.downloadSong(
                                      //         searchedList[index]["id"],
                                      //         context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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
                              icon: Icon(MdiIcons.dotsVertical),
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
