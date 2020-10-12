import 'dart:async';
import 'dart:ui';
import 'package:Beats/API/saavn.dart';
import 'package:Beats/model/player.dart';
import 'package:Beats/nowplaying.dart';
import 'package:Beats/style/appColors.dart';
import 'package:Beats/ui/playlistpage.dart';
import 'package:Beats/ui/topsongs.dart';
import 'package:Beats/ui/widgets/albumpage.dart';
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
    searchedList = await fetchSongsList(searchQuery);
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
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //shrinkWrap: true,
                      children: [
                        SizedBox(height: 80.0),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 30.0,
                            top: 15.0,
                            bottom: 5,
                          ),
                          child: Text('Top Result', style: title),
                        ),
                        SearchList(type: 'topquery'),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 30.0,
                            top: 15.0,
                            bottom: 5,
                          ),
                          child: Text('Songs', style: title),
                        ),
                        SearchList(type: 'songs'),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 30.0,
                            top: 15.0,
                            bottom: 5,
                          ),
                          child: Text('Albums', style: title),
                        ),
                        SearchList(type: 'albums'),
                        //SearchList(type: 'songs'),
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
                        SizedBox(height: 20),
                        RaisedButton(
                          child: Text('Search'),
                          onPressed: () async {
                            Map a = await fetchSongsList('tum hi ho');
                            print(a['songs']);
                          },
                        ),
                        Container(height: 500, color: Colors.blueAccent),
                        Container(height: 500, color: Colors.blue[900])
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
                  onChanged: (String value) {
                    search();
                  },
                  controller: searchBar,
                  style: TextStyle(
                    fontSize: 15,
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
                            icon: Icon(
                              Icons.arrow_back,
                              color: accent,
                            ),
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

class SearchList extends StatefulWidget {
  final String type;
  const SearchList({Key key, @required this.type}) : super(key: key);
  @override
  _SearchListState createState() => _SearchListState(type);
}

class _SearchListState extends State<SearchList> {
  final String type;
  _SearchListState(this.type);

  List data = List();

  String getText(int index) {
    if (type == 'songs') {
      return data[index]['more_info']['singers'] +
          ' • ' +
          data[index]['more_info']['album'];
    }
    if (type == 'albums') {
      return data[index]['more_info']['year'].toString() +
          ' • ' +
          data[index]['more_info']['language']
              .toString()
              //Make the first letter capital
              .replaceFirst(
                  data[index]['more_info']['language']
                      .toString()
                      .substring(0, 1),
                  data[index]['more_info']['language']
                      .toString()
                      .substring(0, 1)
                      .toUpperCase()) +
          ' • ' +
          data[index]['more_info']['music'];
    }
    if (type == 'topquery') {
      return data[index]['description'];
    }
    return '';
  }

  getOnPressed(int index) {
    if (type == 'songs' || type == 'topquery')
      return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NowPlaying(
            songId: data[index]['id'].toString(),
            newSong: !(currentSongId == data[index]['id'].toString()),
          ),
        ),
      );
    if (type == 'albums') {
      print(data[index]['id'].toString());
      return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AlbumPage(
            data: data[index],
            // id: data[index]['id'].toString(),
            // language: data[index]['more_info']['languaue'],
            // imageUrl: data[index]['image'],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    data = searchedList[type]['data'];
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (BuildContext ctxt, int index) {
        //print(searchedList[index]);
        return Column(
          children: <Widget>[
            FlatButton(
              //need to add different onPressed methods for different types

              onPressed: () => getOnPressed(index),
              child: ListTile(
                leading: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(data[index]['image']
                          .toString()
                          .replaceAll('http', 'https')
                          .replaceAll('httpss', 'https')),
                    ),
                  ),
                ),
                title: Text(
                  (data[index]['title'])
                      .toString()
                      .split("(")[0]
                      .replaceAll("&quot;", "\"")
                      .replaceAll("&amp;", "&"),
                  style: medium.copyWith(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  (data[index]['explicit_content'].toString() == '1'
                          ? '🅴 '
                          : '') +
                      getText(index),
                  style: small.copyWith(
                      fontWeight: FontWeight.w400, fontSize: 11.0),
                ),
                trailing:
                    IconButton(icon: Icon(Icons.more_vert), onPressed: null),
              ),
            ),
          ],
        );
      },
    );
  }
}
