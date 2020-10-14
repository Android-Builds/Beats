import 'package:Beats/model/player.dart';
import 'package:Beats/ui/player/nowplaying.dart';
import 'package:Beats/ui/widgets/albumpage.dart';
import 'package:Beats/utils/constants.dart';
import 'package:Beats/utils/themes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
