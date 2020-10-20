import 'package:Beats/style/appColors.dart';
import 'package:Beats/ui/custom_widgets/circular_checkbox_listtile.dart';
import 'package:Beats/ui/custom_widgets/theme_switch.dart';
import 'package:Beats/ui/theme/bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, state) {
                  if (state.themeMode == ThemeMode.light) {
                    return lightsvg(size);
                  } else if (state.themeMode == ThemeMode.dark) {
                    return darksvg(size);
                  } else {
                    bool darkmode = MediaQuery.of(context).platformBrightness ==
                        Brightness.dark;
                    return darkmode ? darksvg(size) : lightsvg(size);
                  }
                },
              ),
              SizedBox(height: 100),
              Transform.scale(
                scale: 1.2,
                child: Text('Choose your desired theme'),
              ),
              SizedBox(height: 40),
              ThemeSwitch(),
              SizedBox(height: 20),
              RoundCheckListTile(),
              SizedBox(height: 20),
              Row(
                children: [
                  Spacer(),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: accent,
                    height: 40,
                    minWidth: 80,
                    child: Text('Next ->'),
                    onPressed: () {},
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget lightsvg(size) {
    return SvgPicture.asset(
      'assets/white.svg',
      height: size * 0.7,
      width: size * 0.7,
    );
  }

  Widget darksvg(size) {
    return SvgPicture.asset(
      'assets/black.svg',
      height: size * 0.7,
      width: size * 0.7,
    );
  }
}

class RoundCheckListTile extends StatefulWidget {
  @override
  _RoundCheckListTileState createState() => _RoundCheckListTileState();
}

class _RoundCheckListTileState extends State<RoundCheckListTile> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return CircularCheckBoxListTile(
      value: value,
      position: CheckBoxPostion.trailing,
      title: Text('Or you can use System Theme'),
      onChanged: (val) {
        value = val;
        BlocProvider.of<ThemeBloc>(context).add(ThemeChanged(
            themeMode: value ? ThemeMode.system : ThemeMode.light));
        setState(() {});
      },
    );
  }
}
