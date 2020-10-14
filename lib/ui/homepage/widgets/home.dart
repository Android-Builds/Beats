import 'package:Beats/utils/constants.dart';
import 'package:Beats/utils/themes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String greet;

  @override
  void initState() {
    super.initState();
    greet = home[home.keys.last];
    //print(home[home.keys.elementAt(0)]);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      // outer ListView
      itemCount: home.length - 1,
      itemBuilder: (_, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              greet,
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
        return home.keys.elementAt(index - 1) != 'global_config'
            ? SizedBox(
                height: 220.0,
                child: Lists(
                  map: home[home.keys.elementAt(index - 1)],
                  listtitle: home.keys.elementAt(index - 1),
                ),
              )
            : SizedBox.shrink();
      },
    );
  }
}

class Lists extends StatelessWidget {
  const Lists({
    Key key,
    @required this.map,
    this.listtitle,
  }) : super(key: key);

  final map;
  final String listtitle;

  @override
  Widget build(BuildContext context) {
    var radius;
    if (listtitle == 'artist_recos' || listtitle == 'radio') {
      radius = BorderRadius.circular(100);
    } else {
      radius = BorderRadius.circular(5.0);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 10.0),
          child: Text(
              listtitle.replaceAll('_', ' ').replaceFirst(
                  listtitle.substring(0, 1),
                  listtitle.substring(0, 1).toUpperCase()),
              style: title),
        ),
        Expanded(
          child: ListView.builder(
            // inner ListView
            scrollDirection: Axis.horizontal, // 1st add
            physics: BouncingScrollPhysics(), // 2nd add
            itemCount: map.length,
            itemBuilder: (_, index) {
              String subtitle =
                  map[index]['subtitle'] != null ? map[index]['subtitle'] : '';
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 3.0,
                      vertical: 10.0,
                    ),
                    height: 120.0,
                    width: 120.0,
                    decoration: BoxDecoration(
                      borderRadius: radius,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          map[index]['image']
                              .toString()
                              .replaceAll("150x150", "500x500")
                              .replaceAll('http', 'https')
                              .replaceAll('httpss', 'https'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100.0,
                    child: Text(
                      map[index]['title'],
                      style: tiletitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  SizedBox(
                    width: 100.0,
                    child: Text(
                      subtitle,
                      style: small,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
