import 'package:Beats/utils/constants.dart';
import 'package:Beats/utils/themes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List list = List();
  @override
  void initState() {
    super.initState();
    list = home['homeView']['modules'];
    //print(list[1]);
    print(list[0]['data'].length);
    // print(list[0]['data'][0]['title']['text']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        // outer ListView
        itemCount: list.length,
        itemBuilder: (_, index) {
          return SizedBox(
            height: 270.0,
            child: Lists(map: list[index]),
          );
        },
      ),
    );
  }
}

class Lists extends StatelessWidget {
  const Lists({
    Key key,
    @required this.map,
  }) : super(key: key);

  final Map map;

  @override
  Widget build(BuildContext context) {
    print(map['data'].length);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 10.0),
          child: Text(map['title'], style: title),
        ),
        Expanded(
          child: ListView.builder(
            // inner ListView
            scrollDirection: Axis.horizontal, // 1st add
            physics: BouncingScrollPhysics(), // 2nd add
            itemCount: map['data'].length,
            itemBuilder: (_, index) {
              String subtitle = map['data'][index]['be_subtitle'].length != 0
                  ? map['data'][index]['be_subtitle'][0]['text']
                  : '';
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 10.0,
                    ),
                    height: 120.0,
                    width: 120.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          map['data'][index]['image'][0],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100.0,
                    child: Text(
                      map['data'][index]['title']['text'],
                      style: tiletitle,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  SizedBox(
                    width: 100.0,
                    child: Text(
                      subtitle,
                      style: small,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
