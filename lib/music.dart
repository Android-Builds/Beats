// import 'dart:async';
// import 'package:Musify/API/saavn.dart';
// import 'package:Musify/model/player.dart';
// import 'package:audioplayer/audioplayer.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:gradient_widgets/gradient_widgets.dart';
// import 'package:Musify/style/appColors.dart';

// String status = 'hidden';

// typedef void OnError(Exception exception);

// class NowPlaying extends StatefulWidget {
//   final bool newSong;
//   final String songId;
//   const NowPlaying({Key key, this.newSong = false, this.songId})
//       : super(key: key);
//   @override
//   NowPlayingState createState() => NowPlayingState(newSong, songId);
// }

// @override
// class NowPlayingState extends State<NowPlaying> {
//   Duration duration;
//   Duration position;

//   final bool newSong;
//   final String songId;

//   NowPlayingState(this.newSong, this.songId);

//   get isPlaying => state == PlayerState.playing;

//   get isPaused => state == PlayerState.paused;

//   get durationText =>
//       duration != null ? duration.toString().split('.').first : '';

//   get positionText =>
//       position != null ? position.toString().split('.').first : '';

//   bool isMuted = false;

//   StreamSubscription _positionSubscription;
//   StreamSubscription _audioPlayerStateSubscription;

//   @override
//   void initState() {
//     super.initState();
//     initAudioPlayer();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _positionSubscription.cancel();
//     _audioPlayerStateSubscription.cancel();
//   }

//   void initAudioPlayer() async {
//     song = await fetchSongDetails(songId);
//     if (player == null) {
//       initPlayer();
//     }
//     setState(() {
//       if (newSong) {
//         stop();
//         play();
//       } else {
//         if (state == PlayerState.paused) {
//           play();
//         } else {
//           //Using (Hack) Play() here Else UI glitch is being caused, Will try to find better solution.
//           // play();
//           // pause();
//         }
//       }
//     });

//     _positionSubscription = player.onAudioPositionChanged
//         .listen((p) => {if (mounted) setState(() => position = p)});

//     _audioPlayerStateSubscription = player.onPlayerStateChanged.listen((s) {
//       if (s == AudioPlayerState.PLAYING) {
//         {
//           if (mounted) setState(() => duration = player.duration);
//         }
//       } else if (s == AudioPlayerState.STOPPED) {
//         onComplete();
//         if (mounted)
//           setState(() {
//             position = duration;
//           });
//       }
//     }, onError: (msg) {
//       if (mounted)
//         setState(() {
//           state = PlayerState.stopped;
//           duration = Duration(seconds: 0);
//           position = Duration(seconds: 0);
//         });
//     });
//   }

//   Future play() async {
//     await player.play(song.kUrl);
//     // MediaNotification.showNotification(
//     //     title: title, author: artist, artUri: image, isPlaying: true);
//     if (mounted)
//       setState(() {
//         state = PlayerState.playing;
//       });
//   }

//   Future pause() async {
//     await player.pause();
//     // MediaNotification.showNotification(
//     //     title: title, author: artist, artUri: image, isPlaying: false);
//     setState(() {
//       state = PlayerState.paused;
//     });
//   }

//   Future stop() async {
//     await player.stop();
//     if (mounted)
//       setState(() {
//         state = PlayerState.stopped;
//         position = Duration();
//       });
//   }

//   Future mute(bool muted) async {
//     await player.mute(muted);
//     if (mounted)
//       setState(() {
//         isMuted = muted;
//       });
//   }

//   void onComplete() {
//     if (mounted) setState(() => state = PlayerState.stopped);
//   }

