import 'dart:async';
import 'dart:ui';
import 'package:Beats/API/saavn.dart';
import 'package:Beats/model/player.dart';
import 'package:Beats/ui/player/nowplaying2.dart';
import 'package:Beats/style/appColors.dart';
import 'package:Beats/ui/homepage/widgets/home.dart';
import 'package:Beats/ui/homepage/widgets/search.dart';
import 'package:Beats/ui/homepage/widgets/searchlist.dart';
import 'package:Beats/ui/playlistpage.dart';
import 'package:Beats/ui/topsongs.dart';
import 'package:Beats/ui/widgets/albumpage.dart';
import 'package:Beats/ui/widgets/featuredplaylist.dart';
import 'package:Beats/ui/player/widgets/nowplayingmini.dart';
import 'package:Beats/utils/constants.dart';
import 'package:Beats/utils/themes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

import '../aboutPage.dart';

class Musify extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

const TWO_PI = 3.14 * 2;

class AppState extends State<Musify> {
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

  openNowPlaying() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NowPlaying2(songId: currentSongId)));
  }

  @override
  void dispose() {
    super.dispose();
    miniPlayer = new StreamController();
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    Column(
      children: [
        TopSongs(),
        Home(),
      ],
    ),
    Search(),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: accent,
          onTap: _onItemTapped,
        ),
        body: Stack(
          children: [
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  elevation: 0.0,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: GradientText(
                      "Beats",
                      shaderRect: Rect.fromLTWH(13.0, 0.0, 100.0, 50.0),
                      gradient: LinearGradient(colors: [
                        Colors.red[400],
                        Colors.orangeAccent[700],
                        Colors.orange,
                        Colors.yellow,
                        Colors.orange,
                        Colors.orangeAccent[700],
                        Colors.red[400],
                      ]),
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  actions: <Widget>[
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
                SliverList(
                  delegate: SliverChildListDelegate([
                    Stack(
                      children: [
                        //getBody(),
                        _widgetOptions.elementAt(_selectedIndex),
                      ],
                    ),
                  ]),
                )
              ],
            ),
            GestureDetector(
              onTap: openNowPlaying,
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: player != null
                    ? Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 25.0,
                        ),
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
}
