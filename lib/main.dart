import 'package:Beats/ui/theme/bloc/theme_bloc.dart';
import 'package:Beats/ui/theme/bloc/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ui/splash-screen/splashscreen.dart';

main() async {
  runApp(
    BlocProvider(
      create: (context) => ThemeBloc(ThemeState(themeMode: ThemeMode.light)),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: myApp,
      ),
    ),
  );
}

Widget myApp(BuildContext context, ThemeState state) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Beats',
    theme: ThemeData.light().copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        color: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        textTheme: TextTheme(
          headline6: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
      ),
    ),
    darkTheme: ThemeData.dark().copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      canvasColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.grey[900],
      ),
      appBarTheme: AppBarTheme(color: Colors.black),
      popupMenuTheme: PopupMenuThemeData(color: Colors.black),
      dialogBackgroundColor: Colors.black,
    ),
    themeMode: state.props[0],
    home: SplashScreen(),
  );
}
