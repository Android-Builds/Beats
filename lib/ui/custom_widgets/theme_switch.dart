import 'package:Beats/style/appColors.dart';
import 'package:Beats/ui/theme/bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeSwitch extends StatefulWidget {
  @override
  _ThemeSwitchState createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  bool switchvalue = false;
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.brightness_5, color: Colors.yellow[700]),
          SizedBox(width: 10.0),
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return CupertinoSwitch(
                activeColor: accent,
                trackColor: Colors.grey,
                value: switchvalue,
                onChanged: state.themeMode == ThemeMode.system
                    ? null
                    : (value) {
                        BlocProvider.of<ThemeBloc>(context).add(ThemeChanged(
                            themeMode:
                                value ? ThemeMode.dark : ThemeMode.light));
                        switchvalue = value;
                        setState(() {});
                      },
              );
            },
          ),
          SizedBox(width: 10.0),
          Icon(Icons.brightness_3, color: Colors.grey),
        ],
      ),
    );
  }
}
