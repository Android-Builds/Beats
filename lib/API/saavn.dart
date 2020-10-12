import 'dart:convert';

import 'package:des_plugin/des_plugin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

List topSongsList = [];
String key = "38346591";
String decrypt = "";

Map hindiTokens = {
  'Trending today': 'I3kvhipIy73uCJW60TJk1Q__',
  'Weekly top': '8MT-LQlP35c_',
};
Map englishTokens = {
  'Trending today': 'I3kvhipIy73uCJW60TJk1Q__',
  'Weekly top': 'LdbVc1Z5i9E_',
};

class PlayList {
  String id;
  String name;
  String url;
  String followerCount;
  String username;
  String imageUrl;

  PlayList(
      {this.id,
      this.name,
      this.url,
      this.followerCount,
      this.username,
      this.imageUrl});

  factory PlayList.fromJson(Map<String, dynamic> json) {
    return PlayList(
      id: json['listid'],
      name: json['listname'],
      url: json['perma_url']
          .toString()
          .replaceAll("&amp;", "&")
          .replaceAll("&#039;", "'")
          .replaceAll("&quot;", "\""),
      followerCount: json['follower_count'],
      username: json['uid'],
      imageUrl: json['image']
          .toString()
          .replaceAll("&amp;", "&")
          .replaceAll("&#039;", "'")
          .replaceAll("&quot;", "\""),
    );
  }
}

Future fetchSongsList(searchQuery) async {
  String searchUrl =
      "https://www.jiosaavn.com/api.php?app_version=5.18.3&api_version=4&readable_version=5.18.3&v=79&_format=json&query=" +
          searchQuery +
          "&__call=autocomplete.get";
  var res = await http.get(searchUrl, headers: {"Accept": "application/json"});
  var resEdited = (res.body).split("-->");
  var getMain = json.decode(resEdited[1]);

  // searchedList = getMain["songs"]["data"];
  // for (int i = 0; i < searchedList.length; i++) {
  //   searchedList[i]['title'] = searchedList[i]['title']
  //       .toString()
  //       .replaceAll("&amp;", "&")
  //       .replaceAll("&#039;", "'")
  //       .replaceAll("&quot;", "\"");

  //   searchedList[i]['more_info']['singers'] = searchedList[i]['more_info']
  //           ['singers']
  //       .toString()
  //       .replaceAll("&amp;", "&")
  //       .replaceAll("&#039;", "'")
  //       .replaceAll("&quot;", "\"");

  //   searchedList[i]['image'] = searchedList[i]['image']
  //       .toString()
  //       .replaceAll('http', 'https')
  //       .replaceAll('httpss', 'https');
  // }
  //print(getMain);
  //print(getMain.keys);
  var a = getMain.keys.toList();
  print(a);
  return getMain;
}

List<PlayList> playlists = new List<PlayList>();

Future getFeaturedPlaylists() async {
  String language = 'hindi'; //TODO: Make language user selectable
  String url =
      'https://www.jiosaavn.com/api.php?__call=playlist.getFeaturedPlaylists&_marker=false&language=' +
          language +
          '&offset=1&size=250&_format=json';
  var playlistsJson =
      await http.get(url, headers: {"Accept": "application/json"});
  var featuredPlaylists = json.decode(playlistsJson.body);
  featuredPlaylists = featuredPlaylists['featuredPlaylists'];
  return featuredPlaylists;
}

getAlbumDetails(String listId) async {
  String playlistDetailsUrl =
      'https://www.jiosaavn.com/api.php?__call=content.getAlbumDetails&_format=json&cc=in&_marker=0%3F_marker%3D0&albumid=' +
          listId;
  var playListJSON = await http
      .get(playlistDetailsUrl, headers: {"Accept": 'application/json'});
  var playList = json.decode(playListJSON.body);
  //print(playList);
  return playList;
}

getPlaylistDetails(String listId) async {
  String playlistDetailsUrl =
      'https://www.jiosaavn.com/api.php?__call=playlist.getDetails&_format=json&cc=in&_marker=0%3F_marker%3D0&listid=' +
          listId;
  var playListJSON = await http
      .get(playlistDetailsUrl, headers: {"Accept": 'application/json'});
  var playList = json.decode(playListJSON.body);
  //print(playList);
  return playList;
}

