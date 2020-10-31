import 'package:Beats/API/bloc/api_bloc.dart';
import 'package:Beats/model/player/bloc/player_bloc.dart';
import 'package:Beats/ui/screens/splash-screen/splashscreen.dart';
import 'package:Beats/ui/theme/bloc/theme_bloc.dart';
import 'package:Beats/ui/theme/bloc/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

main() async {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ThemeBloc>(
        create: (context) => ThemeBloc(ThemeState(themeMode: ThemeMode.light)),
      ),
      BlocProvider<ApiBloc>(
        create: (context) => ApiBloc(),
      ),
      BlocProvider<PlayerBloc>(
        create: (context) => PlayerBloc(),
      ),
    ],
    child: BlocBuilder<ThemeBloc, ThemeState>(
      builder: myApp,
    ),
  ));
}

Widget myApp(BuildContext context, ThemeState state) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent.withOpacity(0.3),
  ));
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
