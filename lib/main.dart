import 'package:Musify/ui/splash-screen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:Musify/style/appColors.dart';

main() async {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "DMSans",
        accentColor: accent,
        primaryColor: accent,
        canvasColor: Colors.transparent,
      ),
      home: SplashScreen(),
    ),
  );
}
