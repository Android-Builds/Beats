import 'package:Beats/API/bloc/api_bloc.dart';
import 'package:Beats/ui/screens/top_songs.dart';
import 'package:Beats/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:Beats/API/saavn.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RaisedButton(
          child: Text('Top Songs'),
          onPressed: () {
            apicall = topSongs();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TopSongs(),
              ),
            );
          },
        ),
      ],
    );
  }
}