//   int segmentedControlGroupValue = 0;
//   Map<int, Widget> myTabs = <int, Widget>{
//     0: Text("Player"),
//     1: Text("Lyrics"),
//   };

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             Color(0xff384850),
//             Color(0xff263238),
//             Color(0xff263238),
//             //Color(0xff61e88a),
//           ],
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           brightness: Brightness.dark,
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           //backgroundColor: Color(0xff384850),
//           centerTitle: true,
//           title: GradientText(
//             "Now Playing",
//             shaderRect: Rect.fromLTWH(13.0, 0.0, 100.0, 50.0),
//             gradient: LinearGradient(colors: [
//               Color(0xff4db6ac),
//               Color(0xff61e88a),
//             ]),
//             style: TextStyle(
//               color: accent,
//               fontSize: 25,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           leading: Padding(
//             padding: const EdgeInsets.only(left: 14.0),
//             child: IconButton(
//               icon: Icon(
//                 Icons.keyboard_arrow_down,
//                 size: 32,
//                 color: accent,
//               ),
//               onPressed: () => Navigator.pop(context, false),
//             ),
//           ),
//         ),
//         body: Center(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: CupertinoSlidingSegmentedControl(
//                   backgroundColor: Colors.grey[600],
//                   thumbColor: accent,
//                   groupValue: segmentedControlGroupValue,
//                   children: myTabs,
//                   onValueChanged: (value) {
//                     setState(() {
//                       segmentedControlGroupValue = value;
//                     });
//                   },
//                 ),
//               ),
//               segmentedControlGroupValue == 0 ? getChild() : getLyrics(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   getLyrics() {
//     return song.lyrics != "null"
//         ? Expanded(
//             flex: 1,
//             child: Padding(
//               padding: const EdgeInsets.all(6.0),
//               child: Center(
//                 child: SingleChildScrollView(
//                   child: Text(
//                     song.lyrics,
//                     style: TextStyle(
//                       fontSize: 16.0,
//                       color: accentLight,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//             ),
//           )
//         : Padding(
//             padding: const EdgeInsets.only(top: 120.0),
//             child: Center(
//               child: Container(
//                 child: Text(
//                   "No Lyrics available ;(",
//                   style: TextStyle(color: accentLight, fontSize: 25),
//                 ),
//               ),
//             ),
//           );
//   }

//   getChild() {
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SizedBox(height: 20.0),
//           Container(
//             width: 300,
//             height: 300,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15.0),
//               shape: BoxShape.rectangle,
//               image: DecorationImage(
//                 fit: BoxFit.fill,
//                 image: CachedNetworkImageProvider(song.image),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 20.0),
//             child: Column(
//               children: <Widget>[
//                 GradientText(
//                   song.title,
//                   shaderRect: Rect.fromLTWH(13.0, 0.0, 100.0, 50.0),
//                   gradient: LinearGradient(colors: [
//                     Color(0xff4db6ac),
//                     Color(0xff61e88a),
//                   ]),
//                   textScaleFactor: 2.5,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Text(
//                     song.album + "  |  " + song.artist,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: accentLight,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Material(child: _buildPlayer()),
//         ],
//       ),
//     );
//   }

//   Widget _buildPlayer() => Container(
//         padding: EdgeInsets.symmetric(horizontal: 15.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (duration != null)
//               Slider(
//                   activeColor: accent,
//                   inactiveColor: Colors.green[50],
//                   value: position?.inMilliseconds?.toDouble() ?? 0.0,
//                   onChanged: (double value) {
//                     return player.seek((value / 1000).roundToDouble());
//                   },
//                   min: 0.0,
//                   max: duration.inMilliseconds.toDouble()),
//             if (position != null) _buildProgressView(),
//             Column(
//               children: <Widget>[
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     isPlaying
//                         ? Container(height: 0.0)
//                         : Container(
//                             decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     Color(0xff4db6ac),
//                                     //Color(0xff00c754),
//                                     Color(0xff61e88a),
//                                   ],
//                                 ),
//                                 borderRadius: BorderRadius.circular(100)),
//                             child: IconButton(
//                               onPressed: isPlaying ? null : () => play(),
//                               iconSize: 40.0,
//                               icon: Icon(Icons.play_arrow),
//                               color: Color(0xff263238),
//                             ),
//                           ),
//                     isPlaying
//                         ? Container(
//                             decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     Color(0xff4db6ac),
//                                     //Color(0xff00c754),
//                                     Color(0xff61e88a),
//                                   ],
//                                 ),
//                                 borderRadius: BorderRadius.circular(100)),
//                             child: IconButton(
//                               onPressed: isPlaying ? () => pause() : null,
//                               iconSize: 40.0,
//                               icon: Icon(Icons.pause),
//                               color: Color(0xff263238),
//                             ),
//                           )
//                         : Container()
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       );

//   Widget _buildProgressView() => Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15.0),
//         child: Row(mainAxisSize: MainAxisSize.min, children: [
//           Text(
//             position != null
//                 ? "${positionText ?? ''} ".replaceFirst("0:0", "0")
//                 : duration != null ? durationText : '',
//             style: TextStyle(fontSize: 18.0, color: Colors.green[50]),
//           ),
//           Spacer(),
//           Text(
//             position != null
//                 ? "${durationText ?? ''}".replaceAll("0:", "")
//                 : duration != null ? durationText : '',
//             style: TextStyle(fontSize: 18.0, color: Colors.green[50]),
//           )
//         ]),
//       );
// }