Future<List> topSongs() async {
  String topSongsUrl =
      "https://www.jiosaavn.com/api.php?__call=webapi.get&token=8MT-LQlP35c_&type=playlist&p=1&n=20&includeMetaTags=0&ctx=web6dot0&api_version=4&_format=json&_marker=0";
  var songsListJSON =
      await http.get(topSongsUrl, headers: {"Accept": "application/json"});
  var songsList = json.decode(songsListJSON.body);
  topSongsList = songsList["list"];
  for (int i = 0; i < topSongsList.length; i++) {
    topSongsList[i]['title'] = topSongsList[i]['title']
        .toString()
        .replaceAll("&amp;", "&")
        .replaceAll("&#039;", "'")
        .replaceAll("&quot;", "\"");
    topSongsList[i]["more_info"]["artistMap"]["primary_artists"][0]["name"] =
        topSongsList[i]["more_info"]["artistMap"]["primary_artists"][0]["name"]
            .toString()
            .replaceAll("&amp;", "&")
            .replaceAll("&#039;", "'")
            .replaceAll("&quot;", "\"");
    topSongsList[i]['image'] = topSongsList[i]['image']
        .toString()
        .replaceAll("150x150", "500x500")
        .replaceAll('http', 'https')
        .replaceAll('httpss', 'https');
  }
  return topSongsList;
}

class SongDetails {
  String kUrl = "",
      image = "",
      title = "",
      album = "",
      artist = "",
      lyrics,
      has_320,
      rawkUrl;
}

Future fetchSongDetails(songId) async {
  String songUrl =
      "https://www.jiosaavn.com/api.php?app_version=5.18.3&api_version=4&readable_version=5.18.3&v=79&_format=json&__call=song.getDetails&pids=" +
          songId;
  var res = await http.get(songUrl, headers: {"Accept": "application/json"});
  var resEdited = (res.body).split("-->");
  var songJson = json.decode(resEdited[1]);

  SongDetails details = new SongDetails();

  String kUrl = await DesPlugin.decrypt(
      key, songJson[songId]["more_info"]["encrypted_media_url"]);

  String rawkUrl = kUrl;

  final client = http.Client();
  final request = http.Request('HEAD', Uri.parse(kUrl))
    ..followRedirects = false;
  final response = await client.send(request);
  print(response);
  kUrl = (response.headers['location']);
  debugPrint(kUrl);

  details.rawkUrl = rawkUrl;
  details.kUrl = kUrl;

  details.title = songJson[songId]["title"]
      .toString()
      .split("(")[0]
      .replaceAll("&amp;", "&")
      .replaceAll("&#039;", "'")
      .replaceAll("&quot;", "\"");
  details.image = songJson[songId]["image"]
      .toString()
      .replaceAll('http', 'https')
      .replaceAll('httpss', 'https')
      .replaceAll("150x150", "500x500");
  print(details.image);
  details.album = songJson[songId]["more_info"]["album"]
      .toString()
      .replaceAll("&quot;", "\"")
      .replaceAll("&#039;", "'")
      .replaceAll("&amp;", "&");

  try {
    details.artist = songJson[songId]["more_info"]["artistMap"]
            ["primary_artists"][0]["name"]
        .toString()
        .replaceAll("&quot;", "\"")
        .replaceAll("&#039;", "'")
        .replaceAll("&amp;", "&");
  } catch (e) {
    details.artist = "Unknown";
  }

  details.lyrics =
      await getLyrics(songJson, songId, details.artist, details.title);

  return details;
}

getLyrics(Map<String, dynamic> songJson, String songId, String artist,
    String title) async {
  String lyrics1;
  if (songJson[songId]["more_info"]["has_lyrics"] == "true") {
    String lyricsUrl =
        "https://www.jiosaavn.com/api.php?__call=lyrics.getLyrics&lyrics_id=" +
            songId +
            "&ctx=web6dot0&api_version=4&_format=json";
    var lyricsRes =
        await http.get(lyricsUrl, headers: {"Accept": "application/json"});
    var lyricsEdited = (lyricsRes.body).split("-->");
    var fetchedLyrics = json.decode(lyricsEdited[1]);
    lyrics1 = fetchedLyrics["lyrics"].toString().replaceAll("<br>", "\n");
  } else {
    lyrics1 = "null";
    String lyricsApiUrl =
        "https://sumanjay.vercel.app/lyrics/" + artist + "/" + title;
    var lyricsApiRes =
        await http.get(lyricsApiUrl, headers: {"Accept": "application/json"});
    var lyricsResponse = json.decode(lyricsApiRes.body);
    if (lyricsResponse['status'] == true && lyricsResponse['lyrics'] != null) {
      lyrics1 = lyricsResponse['lyrics'];
    }
  }
  return lyrics1;
}
