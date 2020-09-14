// import 'dart:io';

// import 'package:Musify/API/saavn.dart';
// import 'package:Musify/style/appColors.dart';
// import 'package:audiotagger/audiotagger.dart';
// import 'package:audiotagger/models/tag.dart';
// import 'package:ext_storage/ext_storage.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:progress_dialog/progress_dialog.dart';
// import 'package:http/http.dart' as http;

// class DownloadEngine {
//   downloadSong(id, context) async {
//     String filepath;
//     String filepath2;
//     var status = await Permission.storage.status;
//     if (status.isUndetermined || status.isDenied) {
//       // code of read or write file in external storage (SD card)
//       // You can request multiple permissions at once.
//       Map<Permission, PermissionStatus> statuses = await [
//         Permission.storage,
//       ].request();
//       debugPrint(statuses[Permission.storage].toString());
//     }
//     status = await Permission.storage.status;
//     await fetchSongDetails(id);
//     if (status.isGranted) {
//       ProgressDialog pr = ProgressDialog(context);
//       pr = ProgressDialog(
//         context,
//         type: ProgressDialogType.Normal,
//         isDismissible: false,
//         showLogs: false,
//       );

//       pr.style(
//         backgroundColor: Color(0xff263238),
//         elevation: 4,
//         textAlign: TextAlign.left,
//         progressTextStyle: TextStyle(color: Colors.white),
//         message: "Downloading " + title,
//         messageTextStyle: TextStyle(color: accent),
//         progressWidget: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(accent),
//           ),
//         ),
//       );
//       await pr.show();

//       final filename = title + ".m4a";
//       final artname = title + "_artwork.jpg";
//       //Directory appDocDir = await getExternalStorageDirectory();
//       String dlPath = await ExtStorage.getExternalStoragePublicDirectory(
//           ExtStorage.DIRECTORY_MUSIC);
//       await File(dlPath + "/" + filename)
//           .create(recursive: true)
//           .then((value) => filepath = value.path);
//       await File(dlPath + "/" + artname)
//           .create(recursive: true)
//           .then((value) => filepath2 = value.path);
//       debugPrint('Audio path $filepath');
//       debugPrint('Image path $filepath2');
//       if (has_320 == "true") {
//         kUrl = rawkUrl.replaceAll("_96.mp4", "_320.mp4");
//         final client = http.Client();
//         final request = http.Request('HEAD', Uri.parse(kUrl))
//           ..followRedirects = false;
//         final response = await client.send(request);
//         debugPrint(response.statusCode.toString());
//         kUrl = (response.headers['location']);
//         debugPrint(rawkUrl);
//         debugPrint(kUrl);
//         final request2 = http.Request('HEAD', Uri.parse(kUrl))
//           ..followRedirects = false;
//         final response2 = await client.send(request2);
//         if (response2.statusCode != 200) {
//           kUrl = kUrl.replaceAll(".mp4", ".mp3");
//         }
//       }
//       var request = await HttpClient().getUrl(Uri.parse(kUrl));
//       var response = await request.close();
//       var bytes = await consolidateHttpClientResponseBytes(response);
//       File file = File(filepath);

//       var request2 = await HttpClient().getUrl(Uri.parse(image));
//       var response2 = await request2.close();
//       var bytes2 = await consolidateHttpClientResponseBytes(response2);
//       File file2 = File(filepath2);

//       await file.writeAsBytes(bytes);
//       await file2.writeAsBytes(bytes2);
//       debugPrint("Started tag editing");

//       final tag = Tag(
//         title: title,
//         artist: artist,
//         artwork: filepath2,
//         album: album,
//         lyrics: lyrics,
//         genre: null,
//       );

//       debugPrint("Setting up Tags");
//       final tagger = Audiotagger();
//       await tagger.writeTags(
//         path: filepath,
//         tag: tag,
//       );
//       await Future.delayed(const Duration(seconds: 1), () {});
//       await pr.hide();

//       if (await file2.exists()) {
//         await file2.delete();
//       }
//       debugPrint("Done");
//       Fluttertoast.showToast(
//           msg: "Download Complete!",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.black,
//           textColor: Color(0xff61e88a),
//           fontSize: 14.0);
//     } else if (status.isDenied || status.isPermanentlyDenied) {
//       Fluttertoast.showToast(
//           msg: "Storage Permission Denied!\nCan't Download Songs",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.black,
//           textColor: Color(0xff61e88a),
//           fontSize: 14.0);
//     } else {
//       Fluttertoast.showToast(
//           msg: "Permission Error!",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.values[50],
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.black,
//           textColor: Color(0xff61e88a),
//           fontSize: 14.0);
//     }
//   }
// }
